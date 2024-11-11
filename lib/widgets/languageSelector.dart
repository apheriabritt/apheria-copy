//flutter

import 'package:apheria/newTransferScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

//packages

//firebase

//other
import 'package:shared_preferences/shared_preferences.dart';

//project

//data

//home pages

//services
import 'package:apheria/services/analytics.dart';

//widgets

//other
import 'package:apheria/constants.dart';

class BaseLanguage{
  String chosenLanguage;
  String flag;
  String display;
  BaseLanguage(this.chosenLanguage,this.flag,this.display);
}


BaseLanguage english = BaseLanguage('gbr','🇬🇧','english');
BaseLanguage danish = BaseLanguage('den','🇩🇰','dansk');
BaseLanguage swedish = BaseLanguage('swe','🇸🇪','svenska');
BaseLanguage icelandic = BaseLanguage('isl','🇮🇸','íslensku');
BaseLanguage norweigan = BaseLanguage('nor','🇳🇴','norsk');
BaseLanguage korean = BaseLanguage('kor','🇰🇷','한국인');
BaseLanguage japanese = BaseLanguage('jap','🇯🇵','日本語');

BaseLanguage baseLanguage=english;

List<BaseLanguage> languages=[
english,danish,swedish,icelandic,norweigan,korean,japanese
];



class LanguageSelector extends StatefulWidget {
  LanguageSelector(this.language);
  BaseLanguage language;


  @override
  State<LanguageSelector> createState() => _LanguageSelectorState(this.language);
}

class _LanguageSelectorState extends State<LanguageSelector> {
  _LanguageSelectorState(this.language);
   BaseLanguage language;


  @override
  Widget build(BuildContext context) {
    String fontFamily='gamjaFlower';
  if(language=='japanese'){
    fontFamily='kiwiMaru';
  }
  return ListTile(
                       onTap:() async{
                      baseLanguage=language;
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('language', language.chosenLanguage);
                      //log in analytics
                   /*    logEvent(
      'language_chosen',
      {'language':language.chosenLanguage}
    );*/
    Navigator.pop(context); //close dialog
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => NewTransferScreen('images/files/ob57.png')),
  ); //push to home page - refresh the whole thing
 
  
                      },
                    
                      leading:Text(language.flag),
                      title:Text(language.display,style:TextStyle(color:Colors.white,fontFamily:fontFamily)));


  }
}

void getLanguage() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
String? language = prefs.getString('language');
if(language==null){}
else{languages.forEach((element) async {
  if(language==element.chosenLanguage){
    baseLanguage=element;
  }
});} 
///set language as initial language english if null too, safety net
   await prefs.setString('language', baseLanguage.chosenLanguage);
   



}