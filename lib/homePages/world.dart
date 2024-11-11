import 'package:apheria/constants.dart';
import 'package:apheria/main.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/widgets/scenePage.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:apheria/homePages/violet.dart';
import 'package:apheria/data/worldData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List userScenes = [];

Future<void> getScenes() async {
  //get user files
  try {
    await FirebaseFirestore.instance
        .collection("users/${apheriaUser.uid}/scenes")
        .get()
        .then((event) {
      for (var doc in event.docs) {
        if (userScenes.contains(doc.id)) {
        } else {
          userScenes.add(doc.id);
        }
      }
    });
  } catch (e) {
    error = e.toString();
  }
}

void updateScenes(String title) async {
  FirebaseFirestore.instance
      .collection("users")
      .doc("${apheriaUser.uid}")
      .collection("scenes")
      .doc(title)
      .set({
    'purchase date':
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    'purchase time':
        '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}'
  });
}

class apheriaWorld extends StatefulWidget {
  const apheriaWorld({super.key});

  @override
  State<apheriaWorld> createState() => _apheriaWorldState();
}

class _apheriaWorldState extends State<apheriaWorld> {


  Widget worldCard(String title, String image, Widget scene) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: GestureDetector(
        onTap: () {
          if (userScenes.contains(title)) {
                      logEvent('world_action', {'action': 'paid_card_click','scene':title});

            goTo(ScenePage(title, apheriabluetwo, scene), context);
          } else {
                                  logEvent('world_action', {'action': 'scene_redemption_screen','scene':title});

            goToPopUp(
                Center(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                starPointCounter('world_card_ui'),
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                   child: FloatingActionButton(
                                              child: Icon(Icons.close,
                                                  color: Colors.white),
                                              backgroundColor: darkapheriapink,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),)
                                            //SizedBox(width: 12)
                                          ],
                                        ),

                                        SizedBox(height: 12),
                                        Text(title),

                                        Center(
                                            child: Stack(
                                          children: [
                                            Card(
                                                color: Colors.white,
                                                shape: curvedcard,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.asset(
                                                    image,
                                                    //cacheHeight: 500,
                                                    cacheWidth:500,
                                                    width: 500,
                                                  ),
                                                )),
                                          ],
                                        )),

                                        Row(
                                           mainAxisAlignment:MainAxisAlignment.center,
                                          children: [
                                             Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: 
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(0.0),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          if (starpoints < 250) {
                                                            /*Navigator.pop(context);
                                              goReplace(InAppPurchasePage(), context);
                                              logEvent('file_action', {
                                                'action': 'get_more_points',
                                                'points': starpoints,
                                                'file': fileid
                                              });*/
                                                          } else {
                                                            userScenes.add(title);
                                                            updateScenes(title);
                                                            starpoints =
                                                                starpoints - 250;
                                                            updateStarPoints();
                                                           logEvent('world_action', {'action': 'scene_redeemed','scene':title});

                                                            /* logEvent('file_action', {
                                                      'action': 'file_purchase',
                                                      'file': fileid
                                                    });*/
                                                            //getCheck();
                                                            await getScenes();
                                                            //
                                                            /// callback();
                                                            // bigCallback();
                                                            // getShopFiles();
                                                            //shopFiles.remove(fileid);
                                                            setState(() {});
                                                            Navigator.pop(context);
                                                          }
                                                        },
                                                        child: Opacity(
                                                          opacity: starpoints < 100
                                                              ? 0.5
                                                              : 1,
                                                          child: Card(
                                                              color: apheriabluetwo,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(Icons.sell,
                                                                        color: Colors
                                                                            .white),
                                                                    SizedBox(
                                                                        width: 4),
                                                                    Text('250',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                33)),
                                                                    SizedBox(
                                                                        width: 4),
                                                                    Icon(Icons.star,
                                                                        color: Colors
                                                                            .white)
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
                ),
                context);
          }
        },
        child: Stack(
          children: [
            Card(
              color: Colors.white,
              shape: curvedcard,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                    color: apheriapink,
                    shape: curvedcard,
                    elevation: 2,
                    child: Column(
                      children: [
                        Opacity(
                          opacity: userScenes.contains(title) ? 1 : 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(image)),
                          ),
                        ),
                        Text(title, style: TextStyle(fontSize: 25))
                      ],
                    )),
              ),
            ),
            userScenes.contains(title)
                ? Container()
                : Positioned(
                    top: 0,
                    right: 0,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('250', style: TextStyle(color: apheriabluetwo)),
                          Icon(Icons.star, color: apheriaamber)
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScenes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriabluetwo,
        appBar: apheriaAppBar(context, 'the apheria world'),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('images/icon/colourplanet2.png'),
            Column(
              children: [
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 4),
                      starPointCounter('world'),
                      /*
                      FloatingActionButton.extended(
                        backgroundColor: darkapheriapink,
                        onPressed: (){}, 
                        icon:Icon(Icons.calendar_month,color:Colors.white),
                      label: Row(
                        children: [
                          Text('events',style:TextStyle(color:Colors.white)),
                          SizedBox(width:12),
                        Icon(Icons.arrow_forward,color:Colors.white),

                        ],
                      ))*/
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      /*Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 2),
                        child: Card(
                          shape:curvedcard,
                          elevation:3,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              color:darkapheriapink,
                              shape:curvedcard,
                              //color:apheriabluetwo,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('visit places in the apheria world for creation inspiration!',
                                    style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        ),
                      ),*/
                      //VioletCard(),
                      worldCard('apheria HQ', 'images/world/brittDesk.jpg',
                          ApheriaHQ()),
                      worldCard('the observatory',
                          'images/world/observatory.jpg', ObservatoryScene()),
                      worldCard('the tarot tent', 'images/world/tarotTent.png',
                          TarotScene()),

                      worldCard('apheria boutique', 'images/world/boutique.jpg',
                          BoutiqueScene()),
                      // worldCard('tattoo studio','images/world/tarotTent.jpg'),
                      // worldCard('flower garden','images/world/tarotTent.jpg'),
                      //worldCard('tea rooms','images/world/tarotTent.jpg'),
                      // worldCard('blossom garden','images/world/tarotTent.jpg'),
                      // worldCard('alien invasion','images/world/tarotTent.jpg')
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
