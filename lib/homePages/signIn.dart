import 'package:apheria/constants.dart';
import 'package:apheria/homePages/filesHomePage.dart';
import 'package:apheria/homePages/world.dart';
import 'package:apheria/main.dart';
import 'package:apheria/newTransferScreen.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  SignInPage(this.fullSignOut);
  bool fullSignOut;

  @override
  State<SignInPage> createState() => _SignInPageState(this.fullSignOut);
}

class _SignInPageState extends State<SignInPage> {
  _SignInPageState(this.fullSignOut);
  bool fullSignOut;
  bool signedIn = false;

  FirebaseAuth apheriaauth = FirebaseAuth.instance;
  String signInError = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (fullSignOut == true) {
      signedIn = false;
      signInError = 'signed out';
      //googlesignin();

      // signin();
      //not doing google, just doing basic username, email etc, password not needed?
    } else {
      checkSignedIn();
      signInError = 'checking for sign in';
    }
    setState(() {
      
    });
  }

  checkSignedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      email = await prefs.getString('email') ?? '';
      password = await prefs.getString('password') ?? '';
      signin();
    } catch (e) {}
  }

  signin() async {
    // Trigger the authentication flow

    try {
      /*  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );*/

      // Once signed in, return the UserCredential
      // await FirebaseAuth.instance.signInWithCredential(credential);
      await apheriaauth.signInWithEmailAndPassword(
          email: email, password: password);
      setState(() {
        signedIn = true;
      });
    } catch (e) {
      setState(() {
        signedIn = false;
        // e = error;
      });
    }

    if (signedIn == false) {
      try {
        await apheriaauth.createUserWithEmailAndPassword(
            email: email, password: password);
        starpoints = 500;
        newUser = true;
        //initial sp gifted
        signin();
      } catch (e) {
        setState(() {
          signedIn = false;
          logEvent('sign_in_action', {'action': 'password_error'});

          signInError = email == '' && password == ''
              ? ''
              : 'email is already registered. the password is incorrect';

          // e = error;
        });
      }
    }

    if (signedIn == true) {
      if (newUser == true) {
        if (signedIn == true) {
          logEvent('sign_in_action', {'action': 'new_user_created'});
        }
      }
      try {
        logEvent('sign_in_action', {'action': 'user_signed_in'});

        apheriaUser = apheriaauth.currentUser!;
        //error = apheriaUser.uid.toString();
        if (apheriaUser.email == 'brittwood99@gmail.com') {
          traffic_type = 'britt_internal_traffic';
        } else if (apheriaUser.email!.contains('apheria')) {
          traffic_type = 'apheria_internal_traffic';
        } else if (apheriaUser.email!.contains('test')) {
          traffic_type = 'test_internal_traffic';
        } else {
          if (traffic_type == 'unknown_traffic') {
            //its not already labelled as virtual or test lab
            traffic_type = 'public_traffic_signed_in';
          } // should be public traffic
        }

        logTrafficType(traffic_type);

        // error = 'no error';
        FirebaseFirestore.instance
            .collection("users")
            .doc(apheriaUser.uid)
            .update({
          "traffic_type": traffic_type,
        });
        // error = 'still no error';

        getStarPoints();
        getFiles();
        getScenes();

        goReplace(NewTransferScreen(''), context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      } catch (e) {}
    }

    // Use the user object for further operations or navigate to a new screen.
  }

  String email = '';
  String password = '';

  Widget formField(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          color: apheriabluetwo,
          child: ListTile(
            //title:  Text(title),
            subtitle: TextFormField(
              obscureText: title == 'password' ? true : false,
              style: TextStyle(color: Colors.white),
              onChanged: (text) {
                signInError = '';
                title == 'email' ? email = text : password = text;

                if (isValidEmail(email) == false) {
                  signInError = 'please enter a valid email. ';
                }

                if (password == '' || password.length < 6) {
                  signInError = signInError +
                      'please enter a password longer than 6 characters.';
                }

                setState(() {});

                // Update the email variable when the text field changes
              },
              decoration: InputDecoration(
                  hintText: 'enter $title',
                  hintStyle: TextStyle(color: apheriaamber)),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: apheriapink,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Card(color:apheriapink,child:Text(apheriaUser?.uid==null?'no email':apheriaUser!.uid)),
              //Card(color:Colors.black,child:Text(texterror)),
              Container(
                color: apheriabluetwo,
                child: Image.asset('images/icon/colourplanet2.png',
                    // color: apheriapink,
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2),
              ),
              /*  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: ListTile(
                        onTap: googlesignin,
                        leading: Image.asset('images/icons/signInGoogle.png'),
                        title: Text('sign in with google',
                            textAlign: TextAlign.center),
                        subtitle: Text('to get access to apheria',
                            textAlign: TextAlign.center))),
              ),*/
              Container(
                color: apheriapink,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('welcome to apheria',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                    formField('email'),
                    formField('password'),

                    // Text(email),
                    //        Text(password),

                    isValidEmail(email) == false || password.length < 6
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                                backgroundColor: apheriaamber,
                                elevation: 3,
                                onPressed: () async {
                                  await signin();
                                },
                                label: Text('sign in/up')),
                          ),
                    isValidEmail(email) == false
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                                backgroundColor: darkapheriapink,
                                elevation: 3,
                                onPressed: () async {
                                  signInError = '';
                                  try {
                                    apheriaauth.sendPasswordResetEmail(
                                        email: email);
                                    signInError = "email sent!";
                                    logEvent('sign_in_action',
                                        {'action': 'reset_email_sent'});
                                  } catch (e) {
                                    signInError = "email not recognised";
                                  }
                                  setState(() {});
                                },
                                label: Text('forgot password')),
                          ),
                    signInError == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$signInError',
                                textAlign: TextAlign.center),
                          ),
                    // Text('prefs: $email, $password'),
                    SizedBox(height: 500),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
