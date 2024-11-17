import 'package:apheria/constants.dart';
import 'package:apheria/homePages/violet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VioletSpeech extends StatefulWidget {
  VioletSpeech(this.child, this.title, this.arrow);
  String child;
  bool title = false;
  bool arrow = false;
  @override
  State<VioletSpeech> createState() =>
      _VioletSpeechState(this.child, this.title, this.arrow);
}

class _VioletSpeechState extends State<VioletSpeech> {
  String child;
  bool title = false;
  bool arrow = false;
  _VioletSpeechState(this.child, this.title, this.arrow);
  bool loading = true;
  String violetText='';
  void initState() {
    // TODO: implement initState
    super.initState();
    getViolet();
  }

  @override
  getViolet() async {
    setState(() {
      loading = true;
    });
    violetText = await askViolet(
        'say this as violet: $child ', 100, child);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            // height:MediaQuery.of(context).size.height/5,
            // width:MediaQuery.of(context).size.width/1.2,
            child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
          elevation: 10,
          color: apherialilac,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  title == false
                      ? Container()
                      : Text('welcome to apheria!',
                          style: TextStyle(fontSize: 33)),
                  
                  
                  Row(
                    children: [
                      // Asset image on the left
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child:
                            Image.asset('images/icon/violet.png', width: 100),
                      ),

                      // Text with embedded icon
                      title==true?
                  Expanded(
                    child: RichText(
                                text: TextSpan(
                              style: TextStyle(
                                  fontFamily: 'gamjaFlower', fontSize: 25),
                              children: [
                                TextSpan(
                                    text: 'click on the ',
                                    style: TextStyle(
                                        overflow: TextOverflow.visible)),
                                WidgetSpan(
                                  child: Card(
                                      color: apheriaamber,
                                      shape: circlecard,
                                      child: Icon(Icons.add,
                                          color: Colors.white, size: 30)),
                                ),
                                TextSpan(
                                    text: ' button below to get started!',
                                    style: TextStyle(
                                        overflow: TextOverflow.visible)),
                              ],
                            ),
                          ),
                  ):Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('violet: '+(loading==true?'thinking...':violetText)),
                        ),
                      ),
                    ],
                  ),
                  arrow == false ? Container() : Divider(color: apheriapink),
                  arrow == false
                      ? Container()
                      : Icon(Icons.arrow_downward, color: apheriapink, size: 30)
                ],
              ),
            ),
          )),
    ))
        // Image.asset('images/icon/apheriaWelcome3.png')
        );
  }
}
