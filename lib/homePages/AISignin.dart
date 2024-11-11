import 'package:apheria/constants.dart';
import 'package:apheria/homePages/filesHomePage.dart';
import 'package:apheria/homePages/world.dart';
import 'package:apheria/newTransferScreen.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:apheria/main.dart';
import 'package:googleapis/customsearch/v1.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

Future<String> violetText(String text, String errorHelp) async {
  String result = '';
  generate() async {
    final chat = violet.startChat();
    final content = Content.text(text);
    final response = await chat.sendMessage(content);
    result = response.text!;
    result = result
        .replaceAll(
          RegExp(r'\n+'),
          '\n',
        )
        .trim();
  }

  try {
    await generate();
  } catch (e) {
    if (errorHelp == 'ask_for_email') {
      result = "what's your email? heheh";
    } else if (errorHelp == 'ask_for_password') {
      result = "what's your password to sign in or register?";
    } else if (errorHelp == 'sign_in_error') {
      result =
          "hmmm. something's not quite right there... sleepy. either your password is too short or is incorrect. please try again with a password over 6 letters. wink";
    } else if (errorHelp == 'name_given_greeting') {
      result =
          "hey! how are you? let's get you signed up or logged in, so we can make some apheria creations. wink";
    } else if (errorHelp == 'invalid_email') {
      result =
          "hmmmm.. that email doesn't look quite right, try again with a valid email, heheh.";
    } else if (errorHelp == 'valid_email') {
      result =
          'hmm. that email looks good to me! can i have a password please? - to check if you are a new user or an existing user. wink. you can hide it using the button on the bottom left ...sleepy zz';
    } else {
      result =
          'oops. something went wrong. please press refresh in the top right corner! wink';
    }

    logEvent('sign_in_action',
        {'action': 'AI_error', 'ai_error_location': errorHelp});
//await generate();
    // intro=intro.replaceAll(RegExp(r'\n+'), '\n',).trim();
  }
  return result;
}

class VioletAISignIn extends StatefulWidget {
  const VioletAISignIn({super.key});

  @override
  State<VioletAISignIn> createState() => _VioletAISignInState();
}

class _VioletAISignInState extends State<VioletAISignIn> {
  @override
  String prompt = '';
  String responseText = 'thinking ...';
  String intro = 'thinking ...';
  String textPrompt = "type here";
  String name = '';
  String email = '';
  bool obscure = false;
  String password = '';
  String signinerror = 'error here';
  bool ready = false;
  String emailsenderror = '';
  FirebaseAuth apheriaauth = FirebaseAuth.instance;
  bool checking = true;
  String askName = "";
  String askEmail = "";
  String askPassword = "";
  String creationIdea = "";
  String signedinemail = '';
  bool introloading = true;
  bool checkLoading = true;

  String newuser =
      'new user created. welcome the user and tell them that they have been given 500 star points to redeem on files and scenes in the app. to get started try to redeem some files and add them to the canvas. you can then transfer them to your world using lightbox (tracing) or lens drawing (drawing through the camera) ... any issues just chat to violet in the upper left hand corner of the home screen. give them some inspiration to get started.';
  String welcomeback = 'welcome the user back to apheria in 10 words';
  String passwordissue =
      'email is already registered. the password is incorrect. ask users to try again. then, tell users to press the button below if forgotten your password and I will send you a link to reset it. if that doesnt work, please email app support via the play store.';

// TODO: Upload your files to Gemini API
// * 'Unknown File'
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkSignedIn();
  }

  checkSignedIn() async {
    checkLoading = true;
    loading = true;
    logEvent('sign_in_action', {'action': 'sign_in_screen'});

    bool signedin = false;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      email = await prefs.getString('email') ?? '';
      password = await prefs.getString('password') ?? '';

      await apheriaauth.signInWithEmailAndPassword(
          email: email, password: password);
      apheriaUser = apheriaauth.currentUser!;
      signedinemail = apheriaUser.email ?? '';

      if (isValidEmail(signedinemail) == true) {
        signedin = true;
      }
    } catch (e) {
      signedin = false;
    }

    checkLoading = false;
    setState(() {
      
    });

    if (signedin == true) {
      signinerror = welcomeback;
      ready = true;
      logEvent('sign_in_action', {'action': 'already_signed_in'});
      saveDetails();
    } else {
      ready = false;
    }
    intro = await violetText(
        'introduce yourself in 10 words. dont include any line breaks.',
        'violet_intro');
    setState(() {
      introloading = false;
    });
    askName = await violetText(
        'ask users for their name, keep response under 10 words. dont include any line breaks.',
        'ask_name');

    creationIdea = await violetText(
        'tell them you are going to give a creation idea and then tell them a simple creation idea, whole response under 100 characters. dont include any line breaks.',
        'creation_idea');

    responseText = await violetText(
        ready == true
            ? welcomeback
            : 'welcome users to apheria and explain briefly the idea of apheria. keep under 100 characters.dont include any line breaks.',
        'initial_welcome');

    setState(() {
      checking = false;
      loading = false;
    });
  }

  void saveDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    /// use this to push to transfer screen i think, and skip the ready page

    logEvent('sign_in_action', {'action': 'enter_apheria'});

    getStarPoints();
    getFiles();
    getScenes();
    goReplace(NewTransferScreen(''), context);
  }

  void refreshChat() async {
    setState(() {
      checking = true;
      introloading = true;
    });
    logEvent('sign_in_action', {'action': 'refresh_chat'});
    name = '';
    email = '';
    prompt = '';
    emailsenderror = '';
    ready = false;
    obscure = false;
    _controller.clear();
    await checkSignedIn();
  }

  final _controller = TextEditingController();
  bool loading = false;
  Widget build(BuildContext context) {
    return checkLoading == true
        ? Container(color: apheriapink)
        : Scaffold(
            backgroundColor: apheriapink,
            appBar: AppBar(
                leading: Row(
                  children: [
                    // GestureDetector(onTap:refreshChat,child: Text('play store',style:TextStyle(color:Colors.white,fontSize:20))),
                    IconButton(
                      icon: Icon(Icons.shop, color: Colors.white),
                      onPressed: () {
                        InAppReview.instance.openStoreListing();
                      },
                    ),
                  ],
                ),
                backgroundColor: apheriapink,
                title: Text('apheria', style: TextStyle(color: Colors.white)),
                centerTitle: true,
                actions: [
                  IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: refreshChat),
                  // SizedBox(width:25)
//GestureDetector(onTap:refreshChat,child: Text('refresh',style:TextStyle(color:Colors.white,fontSize:20))),SizedBox(width:25)
                ]),
            body: ready == true
                ? Container()
                : SafeArea(
                    child: Column(
                      children: [
                        //(signedinemail,style:TextStyle(color:Colors.white)),
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
                                          introloading == true
                                              ? 'thinking...'
                                              : intro,
                                          style: TextStyle(
                                              color: apherialilac,
                                              fontSize: 23),
                                        ),
                                      ],
                                    ),
                                  )),
                            )),
                          ],
                        ),
                        Expanded(
                          child: ListView(children: [
                            /* Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                                    color:apherialilac,
                shape:curvedcard,
                  child:ListTile(
                    onTap:(){

                    },
                  
                    trailing:Icon(Icons.refresh,color:Colors.white),
                    title:Text('restart dialogue',style:TextStyle(color:Colors.white,fontSize:24))
                  )
                ),
              ),*/
                            ready == true
                                ? Container()
                                : prompt == ''
                                    ? Container()
                                    /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(''),
                      )*/
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                            color:
                                                apherialilac.withOpacity(0.5),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(obscure == true
                                                  ? 'you: *text hidden*'
                                                  : 'you: $prompt'),
                                            )),
                                      ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  color: apherialilac,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        checking == true
                                            ? 'thinking...'
                                            : 'violet: $responseText',
                                        style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            )),
                                  )),
                            ),
                            loading == true
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        color: darkapheriapink,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              //'test',
                                              checking == true
                                                  ? 'thinking...'
                                                  : 'violet: ' +
                                                      (ready == true
                                                          ? creationIdea
                                                          : name == ''
                                                              ? askName
                                                              : isValidEmail(
                                                                          email) ==
                                                                      false
                                                                  ? askEmail
                                                                  : askPassword),
                                              style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  )),
                                        )),
                                  ),
                            //Text(signinerror,style:TextStyle(color:Colors.white)),
                            ready == false && name == ''
                                ? Container()
                                : isValidEmail(email) == false
                                    ? Container()
                                    : checking == true
                                        ? Container()
                                        : loading == true
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Card(
                                                    elevation:
                                                        ready == true ? 5 : 0,
                                                    color: ready == true
                                                        ? apheriabluetwo
                                                        : Colors.white
                                                            .withOpacity(0.2),
                                                    shape: curvedcard,
                                                    child: ListTile(
                                                        onTap: () async {
                                                          if (email == '') {
                                                            refreshChat();
                                                          } else if (ready ==
                                                              true) {
                                                            logEvent(
                                                                'sign_in_action',
                                                                {
                                                                  'action':
                                                                      'enter_apheria'
                                                                });

                                                            getStarPoints();
                                                            getFiles();
                                                            getScenes();
                                                            goReplace(
                                                                NewTransferScreen(
                                                                    ''),
                                                                context);
                                                          } else {
                                                            if (isValidEmail(
                                                                    email) ==
                                                                false) {
                                                              emailsenderror =
                                                                  'invalid email format';
                                                            } else {
                                                              try {
                                                                apheriaauth
                                                                    .sendPasswordResetEmail(
                                                                        email:
                                                                            email);
                                                                emailsenderror =
                                                                    'email sent!';
                                                                logEvent(
                                                                    'sign_in_action',
                                                                    {
                                                                      'action':
                                                                          'reset_email_sent'
                                                                    });
                                                              } catch (e) {
                                                                emailsenderror =
                                                                    'email not registered';
                                                              }
                                                            }
                                                          }
                                                          setState(() {});
                                                        },
                                                        trailing: Icon(
                                                            email == ''
                                                                ? Icons.refresh
                                                                : Icons
                                                                    .arrow_forward,
                                                            color:
                                                                Colors.white),
                                                        title: Text(
                                                            ready == true
                                                                ? 'enter apheria!'
                                                                : isValidEmail(
                                                                            email) ==
                                                                        false
                                                                    ? 'refresh chat'
                                                                    : emailsenderror !=
                                                                            ''
                                                                        ? emailsenderror
                                                                        : 'forgot password?',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)))),
                                              ),
                          ]),
                        ),

                        ready == true
                            ? Container()
                            : checking == true
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        FloatingActionButton(
                                            backgroundColor: apheriapurple,
                                            child: Icon(Icons.password,
                                                color: Colors.white),
                                            onPressed: () async {
                                              setState(() {
                                                if (obscure == true) {
                                                  obscure = false;
                                                  logEvent('sign_in_action', {
                                                    'action': 'obscure_off'
                                                  });
                                                } else if (obscure == false) {
                                                  obscure = true;
                                                  logEvent('sign_in_action',
                                                      {'action': 'obscure_on'});
                                                }
                                              });
                                            }),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                obscureText: obscure,
                                                controller: _controller,
                                                style: TextStyle(
                                                    color: apheriapurple),
                                                onChanged: (text) {
                                                  prompt = text;
                                                  //setState(() {});
                                                  // Update the email variable when the text field changes
                                                },
                                                decoration: InputDecoration(
                                                    hintText: textPrompt),
                                              ),
                                            )),
                                          ),
                                        ),
                                        FloatingActionButton(
                                          child: Icon(Icons.send,
                                              color: Colors.white),
                                          onPressed: () async {
                                            setState(() {
                                              loading = true;
                                              responseText = 'thinking ...';
                                            });

                                            bool trylogin = false;
                                            if (name == '') {
                                              name = prompt;
                                              logEvent('sign_in_action', {
                                                'action': 'provided_name',
                                                'message': prompt
                                              }); //not storing yet, maybe in future with accoutn editing? + will have to delcare as data everywhere
                                            } else if (isValidEmail(email) ==
                                                true) {
                                              password = prompt;
                                              trylogin = true;
                                              logEvent('sign_in_action', {
                                                'action': 'provided_password',
                                              }); //new

                                              //password length issue
                                              if (password.length < 6) {
                                                signinerror =
                                                    'password must be longer than 6 characters';
                                                logEvent('sign_in_action', {
                                                  'action':
                                                      'password_length_error'
                                                });
                                              } else {
                                                //valid password, try to create a new account
                                                try {
                                                  await apheriaauth
                                                      .createUserWithEmailAndPassword(
                                                          email: email,
                                                          password: password);
                                                  apheriaUser =
                                                      apheriaauth.currentUser!;
                                                  signinerror = newuser;
                                                  ready = true;
                                                  logEvent('sign_in_action', {
                                                    'action': 'new_user_created'
                                                  });
                                                  saveDetails(); // if success, new account is created and apheria is ready
                                                }
                                                //else - email is already registered
                                                catch (e) {
                                                  try {
                                                    await apheriaauth
                                                        .signInWithEmailAndPassword(
                                                            //check if password is corretc to sign in the user
                                                            email: email,
                                                            password: password);
                                                    apheriaUser = apheriaauth
                                                        .currentUser!;
                                                    signinerror = welcomeback;
                                                    ready = true;
                                                    saveDetails();
                                                  } catch (e) {
                                                    signinerror =
                                                        passwordissue; //password is incorrect for the user
                                                    logEvent('sign_in_action', {
                                                      'action':
                                                          'incorrect_password'
                                                    });
                                                  }
                                                }
                                              }
                                            } else if (isValidEmail(prompt) ==
                                                true) {
                                              logEvent('sign_in_action', {
                                                'action': 'provided_email',
                                              }); //not storing yet, maybe in future with accoutn editing? + will have to delcare as data everywhere

                                              email = prompt;
                                              _controller.clear();
                                              logEvent('sign_in_action', {
                                                'action': 'valid_email',
                                                'message': prompt,
                                              });

                                              //jjnkobscure=true;
                                            } else {
                                              logEvent('sign_in_action', {
                                                'action': 'provided_email',
                                              }); //not storing yet, maybe in future with accoutn editing? + will have to delcare as data everywhere

                                              email = 'invalid';
                                              logEvent('sign_in_action', {
                                                'action': 'invalid_email',
                                                'message': prompt,
                                              });
                                            }

                                            String text = '';
                                            String error = '';
                                            String promptResponse =
                                                'respond to this prompt "$prompt" first under 50 characters. then do this:';
                                            askEmail = await violetText(
                                                'ask users for their account email to log in, keep response  under 10 words. dont include any line breaks.',
                                                'ask_for_email');
                                            askPassword = await violetText(
                                                'ask users for a password to log in with. keep response under 10 words. dont include any line breaks.',
                                                'ask_for_password');
                                            //don't use prompt response for password sign in errors:
                                            if (trylogin == true) {
                                              error = 'sign_in_error';
                                              text =
                                                  'explain $signinerror to user. whole response cannot be more than 100 characters.';
                                            }
                                            //use prompt respones for greeting and invalid emails:
                                            else if (email == '') {
                                              error = 'name_given_greeting';
                                              text = promptResponse +
                                                  'if they provide a name, greet them with their name:  $name.dont use[name] or [username] or anything like that in brackets. dont ask for their name again. dont greet them twice. and tell them that you are setting up an account for them to get started or finding it if they already have one. keep under 100 characters.';
                                            } else if (email == 'invalid') {
                                              error = 'invalid_email';
                                              text = promptResponse +
                                                  'tell user that the email is invalid and try to enter a valid email.  and no capital letters or outbursts. keep under 100 characters';
                                            }
                                            //don't use prompt response for valid emails:
                                            else {
                                              error = 'valid_email';
                                              text =
                                                  'thank $name - and say that $email looks like a valid email.  ask users for a password to sign in or to register. but ensure them that you cannot see it. tell users that they can obscure their password using the button on the left of the box to type in. keep whole response under 200 characters.';
                                            }

                                            responseText =
                                                await violetText(text, error);

                                            logEvent('sign_in_action', {
                                              'action':
                                                  'violet_sign_in_reponse',
                                              'response': responseText
                                            });

                                            setState(() {
                                              loading = false;
                                            });
                                            _controller.clear();
                                          },
                                          backgroundColor: apherialilac,
                                        )
                                      ],
                                    ),
                                  ),
                        // Text("violet is AI. she's only real inside the apheria app.",style:TextStyle(fontSize:18,color:Colors.white))
                      ],
                    ),
                  ));
  }
}
