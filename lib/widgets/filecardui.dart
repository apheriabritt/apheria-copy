//flutter

import 'dart:async';

import 'package:apheria/homePages/filesHomePage.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/homePages/starpointsPage.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:flutter/material.dart';

//packages

//firebase

//other

//project

//data

//home pages

//services

//widgets

//other
import 'package:apheria/constants.dart';
import 'package:apheria/newTransferScreen.dart';

String globalFile = '';

class FileCardUI extends StatefulWidget {
  int index;
  // NavScene scene;
  String fileid;
  Function callback;
  Function bigCallback;
  String location;

  FileCardUI(
      this.index, this.fileid, this.callback, this.bigCallback, this.location);

  @override
  State<FileCardUI> createState() => _FileCardUIState(
      this.index, this.fileid, this.callback, this.bigCallback, this.location);
}

class _FileCardUIState extends State<FileCardUI> {
  int index;
  String fileid;
  Function callback;
  Function bigCallback;
  String location;
  // NavScene scene;

  _FileCardUIState(
      this.index, this.fileid, this.callback, this.bigCallback, this.location);

  String imagepath = '';
  bool checked = false;
  bool userFile = false;

  bool loading = true;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCheck();
    getMatrix();
    imagepath = 'images/files/${fileid}.png';
  }

  void getCheck() async {
    // getFiles();
    await Future.forEach(userFiles, (element) async {
      if (element == fileid) {
        userFile = true;
      }
      //else{userFile=false;}
    });

    bool checking = false;
    await Future.forEach(checkedFiles, (element) async {
      if (element == fileid) {
        checking = true;
      }
      //else{checked=false;}
    });
    if (checking == true) {
      checked = true;
    } else {
      checked = false;
    }
    setState(() {
      loading = false;
    });
  }

  void setWholeState() {
    setState(() {});
  }

  Widget fileRedemptionScreen() {
    logEvent('file_action', {'action': 'redemption_screen', 'file': fileid, 'file_location':location});
    if (starpoints < 100) {
      logEvent('file_action', {
        'action': 'not_enough_points',
        'points': starpoints,
        'file': fileid,
        'file_location':location
      });
    }
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                    color: apheriapink,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(printerror),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                starPointCounter('file_card_ui'),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                  child: FloatingActionButton(
                                    child:
                                        Icon(Icons.close, color: Colors.white),
                                    backgroundColor: darkapheriapink,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                //SizedBox(width:12)
                              ],
                            ),
                            // userFile == true
                            //    ? Container()
                            //    : starPointCounter(false),
                            /* Center(
                                child: Text(
                              userFile == true
                                  ? 'add or remove file from canvas'
                                  : starpoints < 100
                                      ? "you don't have enough star points to redeem this file"
                                      : 'redeem for 100 star points?',
                              textAlign: TextAlign.center,
                            )),
                            */
                            SizedBox(height: 12),

                            Center(
                                child: Stack(
                              children: [
                                Card(
                                    color: Colors.white,
                                    shape: curvedcard,
                                    child: Image.asset(
                                        'images/files/${fileid}.png',
                                        cacheHeight: 500,
                                        cacheWidth: 500,
                                        width: 250,
                                        height: 250)),
                              ],
                            )),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (starpoints < 100) {
                                          /*Navigator.pop(context);
                                              goReplace(InAppPurchasePage(), context);
                                              logEvent('file_action', {
                                                'action': 'get_more_points',
                                                'points': starpoints,
                                                'file': fileid
                                              });*/
                                        } else {
                                          userFiles.add(fileid);
                                          updateFiles(fileid);
                                          starpoints = starpoints - 100;
                                          updateStarPoints();
                                          logEvent('file_action', {
                                            'action': 'file_purchase',
                                            'file': fileid,
                                          'file_location':location
                                          });
                                          getCheck();
                                          await getFiles();
                                          //
                                          callback();
                                          // bigCallback();
                                          // getShopFiles();
                                          //shopFiles.remove(fileid);
                                          setState(() {});
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Opacity(
                                        opacity: starpoints < 100 ? 0.5 : 1,
                                        child: Card(
                                            color: apheriabluetwo,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.sell,
                                                      color: Colors.white),
                                                  SizedBox(width: 4),
                                                  Text('100',
                                                      style: TextStyle(
                                                          fontSize: 33)),
                                                  SizedBox(width: 4),
                                                  Icon(Icons.star,
                                                      color: Colors.white)
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //SizedBox(height: 12),
                            // starpoints<100?Text('you do not have enough star points'):Container()
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget selectWidget(IconData icon, String hero, double top, double bottom,
      double left, double right) {
    return Positioned(
        top: top,
        left: left,
        bottom: bottom,
        right: right,
        child: FloatingActionButton(
          backgroundColor: darkapheriapink,
          heroTag: hero,
          onPressed: () {},
          //
          child: Icon(icon, color: apheriaamber),
        ));
  }

  int matrixNumber = 0;
  String printerror = 'no error';

  getMatrix() {
    matrixNumber = 0;
    checkedFiles.forEach((element) {
      if (element == fileid) {
        matrixNumber = matrixNumber + 1;
      }
    });
  }

  Widget build(BuildContext context) {
    // if(number<7){unlocked=true;}
    getMatrix();
    return Semantics(
      label: userFile == true ? 'select file' : 'redeem file',
      child: GestureDetector(
          onTap: () async {
            if (userFile == true) {
              checkedFiles.add(fileid);
              matrixList.add(matrix(fileid));
              logEvent('file_action', {'action': 'file_added', 'file': fileid,'file_location':location});

              /* } else if (checked == true) {
                checkedFiles.remove(fileid);
                matrixList.remove(matrix(fileid));
                logEvent('file_action',
                    {'action': 'file_deactivated', 'file': fileid});
              }*/

              getCheck();
              getMatrix(); //getFiles()
              callback();
              setState(() {});
              // Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => NewTransferScreen('')),
                (Route<dynamic> route) => false,
              );
            } else {
              try {
                goToPopUp(fileRedemptionScreen(), context);
              } catch (e) {
                printerror = e.toString();
              }
            }
            //}
          },
          child: loading == true
              ? Container()
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Card(
                              color: Colors.white,
                              elevation: 2,
                              // shadowColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              // color: unlocked==true?Colors.white.withOpacity(0.9):Color(0xfffaff9c).withOpacity(0.9),
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      imagepath,
                                      width: 100,
                                      cacheWidth: 250,
                                      fit: BoxFit.cover,
                                      color: Colors.black,
                                    ),
                                    /* Positioned(
                              bottom:0,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(internet==false?Icons.error:unlocked==true?Icons.check:Icons.lock,color:unlocked==true?apheriapink:Colors.amber),
                              )),*/
                                    /*Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  remove.toLowerCase(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color:apheriapink,
                                      fontFamily: 'apheriafont'),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),*/
                                  ],
                                ),
                              ))),
                    ),
                    /* userFile == false
                        ? Container()
                        : Positioned(
                            top: 0,
                            left: 0,
                            child: CircleAvatar(
                              radius:17,
                                backgroundColor: darkapheriapink,
                                //shape:curvedcard,
                                child: Text(matrixNumber.toString(),style:TextStyle(color:apheriaamber))),
                          ),*/
                    /*   userFile == false
                        ? Container()
                        : Positioned(
                            bottom: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                checkedFiles.remove(fileid);
                                //matrixList.remove(fileid);
                                getMatrix();
                                callback();
                              },
                              child: CircleAvatar(
                                radius:17,
                                  backgroundColor: apheriabluetwo,
                                  //shape:curvedcard,
                                  child: Text('-',style:TextStyle(color:apheriaamber))),
                            ),
                          ),*/

                    Positioned(
                        top: 0,
                        right: 0,
                        child: Card(
                          shape: circlecard,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Card(
                              elevation: 2,
                              color: userFile == true
                                  ? apheriaamber
                                  : darkapheriapink,
                              child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: userFile == true
                                      ? Icon(Icons.add,
                                          size: 20, color: Colors.white)
                                      : Icon(Icons.lock,
                                          size: 20, color: Colors.white)),
                            ),
                          ),
                        )),
                  ],
                )),
    );
  }
}
