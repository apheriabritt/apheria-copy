//flutter

import 'package:apheria/services/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//packages

//firebase

//other
import 'package:google_wallet/google_wallet.dart';

//project

//data

//home pages

//services

//widgets
import 'package:apheria/widgets/languageSelector.dart';

//other

GoogleWallet googleWallet = GoogleWallet();
bool? isWalletAvailable = true;
String error = 'no error found';

class AddToWalletButton extends StatefulWidget {
  String jwt;
  String reference;
  AddToWalletButton(this.jwt, this.reference);

  @override
  State<AddToWalletButton> createState() =>
      _AddToWalletButtonState(this.jwt, this.reference);
}

class _AddToWalletButtonState extends State<AddToWalletButton> {
  _AddToWalletButtonState(this.jwt, this.reference);
  String jwt;
  String reference;

  @override
  void initState() {
    super.initState();
    main();
  }

  main() async {
    await checkWalletAvailable();
  }

  @override
  Widget build(BuildContext context) {
    var newString = jwt.substring(jwt.length - 5);
    String buttonImage = 'images/wallet/googlewallet_gb.png';
    String? language = baseLanguage.chosenLanguage;
    if (language == 'jap') {
      buttonImage = 'images/wallet/googlewallet_japan.png';
    }
    return Column(children: [
      //Text('jwt: $newString'),
      isWalletAvailable == false
          ? Text(error)
          : GestureDetector(
              child: Image.asset(buttonImage),
              onTap: () {
//logEvent('card_click', {'url': 'google_wallet_${newString}'});

                addToWallet(jwt);
                logEvent('world_action',
                    {'action': 'wallet_redeemed', 'deck': reference});
              })
    ]);
  }
}

checkWalletAvailable() async {
  bool? available;
  String errorstring = 'error';
  try {
    available = await googleWallet.isAvailable();

    ///wallet is available
    error = 'wallet available: $available';
  } on PlatformException catch (e) {
    ///wallet not available
    if (e.message == null) {
    } else {
      errorstring = e.message ?? 'error';

      ///nullable error
    }
    error = error + ' ' + errorstring;
  }
  isWalletAvailable = available;
}

addToWallet(String jwt) async {
  bool? saved = false;
  try {
    if (isWalletAvailable == true) {
      await googleWallet.savePassesJwt(jwt);
      //save pass
    } else {
      ///error
    }
  } on PlatformException catch (e) {
    ///error
  }
}
