import 'package:apheria/constants.dart';
import 'package:apheria/data/langText.dart';
import 'package:apheria/homePages/AISignin.dart';
import 'package:apheria/homePages/signIn.dart';
import 'package:apheria/main.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/services/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mailto/mailto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  callback() {}
  Widget settingsCard(
      String title, String subtitle, IconData icon, Function function) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Card(
          color: Colors.white,
          shape: curvedcard,
          elevation: 2,
          child: ListTile(
            title: Text(title, style: TextStyle(color: apheriabluetwo)),
            subtitle: Text(subtitle, style: TextStyle(color: apherialilac)),
            leading: Icon(icon, color: apheriaamber),
            onTap: () {
              function();
            },
          )),
    );
  }

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriapink,
        appBar: apheriaAppBar(context, 'settings'),
        body: Stack(
          children: [
            Center(
              child: Container(
                  width: 500,
                  child: Image.asset('images/files/ob57.png',
                      color: Colors.white.withOpacity(0.6))),
            ),
            ListView(children: [
              Text('    apheria version: $apheriaVersion'),
              // Text('    traffic type: $traffic_type'),
              //  Text('    device ID: $deviceID'),
              settingsCard(
                'play store',
                'check for updates',
                Icons.shop,
                () {
                  logEvent('settings_action', {'action': 'play_store'});
                  final InAppReview inAppReview = InAppReview.instance;
                  inAppReview
                      .openStoreListing(); //better api fingers crossed than the other one that was causing the grey screen
                },
              ),
              settingsCard(
                'apheria website',
                'the journey of apheria',
                Icons.web,
                () {
                  logEvent('settings_action', {'action': 'apheria_website'});
                  Uri webURL = Uri.parse('https://www.apheria.app');
                  launchUrl(
                      webURL); //better api fingers crossed than the other one that was causing the grey screen
                },
              ),
              settingsCard(
                'notifications',
                'send test notification',
                Icons.notifications_active,
                () async {
                  String success = 'success';

                  try {
                    NotificationService().showNotification(
                      title: await createLangString(hey),
                      body: await createLangString(notificationMessage),
                    );
                  } catch (e) {
                    success = 'failed';
                  }
                  logEvent(
                      'settings_action', {'action': 'notification_request'});
                },
              ),

              /*settingsCard('choose language', baseLanguage.display, Text(baseLanguage.flag), (){
                                    goToPopUp(
                                          PopUpPage(
                                              Image.asset('images/icon/foreground.png'),
                                              'choose language',
                                              '',
                                              Column(children: [
                                                LanguageSelector(english),
                                                //languageSelector(danish),
                                                //languageSelector(swedish),
                                                //languageSelector(icelandic),
                                                //languageSelector(norweigan),
                                                //languageSelector(korean),
                                                LanguageSelector(japanese),
                                              ]),
                                              callback),
                                          context);
                                   }) ,*/

              /*settingsCard(
                  'eco/low contrast mode', 'monochrome only', Icons.contrast,
                  () {
                setState(() {
                  if (apheriapink == Color(0xffffa4e2)) {
                    apheriapink = Colors.black;
                    apheriablue = Colors.black;
                    apheriabluetwo = Colors.black;
                    darkapheriapink = Colors.black;
                    apheriaamber = Colors.black;
                    apheriadiscord = Colors.black;
                    apheriapurple = Colors.black;
                    apherialilac = Colors.black;
                    // colorFilter=

                    logEvent(
                        'settings_action', {'action': 'eco_mode_activated'});
                  } else if (apheriapink == Colors.black) {
                    apheriapink = Color(0xffffa4e2);
                    apheriablue = Color(0xff68b2ff);
                    apheriabluetwo = Color(0xff3e4894);
                    darkapheriapink = Color(0xffe072cc);
                    apheriaamber = Color(0xfffcdc08);
                    apheriadiscord = Color(0xff5865f2);
                    apheriapurple = Color.fromARGB(255, 63, 42, 67);
                    apherialilac = Color.fromARGB(255, 151, 81, 163);
                    //  colorFilter=

                    logEvent(
                        'settings_action', {'action': 'eco_mode_deactivated'});
                  }
                });
              }),*/ //removed eco mdoe for now, not really working as I would like
              settingsCard(
                  'report a bug', 'or leave some feedback', Icons.bug_report,
                  () async {
                final mailtoLink = Mailto(
                    to: ['britt.apheria@gmail.com'],
                    //cc: ['cc1@example.com', 'cc2@example.com'],
                    subject: 'apheria contact form (${apheriaUser.uid})',
                    body:
                        '''please do not remove this user information as it is key to your ticket: 
user id: ${apheriaUser.uid}, 
date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}, 
time: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second},
app version: ${apheriaVersion} 
---
write information about the bug or a suggestion for the apheria app here:
                    ''');
                // Convert the Mailto instance into a string.
                // Use either Dart's string interpolation
                // or the toString() method
                Uri emailUrl = Uri.parse(mailtoLink.toString());
                await launchUrl(emailUrl);
              }),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 3,
                  shape: curvycard,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Card(
                        // elevation: 5,
                        shape: curvycard,
                        color: darkapheriapink,
                        child: ListTile(
                            onTap: () async {
                              signout = true;
                              FirebaseAuth.instance.signOut();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear(); //apheriaUser=null;
                              logEvent(
                                  'settings_action', {'action': 'log_out'});
                             Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(builder: (context) =>
                                            VioletAISignIn()), (Route<dynamic> route) => false);

                              // goTo(SignInPage(), context);
                            },
                            leading: photoAvatar(),
                            trailing: Icon(Icons.logout, color: Colors.white),
                            title: Text('log out',
                                style: TextStyle(color: Colors.white)))),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  goTo(
                      Scaffold(
                        appBar: apheriaAppBar(context, 'delete account'),
                        body: Center(
                          child: Container(
                              color: apheriapink,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListView(
                                  children: [
                                    Text('delete your apheria account?'),
                                    SizedBox(height: 12),
                                    Text(
                                        '- you will lose your bought and earned star points',
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(height: 12),
                                    Text(
                                        '- you will lose any redeemed in-app content',
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(height: 25),
                                    FloatingActionButton.extended(
                                        backgroundColor: darkapheriapink,
                                        onPressed: () async {
                                          try {
                                            final user = FirebaseAuth
                                                .instance.currentUser;
                                            String uid = user!.uid;

                                            await user.delete();
                                            // Account deleted successfully
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs
                                                .clear(); //apheriaUser=null;
                                            logEvent('settings_action',
                                                {'action': 'account_deleted'});
                                            //delete user collection

                                            final collectionRef =
                                                FirebaseFirestore.instance
                                                    .collection('users');
                                            // Delete all documents in the collection
                                            final querySnapshot =
                                                await collectionRef.get();
                                            for (final doc
                                                in querySnapshot.docs) {
                                              if (doc.reference.id == uid) {
                                                await doc.reference.delete();
                                              }
                                            }
                                           
                                           Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(builder: (context) =>
                                            VioletAISignIn()), (Route<dynamic> route) => false);
                                          } catch (e) {
                                            error =
                                                'something went wrong. try again later';
                                          }
                                        },
                                        label: Text(
                                            'i understand, delete my account',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    SizedBox(height: 12),
                                    Text(error)
                                  ],
                                ),
                              )),
                        ),
                      ),
                      context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('delete account', textAlign: TextAlign.center),
                ),
              ),
              SizedBox(height: 50)
            ]),
          ],
        ));
  }
}
