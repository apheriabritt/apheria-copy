import 'package:apheria/constants.dart';
import 'package:apheria/homePages/violet.dart';
import 'package:apheria/widgets/violetCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/compute/v1.dart';

class ShootingStarPoints extends StatefulWidget {
  const ShootingStarPoints({super.key});

  @override
  State<ShootingStarPoints> createState() => _ShootingStarPointsState();
}

class _ShootingStarPointsState extends State<ShootingStarPoints> {
  bool shootingSP = true;
  String explanation = 'every day i will send you  a secret shooting star. click on it in time to be able to get some free star points!';
  bool loading = false;

  @override
  

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriapink,
        appBar: apheriaAppBar(context, 'shooting star points'),
        body: ListView(
          children: [
            loading==true?Container():VioletSpeech(explanation, false, false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color:shootingSP==true?apherialemon:apherialavender,
                  child: SwitchListTile(
                    title:Text('daily shooting star point notifications',style:TextStyle(color:apheriapurple)),
               subtitle: Text(shootingSP == false ? 'turned off' : 'turned on',style:TextStyle(color:darkapheriapink)),
                value: shootingSP,
                onChanged: (value) {
                  setState(() {
                    shootingSP = value;
                  });
                },
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('apheria shooting star points can be sent at any time. but we will only send one per day. so keep an eye out!'
              ,style:TextStyle(color:apherialilac)),
            )
          ],
        ));
  }
}
