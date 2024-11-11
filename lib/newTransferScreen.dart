//flutter

import 'package:apheria/homePages/filesHomePage.dart';
import 'package:apheria/homePages/newAddPage.dart';
import 'package:apheria/homePages/settings.dart';
import 'package:apheria/widgets/toolWidget.dart';
import 'package:apheria/main.dart';
import 'package:apheria/homePages/starpointsPage.dart';
import 'package:apheria/services/inAppPurchasesBackEnd.dart';
import 'package:apheria/services/notifications.dart';
import 'package:apheria/widgets/languageSelector.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:apheria/homePages/violet.dart';
import 'package:apheria/homePages/world.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math' as math; // import this

//packages

//firebase
import 'package:firebase_analytics/firebase_analytics.dart';

//other
import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:googleapis/datamigration/v1.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mailto/mailto.dart';
import 'package:matrix_gesture_detector_pro/matrix_gesture_detector_pro.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scribble/scribble.dart';

//project

//data
import 'package:apheria/data/langText.dart';

//home pages

//services
import 'package:apheria/services/analytics.dart';

//widgets
import 'package:apheria/widgets/filecardui.dart';

//other
import 'package:apheria/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Color filecolor = Colors.black;
Color backgcolor = Colors.white;
bool showcamera = false;

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  return version;
}

List<String> checkedFiles = [];

List<Widget> matrixList = [];
GlobalKey matrixBuilder = GlobalKey();
double rotation = 0;

class matrix extends StatefulWidget {
  matrix(this.filename);
  String filename;

  @override
  State<matrix> createState() => _matrixState(this.filename);
}

class _matrixState extends State<matrix> {
  _matrixState(this.filename);
  String filename;
  @override
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  Timer? timer;

  bool remove = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    /* timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              if (checkedFiles.contains(filename)) {
              } else {
                remove = true;
                setState(() {});
              }
            }));*/
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return remove == true
        ? Container()
        : MatrixGestureDetector(
            onMatrixUpdate: (m, tm, sm, rm) {
              notifier.value = m;
              print('m is ${m}');
            },
            child: AnimatedBuilder(
                animation: notifier,
                builder: (ctx, child) {
                  return Transform(
                      transform: notifier.value,
                      child: Stack(children: <Widget>[
                        Container(),
                        Positioned.fill(
                          child: Container(
                              transform: notifier.value,
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(rotation),
                                    child: Image.asset(
                                        'images/files/${filename}.png',
                                        color: filecolor),
                                  ))),
                        )
                      ]));
                }));
  }
}

void createMatrixList() {
  matrixList.clear();
  //checkedFiles=checkedFiles.toSet().toList();
  checkedFiles.forEach((file) {
    matrixList = matrixList + [matrix(file)];

    ///its removing a file ten rebuilding but missing off the last one instead
    ///eg files 1,2,3,4,5
    ///remove 3
    ///1,2,4,5
    ///want to remove matrix not
  });
}

class NewTransferScreen extends StatefulWidget {
  String file;
  NewTransferScreen(this.file);
  @override
  _NewTransferScreenState createState() => _NewTransferScreenState(this.file);
}

class _NewTransferScreenState extends State<NewTransferScreen> {
  String file;
  IconData lock = Icons.lock_outline;
  _NewTransferScreenState(this.file);
  bool locked = false;
  bool takenPicture = false;
  bool screenshot = false;
  Image imageTaken = Image.asset('images/icon/icon.png');
  bool loading = true;
  @override
  // ScreenshotController screenshotController = ScreenshotController();

  void callback() {
    setState(() {});
  }

  void cameraFunction() {
    Navigator.pop(context);
    if (showcamera == false) {
      setUpCamera();
      showcamera = true;
      logEvent('action_pressed', {'action': 'camera_button'});
    } else if (showcamera == true) {
      showcamera = false;
      takenPicture = false;
      logEvent('action_pressed', {'action': 'closed_camera'});
    }

    setState(() {});
    //widget.callback();
    //  Navigator.pop(context);
  }

  Widget toolScreen() {
    return Scaffold(
      backgroundColor: apheriapink,
      appBar: apheriaAppBar(context, 'toolbox'),
      body: Stack(
        children: [
          Center(
            child: Container(
                width: 500,
                child: Image.asset('images/files/ob24.png',
                    color: Colors.white.withOpacity(0.6))),
          ),
          Column(
            children: [
              /*  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color:Colors.white,
                      shape:curvedcard,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Card(
                      color:darkapheriapink,
                      shape:curvedcard,
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'drag and pinch the file to pinch and zoom',
                            style: TextStyle(fontSize: 25,color:Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ),
                ),
              ),*/
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        //  childAspectRatio: 0.75,
                      ),
                      children: [
                        toolWidget(
                            showcamera == false ? Colors.white : apheriabluetwo,
                            showcamera == false ? apheriabluetwo : Colors.white,
                            showcamera == false
                                ? 'activate camera'
                                : 'deactivate camera',
                            'draw through the lens',
                            showcamera == true
                                ? Icons.videocam_off
                                : Icons.videocam,
                            cameraFunction),
                        toolWidget(
                          Colors.white,
                          apheriabluetwo,
                          'clear canvas',
                          'start fresh',
                          Icons.close,
                          () {
                            Navigator.pop(context);
                            checkedFiles.clear();
                            matrixList.clear();
                            //notifier.clear();

                            setState(() {});
                          },
                        ),
                        toolWidget(
                          rotation == 0 ? Colors.white : apheriabluetwo,
                          rotation == 0 ? apheriabluetwo : Colors.white,
                          'flip canvas',
                          'easier for tracing',
                          Icons.switch_left,
                          () {
                            Navigator.pop(context);
                            setState(() {
                              if (rotation == 0) {
                                rotation = math.pi;
                              } else if (rotation == math.pi) {
                                rotation = 0;
                              }
                            });
                            logEvent(
                                'action_pressed', {'action': 'switch_button'});
                          },
                        ),
                        toolWidget(
                            locked == false ? Colors.white : apheriabluetwo,
                            locked == false ? apheriabluetwo : Colors.white,
                            locked == true ? 'unlock canvas' : 'lock canvas',
                            'easier for tracing',
                            locked == true ? Icons.lock_open : Icons.lock, () {
                          if (locked == false) {
                            logEvent('action_pressed', {'action': 'lock_file'});
                            setState(() {
                              locked = true;
                            });
                          } else if (locked == true) {
                            logEvent(
                                'action_pressed', {'action': 'unlock_file'});
                            setState(() {
                              locked = false;
                            });
                          }
                          Navigator.pop(context);
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              //('add colour', 'paint colour over your canvas',Icons.color_lens, (){}),

              SizedBox(height: 50)
            ],
          ),
        ],
      ),
    );
  }

  List<CameraDescription> cameras = [];

  CameraController controller = CameraController(
    CameraDescription(
        name: 'init',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0),
    ResolutionPreset.max,
    enableAudio: false,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Timer? timer;

  ScribbleNotifier scribbleNotifier = ScribbleNotifier();

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool sploading = true;

  determineTrafficType() async {
    FirebaseAuth apheriaauth = FirebaseAuth.instance;

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
    FirebaseFirestore.instance.collection("users").doc(apheriaUser.uid).update({
      "traffic_type": traffic_type,
    });

    getStarPoints();
    getFiles();
    getScenes();

   
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logEvent('sign_in_action', {'action': 'transfer_screen_open'});
    //log traffic type from sign in

    determineTrafficType();

    createMatrixList();
    //logScreen('transfer screen');
    // logEvent('transfer_screen', {'file': globalFile});
    //globalFile
    //time for sp
    timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              waitsp();
            }));
  }

  void waitsp() async {
    await getStarPoints();
    setState(() {
      sploading = false;
    });
  }

  Future<void> main() async {
    setState(() {
      loading = true;
    });
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    final frontCam = cameras[1]; //get the front camera and do what you want
    controller =
        CameraController(enableAudio: false, cameras[0], ResolutionPreset.max);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      print('controller init');
      print(controller);
    });
    print('done!!');
    setState(() {
      loading = false;
    });
  }

  void frontcam() async {
    setState(() {
      loading = true;
    });
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    final frontCam = cameras[1]; //get the front camera and do what you want
    controller = CameraController(
        enableAudio: false, cameras[1], ResolutionPreset.ultraHigh);
    controller.setFlashMode(FlashMode.off);

    try {
      await controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        print('controller init');
        print(controller);
      });
    } catch (e) {}
    print('done!!');
    setState(() {
      loading = false;
    });
  }

  void setUpCamera() async {
    await main();
  }

  bool scribbler = false;

  Widget build(BuildContext context) {
    createMatrixList();
    var backbarSwitch = PreferredSize(
      preferredSize: Size.fromHeight(100.0), // here the desired height
      child: SafeArea(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(height:100)
              /*Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton(
                    shape: circlecard,

                    //mini:true,
                    backgroundColor: Color(0xffffa4e2),
                    heroTag: 'backbutton',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 2.0,
                    child:
                        Icon(Icons.arrow_back, size: 35.0, color: Colors.white),
                  )),*/
            ],
          ),
        ),
      ),
    );

    //return Screenshot(
    return Container(
        color: apheriapink,
        child: SafeArea(
            // controller: screenshotController,
            child: Stack(children: [
          Container(
            color: Colors.white,
          ),
          takenPicture == true
              ? Center(child: imageTaken)
              : showcamera == false
                  ? Container()
                  : Container(
                      color: Colors.white,
                      child: Center(
                        child: CameraPreview(controller),
                      ),
                    ),
          Scaffold(
            backgroundColor:
                showcamera == false ? backgcolor : Colors.transparent,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: screenshot == true
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Container(
                      //height:50,width:50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 66,
                            width: 66,
                            child: FloatingActionButton(
                                tooltip: 'toolbox',
                                shape: circlecard,
                                heroTag: 'tools',
                                backgroundColor: darkapheriapink,
                                child: Icon(Icons.menu_rounded,
                                    color: Colors.white, size: 50),
                                onPressed: () {
                                  logEvent('navigation_action',
                                      {'action': 'home_button_toolbox'});
                                  goTo(toolScreen(), context);
                                }),
                          ),
                          Container(
                            height: 75,
                            width: 75,
                            child: Pulse(
                              animate: true,
                              child: FloatingActionButton(
                                elevation: 10,
                                  tooltip: 'add file',
                                  shape: circlecard,
                                  heroTag: 'add file',
                                  backgroundColor: apheriaamber,
                                  child: Icon(Icons.add,
                                      color: Colors.white, size: 50),
                                  onPressed: () {
                                    logEvent('navigation_action',
                                        {'action': 'home_button_add_file'});
                                    goTo(NewAddPage(), context);
                                  }),
                            ),
                          ),
                          Container(
                          height: 66,
                          width: 66,
                          child: FloatingActionButton(
                              shape: circlecard,
                              heroTag: 'settings',
                              tooltip: 'settings',
                              backgroundColor: apheriapink,
                              child: Icon(Icons.settings,
                                  color: Colors.white, size: 50),
                              onPressed: () {
                                logEvent('navigation_action',
                                    {'action': 'home_button_settings'});
                                goTo(SettingsPage(), context);
                              }),
                        ),
                         /* Container(
                            height: 75,
                            width: 75,
                            child: FloatingActionButton(
                                shape: circlecard,
                                heroTag: 'sp',
                                // tooltip: 'view files',
                                backgroundColor: apheriabluetwo,
                                child: Image.asset(
                                  'images/icon/planet.png',
                                  semanticLabel: 'view planet',
                                ),
                                onPressed: () {
                                  logEvent('navigation_action',
                                      {'action': 'home_button_world'});
                                  goTo(apheriaWorld(), context);
                                  // SystemSound.play(SystemSoundType.click);
                                }),
                          ),*/
                        ],
                      ),
                    ),
                  ),
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(200.0),
                // here the desired height

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Container(
                    //height:50,width:50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          child: FloatingActionButton(
                              shape: circlecard,
                              heroTag: 'inspo',
                              //tooltip: 'inspiration',
                              backgroundColor: apherialilac,
                              child: Image.asset('images/files/ob46.png',
                                  semanticLabel: 'violet chatbot',
                                  color: Colors.white),
                              onPressed: () {
                                logEvent('navigation_action',
                                    {'action': 'home_button_violet'});
                                goTo(VioletChatBot(), context);
                              }),
                        ),
                        //starPointCounter('transfer_screen'),
                        
                      ],
                    ),
                  ),
                )),
            // extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                matrixList.isEmpty && showcamera == false
                    ? Center(
                        child: Container(
                         // height:MediaQuery.of(context).size.height/5,
                         // width:MediaQuery.of(context).size.width/1.2,
                          child:Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 10,
                              color:apherialilac,
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IntrinsicHeight(
                                  child: Column(
                                    
                                    children: [
                                      Text('welcome to apheria!',style:TextStyle(fontSize:33)),
                                      Row(
                                         children: [
                                              // Asset image on the left
                                              Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Image.asset('images/icon/violet.png', width: 100), 
                                              ),
                                      
                                              // Text with embedded icon 
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: RichText( 
                                                    text: TextSpan(
                                                      style: TextStyle(fontFamily:'gamjaFlower',fontSize:25),
                                                    children: [
                                                      TextSpan(text:'click on the ', style: TextStyle(overflow: TextOverflow.visible)),
                                                      WidgetSpan(
                                                        child: Card(color:apheriaamber,shape:circlecard,
                                                          child: Icon(Icons.add, color: Colors.white,size:30)),
                                                      ),
                                                      TextSpan(text:' button below to get started!', style: TextStyle(overflow: TextOverflow.visible)), 
                                      
                                                    ],)
                                                  ),
                                                ),
                                              ),
                                            ],
                                      ),
                                      Divider(color:apheriapink),
                                             Icon(Icons.arrow_downward, color:apheriapink,size:30)

                                    ],
                                  ),
                                ),
                              )
                              ),
                          )
                        )
                       // Image.asset('images/icon/apheriaWelcome3.png')
                        )
                    : Container(),
                /* GestureDetector(
                      onTap:(){
                        createMatrixList();
                      },
                      child: Center(child: Text(matrixList.toString(),style:TextStyle(color:Colors.black)))),*/
                //MyBannerAd(PenBanner,Colors.amber),
                //MyBannerAd('ca-app-pub-2075277328799016/7282771911','ca-app-pub-2075277328799016/4327748587',AdSize.banner),
                // five,

                Stack(children: matrixList
                    //this list isn't updating into the widget

                    ),
                Stack(
                  children: [
                    //Text('hi,', style: TextStyle(color: Colors.black)),
                    /* matrixList.length == 0
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 100),
                              Text('add a file',
                                  style: TextStyle(
                                      color: apheriapink, fontSize: 50)),
                              Image.asset('images/icons/fileArrow2.png',
                                  semanticLabel:
                                      'arrow pointing to "choose files" button',
                                  width: 250,
                                  color: apheriapink)
                            ],
                          ))
                        : */
                    locked == false
                        ? Container()
                        : Container(
                            color: Colors.transparent.withOpacity(0.00)),
                  ],
                ),
                /* scribbler==true?Scribble(
                            notifier:notifier
                          ):Container()*/
              ],
            ),
          )
        ])));
  }
}

class PopUpPage extends StatefulWidget {
  Widget content, leading;
  String title, subtitle;
  Function callback;
  PopUpPage(
      this.leading, this.title, this.subtitle, this.content, this.callback);
  @override
  State<PopUpPage> createState() => _PopUpPageState(
      this.leading, this.title, this.subtitle, this.content, this.callback);
}

class _PopUpPageState extends State<PopUpPage> {
  Widget content, leading;
  String title, subtitle;
  Function callback;
  _PopUpPageState(
      this.leading, this.title, this.subtitle, this.content, this.callback);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriablue.withOpacity(0.75),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SlideInLeft(
                child: Card(
              elevation: 12,
              shape: curvedcard,
              color: apheriapink,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: step(
                                        leading,
                                        Text(title,
                                            style: TextStyle(
                                                color: Colors.white)))),
                                FloatingActionButton(
                                    shape: circlecard,
                                    backgroundColor: Colors.amber,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child:
                                        Icon(Icons.close, color: Colors.white)),
                                SizedBox(width: 12)
                              ],
                            )),
                        content
                      ],
                    )),
              ),
            )),
          ),
        ));
  }
}
