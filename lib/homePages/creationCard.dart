import 'package:apheria/constants.dart';
import 'package:apheria/homePages/adProducts.dart';
import 'package:apheria/homePages/newAddPage.dart';
import 'package:apheria/widgets/horizontalFileList.dart';
import 'package:apheria/widgets/violetCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreationCard extends StatefulWidget {
  Creation creation;
  CreationCard(this.creation);

  @override
  State<CreationCard> createState() => _CreationCardState(this.creation);
}

class _CreationCardState extends State<CreationCard> {
  _CreationCardState(this.creation);
  Creation creation;
  @override
  Widget methodCard(String title, List list) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 3,
          color: darkapheriapink,
          child: Column(
            children: [
              ListTile(
                  title:
                      Text('$title:', style: TextStyle(color: Colors.white))),
              ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('★ ${list[index]}'));
                  })
            ],
          )),
    );
  }

  Widget adList(List list) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 3,
          color: darkapheriapink,
          child: Column(
            children: [
              ListTile(
                  title: Text('ads:', style: TextStyle(color: Colors.white))),
              ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AdCard(list[index]);
                  })
            ],
          )),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriapink,
        appBar: apheriaAppBar(context, creation.title),
        body: ListView(
          children: [
            VioletSpeech(
                'introduce ${creation.title} in 10 words max, say something like "lets make... together"',
                false,
                false),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: curvedcard,
                    color: apherialavender.withOpacity(0.5),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(creation.image,
                            //width:MediaQuery.of(context).size.width/2,

                            height: MediaQuery.of(context).size.width / 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            methodCard('materials', creation.materials),
            methodCard('tools', creation.tools),
            methodCard('method', creation.method),
            //techCard('lens drawing'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HorizontalFileList(
                  creation.files, 'files:', darkapheriapink, () {}, () {}, ''),
            ),
            adList(creation.ads)
            // methodCard('files',creation.files)
          ],
        ));
  }
}

