//flutter

import 'package:apheria/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//packages

//firebase

//other
import 'package:animate_do/animate_do.dart';
import 'package:page_transition/page_transition.dart';

//project

//data

//home pages

//services

//widgets

//other

bool isValidEmail(String email) {
  // Regular expression for basic email validation
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return emailRegExp.hasMatch(email);
}

Widget photoAvatar() {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: apheriaUser.photoURL == null
        ? CircleAvatar(
            backgroundImage: AssetImage('images/icon/photoUrl2.png'),
          )
        : CircleAvatar(backgroundImage: NetworkImage(apheriaUser.photoURL!)),
  );
}

Widget step(Widget leading, Widget title) {
  return Bounce(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 12,
        color: Color(0xff68b2ff),
        shape: curvedcardwithborder(Colors.white, 2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              title: title,
              leading: Image.asset(
                'images/icon/foreground.png',
                width: 75,
              )),
        ),
      ),
    ),
  );
}

AppBar apheriaAppBar(BuildContext context, String title) {
  return AppBar(
      backgroundColor: apheriapink,
      title: Text(title, style: TextStyle(color: Colors.white)),
      leading: IconButton(
        tooltip: 'back',
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ));
}

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

///this will end up being an interstitial ad I think
class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriapink,
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Pulse(
                    child: Image.asset('images/icon/planet.png',
                        color: Colors.white)))));
  }
}

class closeButton extends StatefulWidget {
  @override
  State<closeButton> createState() => _closeButtonState();
}

class _closeButtonState extends State<closeButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: FloatingActionButton(
              backgroundColor: apheriablue,
              child: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}

BoxDecoration glow =
    BoxDecoration(borderRadius: BorderRadius.circular(1000), boxShadow: [
  BoxShadow(
    color: Colors.amber,
    blurRadius: 12.0,
    spreadRadius: 7.0,
    offset: Offset(
      3.0,
      3.0,
    ),
  )
]);

//colours

Color apheriapink = Color(0xffffa4e2);
Color apheriablue = Color(0xff68b2ff);
Color apheriabluetwo = Color(0xff3e4894);
Color darkapheriapink = Color(0xffe072cc);
Color apheriaamber = Color(0xfffcdc08);
Color apheriapurple = Color.fromARGB(255, 63, 42, 67);
Color apherialilac = Color.fromARGB(255, 151, 81, 163);
Color apherialemon = Color(0xffffdc76);
Color apheriagreen = Color(0xff347166);
Color apheriapurpletwo = Color(0xffbb9ef5);
Color apherialavender = Color(0xffd7d0e7);

var curvedcard =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));

var curvycard =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0));

var circlecard =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(2000.0));

goTo(Widget page, BuildContext context) {
  if (page == null) {
  } else {
    Navigator.push(
      context,
      PageTransition(
          duration: Duration(milliseconds: 400),
          reverseDuration: Duration(milliseconds: 500),
          type: PageTransitionType.topToBottom,
          child: page),
    );
  }
}

goReplace(Widget page, BuildContext context) {
  if (page == null) {
  } else {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false);
  }
}

closePage(BuildContext context) {
  if (context == null) {
  } else {
    Navigator.pop(context);
  }
}

goToLoading(Widget page, BuildContext context) {
  if (page == null) {
  } else {
    Navigator.push(
      context,
      PageTransition(
          curve: Curves.bounceOut,
          type: PageTransitionType.rotate,
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 500),
          reverseDuration: Duration(milliseconds: 500),
          child: page),
    );
  }
}

goToPopUp(Widget page, BuildContext context) {
  if (page == null) {
  } else {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return page;
        }));
  }
}

curvedcardwithborder(Color color, double width) {
  return RoundedRectangleBorder(
      side: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(20.0));
}

double screenwidth(context) {
  return MediaQuery.of(context).size.width;
}

double screenheight(context) {
  return MediaQuery.of(context).size.height;
}

var backbar = PreferredSize(
  preferredSize: Size.fromHeight(100.0), // here the desired height
  child: SafeArea(
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatefulBuilder(builder: (context, setState) {
            return Padding(
                padding: const EdgeInsets.all(15.0),
                child: FloatingActionButton(
                  //mini:true,
                  backgroundColor: Color(0xffffa4e2),
                  heroTag: 'backbutton',
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pop();
                    });
                  },
                  elevation: 2.0,
                  child:
                      Icon(Icons.arrow_back, size: 35.0, color: Colors.white),
                ));
          }),
        ],
      ),
    ),
  ),
);


/*PickedFile? pickedFile = PickedFile('');
File pickedImage = File('');


Future getImage(BuildContext context) async
{
  ImagePicker picker = ImagePicker();
  pickedFile = await picker.getImage(
      source: ImageSource.gallery, imageQuality: 20);
  pickedImage=File(pickedFile.path);
  return context;
}

File currentImage=File('');
String currentImageURL='';*/



/*Future<void> saveToGallery(BuildContext context,GlobalKey repaintKey) async{
  print('saving to gallery');
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  final snackBar1 = SnackBar(
      backgroundColor: Colors.amber,
      content: Text('saving... please wait',style:TextStyle(color:Colors.white,fontSize: 22,fontFamily: 'apheriafont')));
  ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  ///REPLACE
  //Capture Done#
  File f = File('${appDocDirectory.path}/download.png');///might be this that doesnt work
  print('file f is $f');
  RenderRepaintBoundary? boundary = repaintKey.currentContext.findRenderObject();
  ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  await f.writeAsBytes(byteData.buffer.asUint8List());///problem up to here
  currentImage = f;
  await getStorageUrl('temp', currentImage,context);
  await ImageDownloader.downloadImage(currentImageURL); ///this is saving as a jpeg?
  //delete
  await FirebaseStorage.instance.refFromURL(currentImageURL).delete();
  final snackBar2 = SnackBar(
      backgroundColor: Color(0xffffa4e2),
      content: Text('saved to gallery!',style:TextStyle(color:Colors.white,fontSize: 22,fontFamily: 'apheriafont')));
  ScaffoldMessenger.of(context).showSnackBar(snackBar2);
  //FirebaseStorage.instance.refFromURL(currentImageURL).delete();
}*/

/*Future<void> getStorageUrl(String folderName,File myimage,BuildContext context) async{

  final Reference postImageRef = FirebaseStorage.instance.ref()
      .child(folderName);

  var timeKey = new DateTime.now();
  String fileName =  '${timeKey.toString()}.png';
  await postImageRef.child(fileName).putFile(myimage);

  ///this does upload for some reason
  await postImageRef.child(fileName).getDownloadURL().then((value) {
    print('image storage url is $value');
    currentImageURL=value;
  });
}*/

