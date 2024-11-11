import 'package:apheria/constants.dart';
import 'package:apheria/services/analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'dart:io';
import 'package:apheria/main.dart';

class VioletCard extends StatefulWidget {
  const VioletCard({super.key});

  @override
  State<VioletCard> createState() => _VioletCardState();
}

class _VioletCardState extends State<VioletCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 2),
      child: Card(
        shape:curvedcard,
        elevation:5,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Card(
            color:apherialilac,
            child: ListTile(
                onTap: () {
                  goTo(VioletChatBot(), context);
                },
                leading: Image.asset('images/icon/violet.png'),
                title: Text('stuck for inspiration?',
                    style: TextStyle(color: Colors.white)),
                subtitle:
                    Text('chat to violet', style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}


class VioletChatBot extends StatefulWidget {
  const VioletChatBot({super.key});

  @override
  State<VioletChatBot> createState() => _VioletChatBotState();
}

class _VioletChatBotState extends State<VioletChatBot> {
  @override
  String prompt = '';
  String responseText = 'thinking ...';
  String intro = 'thinking ...';

// TODO: Upload your files to Gemini API
// * 'Unknown File'
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialIntro();
  }

   

  initialIntro() async {
    try {
      final chat = violet.startChat();
      final content = Content.text('introduce yourself in 20 words');

      final response = await chat.sendMessage(content);
      intro = response.text!;
      intro = intro
          .replaceAll(
            RegExp(r'\n+'),
            '\n',
          )
          .trim();
    } catch (e) {
      intro = e.toString();
      // intro=intro.replaceAll(RegExp(r'\n+'), '\n',).trim();
    }
         logEvent('violet_chat', {'violet_intro': intro});

    setState(() {});

    try {
    
      final chat = violet.startChat();
      final content = Content.text(
          'write no more than 100 characters to help users write a prompt. you do not have to introduce yourself or apheria.');

      final response = await chat.sendMessage(content);
      responseText = response.text!;
      responseText = responseText
          .replaceAll(
            RegExp(r'\n+'),
            '\n',
          )
          .trim();
                   logEvent('violet_chat', {'violet_prompt': responseText.substring(0,responseText.length<100?responseText.length:100)});

    } catch (e) {
      responseText = e.toString();
      // intro=intro.replaceAll(RegExp(r'\n+'), '\n',).trim();
    }
    setState(() {});
  }

  final _controller = TextEditingController();
  bool loading = false;
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriapurple,
        appBar: apheriaAppBar(context, 'violet'),
        body: Column(
          children: [
            Row(
              children: [
                Image.asset('images/icon/violet.png', width: 150),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              intro,
                              style:
                                  TextStyle(color: apherialilac, fontSize: 20),
                            ),
                          ],
                        ),
                      )),
                ))
              ],
            ),
            Expanded(
              child: ListView(children: [
                prompt == ''
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('remember: violet is only AI, and your chats may be saved to improve her responses.'),
                    )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: apherialilac.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('you: $prompt'),
                            )),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      color: apherialilac,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('violet: $responseText'),
                      )),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _controller,
                          style: TextStyle(color: apheriapurple),
                          onChanged: (text) {
                            prompt = text;
                            //setState(() {});
                            // Update the email variable when the text field changes
                          },
                          decoration:
                              InputDecoration(hintText: 'ask violet something'),
                        ),
                      )),
                    ),
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      setState(() {
                        responseText = 'thinking ...';
                      });
                      try {
                        final chat = violet.startChat();
                        final content = Content.text(prompt+'keep response under 200 characters');
                                 logEvent('violet_chat', {'violet_user_prompt': prompt.substring(0,prompt.length<100?prompt.length:100)});

                        final response = await chat.sendMessage(content);
                        responseText = response.text!;
                        responseText = responseText
                            .replaceAll(
                              RegExp(r'\n+'),
                              '\n',
                            )
                            .trim();
                                     logEvent('violet_chat', {'violet_response': responseText.substring(0,responseText.length<100?responseText.length:100)});

                      } catch (e) {
                        responseText = e.toString();
                      }
                      setState(() {});
                      _controller.clear();
                    },
                    backgroundColor: apherialilac,
                  )
                ],
              ),
            ),
            // Text("violet is AI. she's only real inside the apheria app.",style:TextStyle(fontSize:18,color:Colors.white))
          ],
        ));
  }
}
