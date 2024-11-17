import 'package:apheria/constants.dart';
import 'package:apheria/widgets/violetCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Coupon {
  String title;
  String about;
  String code;
  String link;
  String offer;

  Coupon(this.title, this.about, this.code, this.offer, this.link);
}

class DiscountCodes extends StatefulWidget {
  const DiscountCodes({super.key});

  @override
  State<DiscountCodes> createState() => _DiscountCodesState();
}

class _DiscountCodesState extends State<DiscountCodes> {
  List<Coupon> coupons = [
    Coupon('preworn', 'second hand clothing', 'apheria', '10% off',
        'https://preworn.ltd/?ref=apheria'),
    Coupon('astrid & miyu', 'high quality jewellery, piercings and tattoos',
        'apheria app', 'enter prize draw', 'https://www.astridandmiyu.com'),
    Coupon('the body shop', 'ethical make-up', 'apheria app',
        '£10 off £30 first order', 'https://www.thebodyshop.com'),
    Coupon('lucy & yak', 'fun fleeces and dungarees', 'apheria app',
        '25% off first order over £70', 'https://www.lucyandyak.com')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: apheriapink,
      appBar: apheriaAppBar(context, 'discount codes'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: curvedcard,
          color: apheriapurpletwo.withOpacity(0.5),
          //elevation:3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                VioletSpeech(
                    'use the discount codes below for your apheria creations!',
                   // textAlign: TextAlign.center,
                  false,false
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: coupons.length,
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                          color: apheriapurple,
                          shape: curvedcard,
                          elevation: 3,
                          child: ListTile(
                              onTap: () {
                                launchUrl(Uri.parse(coupons[index].link));
                              },
                              title: Text(
                                  coupons[index].title +
                                      ': ' +
                                      coupons[index].offer,
                                  style: TextStyle(color: apheriapurpletwo)),
                              trailing: Icon(Icons.copy, color: apherialemon),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(coupons[index].about,
                                      style: TextStyle(
                                          color: apherialavender,
                                          fontSize: 20)),
                                  Text('enter code: "${coupons[index].code}"',
                                      style: TextStyle(color: apherialemon)),
                                ],
                              )));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
