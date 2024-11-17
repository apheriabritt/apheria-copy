import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:apheria/constants.dart';
import 'package:apheria/data/scenesData.dart';
import 'package:apheria/homePages/AISignin.dart';
import 'package:apheria/main.dart';
import 'package:apheria/widgets/filecardui.dart';
import 'package:apheria/widgets/violetCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img; // Import the image package

class Violetcreationbuilder extends StatefulWidget {
  const Violetcreationbuilder({super.key});

  @override
  State<Violetcreationbuilder> createState() => _VioletcreationbuilderState();
}

class _VioletcreationbuilderState extends State<Violetcreationbuilder> {
  @override
  String creationIdea = '';
  String creationTitle = '';
  String creationFile = '';

  bool loading = true;

  void initState() {
    // TODO: implement initState
    super.initState();
    initialIntro();
  }

  initialIntro() async {
    setState(() {
      loading = true;
    });

    creationIdea = '';

    allfiles.shuffle();



    creationFile = allfiles.first;

    String path = 'images/files/${creationFile}.png';
    //String path = 'images/world/boutique.jpg';

    final byteData = await rootBundle.load(path);

    final buffer = byteData.buffer;

    





////
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/${path.split('/').last}';
    File imageFile = await File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    
img.Image newimage = img.decodeImage(
      imageFile.readAsBytesSync())!;

  // Resize the image to a 200 height thumbnail (maintaining the aspect ratio).
  img.Image thumbnail = img.copyResize(newimage, height: 200);

  if (thumbnail.numChannels == 4) {
    var imageDst = img.Image(
      width: thumbnail.width,
      height: thumbnail.height,
    ) // default format is uint8 and numChannels is 3 (no alpha)
    ..clear(
      img.ColorRgb8(255, 255, 255),
    ); // clear the image with the color white.

    thumbnail = img.compositeImage(
      imageDst,
      thumbnail,
    ); // alpha composite the image onto the white background
  }

  // Save the thumbnail as a JPG.
  imageFile.writeAsBytesSync(
    img.encodeJpg(thumbnail),
  );



// Provide a text prompt to include with the image
    final prompt = TextPart("think of an apheria creation to make with the image.explain materials and technique needed. keep entire reponse strictly under 100 characters");
// Prepare images for input
    final image = await imageFile.readAsBytes();
    final imagePart = InlineDataPart('image/jpeg', image);

// To stream generated text output, call generateContentStream with the text and image
    final response = await violet.generateContentStream([
      Content.multi([prompt, imagePart])
    ]);

   

    final stringBuilder = StringBuffer();


    try {
      await for (final chunk in response) {
        stringBuilder.write(chunk.text);
      }
    } catch (e) {
      creationIdea = e.toString();
    }

  

    final responseText = stringBuilder.toString();

    setState(() {
      creationIdea = responseText; // Use the accumulated string
    });

     final chat = violet.startChat();
      final content = Content.text('just 5 words to describe this creation: $creationIdea');

      final response2 = await chat.sendMessage(content);
      creationTitle = response2.text!;
      creationTitle = creationTitle
          .replaceAll(
            RegExp(r'\n+'),
            '\n',
          )
          .trim();

    setState(() {
      loading = false;
    });

    
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: apheriaAppBar(context, 'creation builder'),
        backgroundColor: apheriapurple,
        body: ListView(
          children: [
            VioletSpeech('welcome to my creation builder!'
          ,false,false),
            
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                  shape: curvedcard,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(loading == true ? 'thinking of a cool creation...' : creationTitle,
                            style:
                                TextStyle(color: apheriapurple, fontSize: 25)),
                        loading==true?Container():SizedBox(height: 12),
                        loading==true?Container():Text(
                          loading == true ? 'thinking...' : creationIdea,
                          style:
                              TextStyle(color: darkapheriapink, fontSize: 23),
                        ),
                        SizedBox(height: 12),
                        loading==true?Container():FileCardUI(0, creationFile, () {}, () {},
                            'violet creation builder'),
                        SizedBox(height: 12),
                        Card(
                            color: apheriapink,
                            elevation: 3,
                            child: Column(
                              children: [
                                ListTile(
                                  leading:
                                      Icon(Icons.refresh, color: Colors.white),
                                  title: Text('refresh'),
                                  onTap: initialIntro,
                                ),
                              ],
                            )),
                       /* Card(
                            color: darkapheriapink,
                            elevation: 3,
                            child: Column(
                              children: [
                                ListTile(
                                  leading:
                                      Icon(Icons.save, color: Colors.white),
                                  title: Text('save'),
                                  // onTap: initialIntro,
                                ),
                              ],
                            ))*/
                      ],
                    ),
                  )),
            )
          ],
        ));
  }
}
