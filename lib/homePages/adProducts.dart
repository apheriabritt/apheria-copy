import 'package:apheria/constants.dart';
import 'package:apheria/homePages/creationCard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class creationAd {
  String title;
  String link;
  String image;
  creationAd(this.title, this.link, this.image);
}

creationAd inkboxFreehandPen = creationAd('inkbox freehand marker',
    'https://amzn.to/3YCDstM', 'images/productAds/inkboxFreehandMarker.jpg');

Widget AdCard(creationAd ad) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
        color: apheriapurple,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                onTap: () {
                  launchUrl(Uri.parse(ad.link));
                },
                trailing: Icon(Icons.double_arrow_rounded, color: apheriapink),
                leading: Image.asset(ad.image),
                title:
                    Text(' ${ad.title}', style: TextStyle(color: apherialemon)),
                subtitle: Text('buy now',
                    style: TextStyle(color: apherialavender))))),
  );
}

Widget techCard(String title) {
  return Padding(
    padding:EdgeInsets.all(8),
    child:Card(
    color:apheriapurple,
    child: Padding(
      padding:EdgeInsets.all(8),
      child:Text(title)
    )));
}


