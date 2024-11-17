import 'package:apheria/constants.dart';
import 'package:apheria/homePages/violet.dart';
import 'package:apheria/widgets/violetCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayPassPoints extends StatefulWidget {
  const PlayPassPoints({super.key});

  @override
  State<PlayPassPoints> createState() => _PlayPassPointsState();
}

class _PlayPassPointsState extends State<PlayPassPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: apheriapink,
      appBar: apheriaAppBar(context, 'free star points'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 12),
            Text('google play points:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: apheriapurple)),
            VioletSpeech(
              'open google play, and tap your profile icon. you can sign up for play points here. earn points with in-app purchases, subscriptions and books across the whole play store. you can then redeem those points for credit.',
              false,
              false,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                  //  icon: Icon(Icons.keyboard_double_arrow_right),
                  backgroundColor: apherialemon,
                  label: Text('google play store'),
                  onPressed: () {
                    final InAppReview inAppReview = InAppReview.instance;
                    inAppReview.openStoreListing();
                  }),
            ),
            SizedBox(height: 12),
            Text('google opinion rewards:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: apheriapurple)),
            VioletSpeech(
                'using the google rewards app, answer questions about your purchase history, and provide reciept data in exchange for google play credit.',
                false,
                false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                  backgroundColor: apherialemon,
                  label: Text('google opinion rewards'),
                  onPressed: () {
                    launchUrl(Uri.parse(
                        'https://googleopinionrewards.page.link/share'));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
