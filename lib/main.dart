//flutter

import 'dart:io';

import 'package:apheria/constants.dart';
import 'package:apheria/data/violet_context.dart';
import 'package:apheria/homePages/AISignin.dart';
import 'package:apheria/homePages/filesHomePage.dart';
import 'package:apheria/homePages/signIn.dart';
import 'package:apheria/homePages/starpointsPage.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:apheria/homePages/world.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:apheria/newTransferScreen.dart';
import 'package:apheria/secureInfo/secureInfo.dart';
//packages

//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:is_firebase_test_lab_activated/is_firebase_test_lab_activated.dart';

//other

//project

//data

//home pages

//services
import 'package:apheria/services/analytics.dart';
import 'package:apheria/services/notifications.dart';

//widgets
import 'package:apheria/widgets/languageSelector.dart';
import 'package:shared_preferences/shared_preferences.dart';

//other

///iap
///
///
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

bool signout = false;
String apheriaVersion = '';
bool newUser = false;

var vertex_instance = FirebaseVertexAI.instanceFor(auth: FirebaseAuth.instance);
GenerativeModel violet = vertex_instance.generativeModel(
    model: 'gemini-1.5-flash',
    /* safetySettings: [
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
    SafetySetting(HarmCategory.unspecified, HarmBlockThreshold.low)

    ],*/

    // safetySettings: Adjust safety settings
    // See https://ai.google.dev/gemini-api/docs/safety-settings
    generationConfig: GenerationConfig(
      temperature: 2,
      topK: 20,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    ),
    systemInstruction: Content.system(violet_context));

class IAPConnection {
  static InAppPurchase? _instance;
  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}

///google sign in
final GoogleSignIn googleSignIn = GoogleSignIn();

///firebase and notifications setup

//firbase variables:

bool _isFirebaseTestLabActivated = false;
String traffic_type = 'unknown_traffic';
String hostAddressString = 'IP';
bool debug = false;
String network_status = 'unknown';
String deviceID = 'unknown';

///firebase test lab
Future<void> initPlatformState() async {
  ///first test for firebase test lab
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  ///
  final bool isFirebaseTestLabActivated =
      await IsFirebaseTestLabActivated.isFirebaseTestLabActivated;

  _isFirebaseTestLabActivated = isFirebaseTestLabActivated;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var androidInfo = await deviceInfo.androidInfo;
  deviceID = androidInfo.id.toString();

  //////

  ///test lab first
  if (_isFirebaseTestLabActivated == true) {
    traffic_type = 'fb_test_lab';
    debug = true;
  }

  //then test for virtual devices
  else if (androidInfo.isPhysicalDevice) {
  } else {
    traffic_type = 'virtual_device';
  }

  logTrafficType(
      traffic_type); // logs it in analytics as a user property //should filter out my testing and other testing e.g codemagic/gplay
//initial upload
//either will be fb test lab, virtual device or unknown
//later on after sign in, will determine whether it stays unknown, changes to internal or public signe din traffic
}

Future<void> main() async {
  ///basic functions
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          projectId: 'apheria-cf0b7',
          messagingSenderId: '470759388311',
          apiKey: firebaseAPIKey,
          appId: '1:470759388311:android:639a68d6ec93465f4165d2')
      //  options: DefaultFirebaseOptions.currentPlatform,

      // storageBucket: 'myapp-b9yt18.appspot.com',
      //
      ); //init firebase
  getLanguage(); //set base language for the app
  apheriaVersion = await getAppVersion();

//firebase crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  //NotificationService().initNotification();

  initPlatformState();

  /*///check whether connected to the internet
  final connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    logNetworkStatus('mobile_network');
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    logNetworkStatus('wifi_network');
  } else if (connectivityResult == ConnectivityResult.ethernet) {
    // I am connected to a ethernet network.
    logNetworkStatus('ethernet_network');
  } else {
    logNetworkStatus('offline');
  }*/

  //in app purchase setup

  ///google sign in

  runApp(MyApp()); //sets up fb
}

User apheriaUser = FirebaseAuth.instance.currentUser!;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String texterror = 'no error';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'gamjaFlower',
            // accentColor: Colors.white,
            primaryColor: Colors.white,
            bottomSheetTheme:
                BottomSheetThemeData(backgroundColor: Colors.transparent),
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'gamjaFlower',
                  fontSizeDelta: 1.1,
                  fontSizeFactor: 1.5,
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                )),
        home: VioletAISignIn());
    //SignInPage(false));
    //InAppPurchasePage(title:'iaps'));
  }
}
