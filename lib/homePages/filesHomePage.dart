//flutter

import 'dart:async';

import 'package:apheria/main.dart';
import 'package:apheria/newTransferScreen.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/homePages/starpointsPage.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//packages

//firebase

//other
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

//project

//data
import 'package:apheria/data/langText.dart';
import 'package:apheria/data/scenesData.dart';

//home pages

//services

//widgets
import 'package:apheria/widgets/filecardui.dart';
import 'package:apheria/widgets/horizontalFileList.dart';

//other
import 'package:apheria/constants.dart';

List<String> userFiles = [];
List<String> shopFiles = [];
getShopFiles() {
  shopFiles =
      allfiles.where((element) => !userFiles.contains(element)).toList();
}

///this needs to link
String userFilesString = '[]';

Future<void> getFiles() async {
  //get user files
  try {
    await FirebaseFirestore.instance
        .collection("users/${apheriaUser.uid}/files")
        .get()
        .then((event) {
      for (var doc in event.docs) {
        if (userFiles.contains(doc.id)) {
        } else {
          userFiles.add(doc.id);
        }
      }
    });
  } catch (e) {
    error = e.toString();
  }
  //shop files = allfiles - user files - free files
  shopFiles = List.from(Set.from(allfiles).difference(Set.from(userFiles)));
}

void updateFiles(String fileid) async {
  FirebaseFirestore.instance
      .collection("users")
      .doc("${apheriaUser.uid}")
      .collection("files")
      .doc(fileid)
      .set({
    'purchase date':
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    'purchase time':
        '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}'
  });
}

Widget FilesCard(LangString title, List<Widget> fileList) {
  return Card(
      shape: curvedcard,
      elevation: 2,
      color: Colors.white.withOpacity(0.6), //could ad white
      child: Column(
          children: [LangStringWidget(title), Column(children: fileList)]));
}

class FilesListHome extends StatefulWidget {
  FilesListHome(this.callback);
  Function callback;
  @override
  State<FilesListHome> createState() => _FilesListHomeState(this.callback);
}

class _FilesListHomeState extends State<FilesListHome> {
  _FilesListHomeState(this.callback);
  Function callback;
  String fileoftheday = '';
  bool loading = true;

  void filecallback() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(
        milliseconds: 100)); //the only thing that will refresh the shop files
    setState(() {
      loading = false;
    });
  }

  void fileOfTheDay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    ///maybe i should decide them myself - eg halloween ones and christmas ones?
    DateTime now = new DateTime.now();
    var dateformat = DateFormat('dd/MM/yyyy');
    var outputDate = dateformat.format(now); //get todays date
    try {
      final String? getFile = prefs.getString(outputDate);

      fileoftheday = getFile ?? "";
    } catch (e) {
      fileoftheday == 'ob57';
    }
    if (fileoftheday == "") {
      allfiles.shuffle();
      fileoftheday = allfiles.first;
      await prefs.setString(outputDate, fileoftheday);
    }

    setState(() {
      loading = false;
    });
  }

  Timer? timer;

  void initState() {
    // TODO: implement initState
    super.initState();
    // fileOfTheDay();
    userFiles.clear();
    wait();
    //  timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {
    //    getFiles();
    //  }));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void wait() async {
    await Future.delayed(Duration(milliseconds: 1000));
    await getFiles();
    setState(() {
      loading = false;
    });
  }

  Widget fileListCard(
      String title, List<String> list, Color color, List<String> overallList) {
    List<String> matchingFiles = [];
      matchingFiles = userFiles.where((element) => Set.from(overallList).contains(element)).toList();


  // Iterate through the second list and check for common elements.
    return Card(
      elevation: 2,
      color: color,
      child: ExpansionTile(
        trailing: Icon(Icons.arrow_downward, color: Colors.white),
        title: Text(title, style: TextStyle(color: Colors.white)),
        subtitle: Text(
            '${matchingFiles.length}/${overallList.length} (${((matchingFiles.length / overallList.length) * 100).toStringAsFixed(1)}%)',
            style: TextStyle(fontSize: 25, color: Colors.white)),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return FileCardUI(index, list[index], filecallback, callback,
                      'redeemed files');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //check for updates
    //getShopFiles();
    //getFiles();
    return Scaffold(
      backgroundColor: apheriapink,
      appBar: apheriaAppBar(context, 'choose files'),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Center(
              child: Container(
                  width: 500,
                  child: Image.asset('images/icon/bigPlanet.png',
                      color: Colors.white.withOpacity(0.6))),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      starPointCounter('files_home_page'),
                      Expanded(
                          // color: apheriapink,
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'select files to redeem or add them to your canvas'),
                      )),
                    ],
                  ),

                  SizedBox(height: 12),
                  // Image.asset('images/icon/planet.png',color:apheriapink),
                  loading == true
                      ? Container()
                      : Expanded(
                          child: ListView(
                          children: [
                            fileListCard('redeemed files', userFiles,
                                darkapheriapink, allfiles),
                            fileListCard('tarot files', tarot, apheriapurple,
                                tarot),
                            fileListCard('apheria hq files', apheriaHQFiles,
                                apheriapurpletwo, apheriaHQFiles),

                            fileListCard('observatory files', observatorylist,
                                apheriabluetwo, observatorylist),
                            fileListCard(
                                'flower garden files',
                                flowergardenlist,
                                apheriablue,
                                flowergardenlist),
                            fileListCard(
                                'haunted house files',
                                hauntedhouselist,
                                apheriapurple,
                                hauntedhouselist),
                            fileListCard('jungle files', junglelist,
                                apheriagreen, junglelist),
                            fileListCard('cloud files', cloudslist,
                                apheriapurpletwo, cloudslist),
                            fileListCard('jurassic files', jurassiclist,
                                darkapheriapink, jurassiclist),
                            fileListCard(
                                'blossom garden files',
                                blossomgardenlist,
                                apheriagreen,
                                blossomgardenlist),
                            fileListCard(
                                'cafe files', cafelist, apherialilac, cafelist),
                            fileListCard('deep sea files', deepsealist,
                                apheriablue, deepsealist),
                            fileListCard(
                                'eco files', ecolist, apheriagreen, ecolist),
                            fileListCard(
                                'et files', etlist, apheriapurple, etlist),
                            //  fileListCard('down to hell files',[], apherialilac, userFiles, observatorylist),
                            //fileListCard('violet files',[], apherialilac, userFiles, observatorylist),
                          ],
                        )
                          /*ListView(
                  children: [
                  HorizontalFileList(userFiles,'my files', apheriapink,filecallback,callback),
        
                    HorizontalFileList(observatorylist,'observatory', apheriapink,filecallback,callback),
                    HorizontalFileList(flowergardelistn,'flower garden', apheriapink,filecallback,callback),
                    HorizontalFileList(cloudslist,'clouds', apheriapink,filecallback,callback),
                    HorizontalFileList(hauntedhouselist,'jungle', apheriapink,filecallback,callback),
                    HorizontalFileList(ecolist,'greenhouse', apheriapink,filecallback,callback),
                    HorizontalFileList(etlist,'extra-terrestrial', apheriapink,filecallback,callback),
                  ],
                ),*/
                          ),

                  /* FileList(userFiles,callback,true),
                                SizedBox(height:12),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color:apheriapink,
                                    child:ListTile(
                                    onTap:(){ 
                                      Navigator.pop(context);
                                      goTo(
                                    NewFilesHome(),context);},
                                    trailing:Icon(Icons.arrow_forward,color:Colors.white),
                                    title:Text('view more files',style:TextStyle(color:Colors.white)),
                                    subtitle:Text('redeem star points',style:TextStyle(color:Colors.white))
                                  ),),
                                ),*/

                  //
                  BackToTransferScreen()
                ]),
          ],
        ),
      ),
    );
  }
}

class BackToTransferScreen extends StatefulWidget {
  const BackToTransferScreen({super.key});

  @override
  State<BackToTransferScreen> createState() => _BackToTransferScreenState();
}

class _BackToTransferScreenState extends State<BackToTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {
              //updateUser();
              logEvent(
                  'navigation_action', {'action': 'back_to_transfer_screen'});
              goReplace(NewTransferScreen(''), context);
            },
            child: Card(
                elevation: 5,
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.screen_share_rounded, color: apheriapink),
                  // trailing:Icon(Icons.star,color:apheriapink),
                  title: Text('back to transfer screen',
                      style: TextStyle(color: apheriabluetwo)),
                  // subtitle:Text('tap here to earn more',style:TextStyle(color:apheriapink))))
                ))));
  }
}
