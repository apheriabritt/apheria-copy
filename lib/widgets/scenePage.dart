import 'package:apheria/constants.dart';
import 'package:apheria/data/worldData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScenePage extends StatefulWidget {
  ScenePage(this.title, this.bgcolor, this.main);
  String title;
  Widget main;
  Color bgcolor;

  @override
  State<ScenePage> createState() =>
      _ScenePageState(this.title, this.bgcolor, this.main);
}

class _ScenePageState extends State<ScenePage> {
  _ScenePageState(this.title, this.bgcolor, this.main);
  String title;
  Widget main;
  Color bgcolor;
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgcolor,
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1517693923.
        appBar: apheriaAppBar(context, title),
        body: ListView(
          children: [
            SizedBox(height: 12),
            sceneText('welcome to $title!',apheriapink),
            main,
            SizedBox(height: 50)
          ],
        ));
  }
}
