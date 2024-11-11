import 'dart:async';

import 'package:apheria/constants.dart';
import 'package:apheria/main.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/homePages/starpointsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/testing/v1.dart';

int starpoints = 0;
String test = 'test';
String error = 'error';

Future<void> getStarPoints() async {
  bool success = false;
  //starpoints=3333;
  try {
    await FirebaseFirestore.instance.collection("users").get().then((event) {
      for (var doc in event.docs) {
        if (doc.id.toString() == apheriaUser.uid.toString()) {
          //not being used yet, i think will only need it
          success = true;
          starpoints = doc['star points'];
        }
      }
    });
  } catch (e) {
    error = e.toString();
    //new user
  }
  if (success == false) {
    starpoints = 500;
    updateStarPoints();
  }
  //sploading = false;
}

void updateStarPoints() async {
  /* await FirebaseFirestore.instance.collection("users").get().then((event) {
    
  for (var doc in event.docs) {
    if(doc.id==apheriaUser.uid){
    //not being used yet, i think will only need it
    test='hi??';
     test=doc['star points'].toString();

  starpoints=int.parse(doc['star points']);

 // test=starpoints.toString();
  }}});
  starpoints=starpoints+sum;*/
  FirebaseFirestore.instance.collection("users").doc(apheriaUser.uid).set({
    "star points": starpoints,
  });
  logEvent('sp_action', {'action': 'sp_updated', 'points': starpoints});
}

class userInfo {
  String uid = '';
  String name = '';
  String email = '';
  int starpoints = 0;
  userInfo(
      {required this.uid,
      required this.name,
      required this.email,
      required this.starpoints});
}

class starPointCounter extends StatefulWidget {
  starPointCounter(this.location);
  String location;
  bool extra = false;
  @override
  State<starPointCounter> createState() => _starPointCounterState(this.location);
}

class _starPointCounterState extends State<starPointCounter> {
  _starPointCounterState(this.location);
  String location;
  bool extra = false;
  @override
  Timer? timer;
  String firestoreTest = 'testing';

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Semantics(
        label: 'star points',
        button: true,
        child: GestureDetector(
          onTap: () {
           // if(location=='transfer_screen'||location=='files_home_page'){
            logEvent('navigation_action', {'action': 'home_button_sp'});
            goTo(InAppPurchasePage(),
                context); 
                //havent added functionality for counter from anywhere else
            //}

           //better api fingers crossed than the other one that was causing the grey screen
          },
          child: Card(
            shape: circlecard,
            color: apheriapink,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                  shape: circlecard,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        photoAvatar(),
                        SizedBox(width: 5),
                        //sploading == true
                        //  ? Text('0000'):
                        Text(starpoints.toString(),
                            style: TextStyle(
                                color: darkapheriapink, fontSize: 25)),
                        Icon(Icons.star, color: apheriaamber),
                        //  Image.asset('images/files/ob44.png',width:25,color:apheriapink)
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );

    /*Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {},
          /* if(extra==false){}else{
        //updateUser();
        Navigator.pop(context);
        goTo(InAppPurchasePage(), context);}
        logEvent('navigation_action',
                                          {'action': 'sp_from_files'});
      },*/
          child: Row(
            children: [
              Card(
                  elevation: 0,
                  shape: curvycard,
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Card(
                          shape: curvycard,
                          color: apheriapink,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(children: [
                              photoAvatar(),
                              // Text('${apheriaUser.email}',style:TextStyle(color:Colors.white,fontSize:20)),
                              Text(starpoints.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22)),
                              Icon(Icons.star, color: Colors.white)
                            ]),
                          )

                          //subtitle:extra==false?Container():Text('tap here to earn more',style:TextStyle(color:darkapheriapink)))),

                          ))),
            ],
          ),
        ));
  }*/
  }
}
