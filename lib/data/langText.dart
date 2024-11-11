//flutter

import 'package:flutter/material.dart';
import 'dart:async';

//packages

//firebase

//other

//project

//data

//home pages

//services

//widgets
import 'package:apheria/widgets/languageSelector.dart';

//other

String globalFontFamily = 'gamjaFlower';

class LangString{
    String english='';
    String danish='';
    String swedish='';
    String icelandic='';
    String norweigan='';
    String korean='';
    String japanese='';
    LangString({required this.english,required this.danish,required this.swedish,required this.icelandic,required this.norweigan,required this.korean,required this.japanese});
}


Future<String> createLangString(LangString string) async {
//final SharedPreferences prefs = await SharedPreferences.getInstance();

String? language = baseLanguage.chosenLanguage;


String finalString='';

    if(language=='gbr'){finalString=string.english;}
    if(language=='den'){finalString=string.danish;}
    if(language=='swe'){finalString=string.swedish;}
    if(language=='isl'){finalString=string.icelandic;}
    if(language=='nor'){finalString=string.norweigan;}
    if(language=='kor'){finalString=string.korean;}
    if(language=='jap'){
        finalString=string.japanese;
        globalFontFamily='kiwiMaru';

        }


return finalString;
}

///i think this might be the problem




class LangStringWidget extends StatefulWidget {
    LangString string;
    LangStringWidget(this.string);

  @override
  _LangStringWidgetState createState() => _LangStringWidgetState(this.string);
}

class _LangStringWidgetState extends State<LangStringWidget> {

     LangString string;
    _LangStringWidgetState(this.string);
  @override
  Widget build(BuildContext context) {
    String? language = baseLanguage.chosenLanguage;


String finalString='';

    if(language=='gbr'){finalString=string.english;
            globalFontFamily='gamjaFlower';

    }
    if(language=='den'){finalString=string.danish;}
    if(language=='swe'){finalString=string.swedish;}
    if(language=='isl'){finalString=string.icelandic;}
    if(language=='nor'){finalString=string.norweigan;}
    if(language=='kor'){finalString=string.korean;}
    if(language=='jap'){
        finalString=string.japanese;
        globalFontFamily='kiwiMaru';

        }


    return Text(
                    finalString,style:TextStyle(fontFamily:globalFontFamily,color:Colors.white),
                    maxLines:10
                
                );
  }
}

LangString fillerString = LangString(
    
    english: 'filler',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'filler',
);

LangString hauntedHouseString = LangString(
    
    english: 'haunted house',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'haunted house',
);

LangString flowerGardenString = LangString(
    
    english: 'flower garden',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'flower garden',
);

LangString jurassicJungleString = LangString(
    
    english: 'jurassic jungle',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'jurassic jungle',
);

LangString languagesString = LangString(
    
    english: 'languages',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'languages',
);

LangString deepSeaString = LangString(
    
    english: 'deep sea',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'deep sea',
);

LangString cafeString = LangString(
    
    english: 'apheria cafe',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'apheria cafe',
);

LangString apheriaQueensString = LangString(
    
    english: 'queens',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'女王',
);

LangString sushiString = LangString(
    
    english: 'sushi',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'寿司',
);

LangString coffeeString = LangString(
    
    english: 'coffee',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'コーヒー',
);

LangString bakeryString = LangString(
    
    english: 'bakery',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'ベーカリー',
);

LangString noodlesString = LangString(
    
    english: 'noodles',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'麺',
);

LangString sweetString = LangString(
    
    english: 'sweet treats',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'お菓子',
);

LangString decorString = LangString(
    
    english: 'cafe',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'カフェ',
);

LangString fishString = LangString(
    
    english: 'fish',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'魚',
);

LangString oceanFloorString = LangString(
    
    english: 'ocean floor',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'海底',
);

LangString seaCreaturesString = LangString(
    
    english: 'sea creatures',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'海洋生物',
);

LangString boatsString = LangString(
    
    english: 'boats',
    danish:'filler',
    swedish:'filler',
    norweigan:'filler',
    icelandic:'filler',
    korean:'filler',
    japanese:'ボート',
);




    
                          LangString apheriaPensButtonString = LangString(
    
    english: 'shop apheria pens!',
    danish:'',
    swedish:'',
    norweigan:'',
    icelandic:'',
    korean:'',
    japanese:'ペンを買う', //'buy a pen'
     );

     LangString shopNowString = LangString(
    
    english: 'shop now!',
    danish:'',
    swedish:'',
    norweigan:'',
    icelandic:'',
    korean:'',
    japanese:'今すぐ買い物',// 'shop now'
     );

     LangString apheriaCollabs = LangString(
    
    english: 'collabs',
    danish:'',
    swedish:'',
    norweigan:'',
    icelandic:'',
    korean:'',
    japanese:'コラボ',// ''
     );

     LangString apheriaTutorial = LangString(
    
    english: 'tutorial',
    danish:'',
    swedish:'',
    norweigan:'',
    icelandic:'',
    korean:'',
    japanese:'チュートリアル',// ''
     );

     LangString apheriaFiles = LangString(
    
    english: 'files',
    danish:'',
    swedish:'',
    norweigan:'',
    icelandic:'',
    korean:'',
    japanese:'ファイル',// ''
     );

     LangString apheriaProducts = LangString(
    
    english: 'products',
    danish:'',
    swedish:'',
    norweigan:'',
    icelandic:'',
    korean:'',
    japanese:'製品',// 
     );

     LangString apheriaCreation = LangString(
    
    english: 'creation',
    danish:'',
    swedish:'',
    norweigan:'',
    icelandic:'',
    korean:'',
    japanese:'創造',// 
     );

     LangString apheriaSponsor = LangString(
    
    english: 'sponsor',
    danish:'',
    swedish:'',
    norweigan:'',
    icelandic:'',
    korean:'',
    japanese:'スポンサー',// 
     );  

 LangString fotd = LangString(
    
    english: 'file of the day',
    danish:'dagens fil',
    swedish:'dagens fil',
    norweigan:'dagens fil',
    icelandic:'skrá dagsins',
    korean:'오늘의 파일',
    japanese:'今日のファイル',
);

LangString apheriaKanji = LangString(
    
    english: 'kanji',
    danish:'kanji',
    swedish:'kanji',
    norweigan:'kanji',
    icelandic:'kanji',
    korean:'kanji',
    japanese:'漢字',
);

LangString apheriaHiragana = LangString(
    
    english: 'hiragana',
    danish:'hiragana',
    swedish:'hiragana',
    norweigan:'hiragana',
    icelandic:'hiragana',
    korean:'hiragana',
    japanese:'ひらがな',
);

LangString apheriaKatakana = LangString(
    
    english: 'katakana',
    danish:'katakana',
    swedish:'katakana',
    norweigan:'katakana',
    icelandic:'katakana',
    korean:'katakana',
    japanese:'カタカナ',
);

LangString apheriaHangeul = LangString(
    
    english: 'hangeul',
    danish:'hangeul',
    swedish:'hangeul',
    norweigan:'hangeul',
    icelandic:'hangeul',
    korean:'hangeul',
    japanese:'ハングル',
);

//////these need translating:

LangString langagesString=LangString(
                   english: 'languages',
    danish:'languages',
    swedish:'languages',
    norweigan:'languages',
    icelandic:'languages',
    korean:'languages',
    japanese:'languages',
                );

LangString hey = LangString(
    
    english: 'hey!',
    danish:'hej!',
    swedish:'hej!',
    norweigan:'hei!',
    icelandic:'hæ',
    korean:'안녕!',
    japanese:'こんにちは！',
);

LangString galentinesString = LangString(
    
    english: 'galentines <3',
    danish:'galentines <3',
    swedish:'galentines <3',
    norweigan:'galentines <3',
    icelandic:'galentines <3',
    korean:'galentines <3',
    japanese:'galentines <3',
);

LangString notificationMessage = LangString(
    
     english: 'apheria notifications are working :)',
    danish:'meddelelser virker :)',
    swedish:'aviseringar fungerar :)',
    norweigan:'varsler fungerer :)',
    icelandic:'tilkynningar virka :)',
    korean:'알림이 작동 중입니다 :)',
    japanese:'通知は機能しています :)',
);

LangString loadingAd = LangString(
    
     english: 'loading ad...',
    danish:'indlæser annonce...',
    swedish:'laddar annons...',
    norweigan:'laster inn annonse...',
    icelandic:'hleður auglýsingu...',
    korean:'광고 로드 중...',
    japanese:'広告を読み込んでいます...',
);

LangString tarotString = LangString(
    
    english: 'tarot',
    danish:'apheria tarot',
    swedish:'apheria tarot',
    norweigan:'apheria tarot',
    icelandic:'apheria tarot',
    korean:'apheria tarot',
    japanese:'タロット',
);

LangString ecoSceneString = LangString(
    
    english: 'environmentally friendly',
    danish:'environmentally friendly files',
    swedish:'environmentally friendly files',
    norweigan:'environmentally friendly files',
    icelandic:'environmentally friendly files',
    korean:'environmentally friendly files',
    japanese:'環境に優しい',
);

LangString apheriaHQString = LangString(
    
    english: 'logos',
    danish:'apheria logo files',
    swedish:'apheria logo files',
    norweigan:'apheria logo files',
    icelandic:'apheria logo files',
    korean:'apheria logo files',
    japanese:'ロゴ',
);


LangString apheriaUsesAds = LangString(
    
     english: 'apheria uses ads to make it free to use. thank you for your patience ',
    danish:'apheria bruger annoncer til at gøre det gratis at bruge. tak for din tålmodighed',
    swedish:'apheria använder annonser för att göra det gratis att använda. tack för ditt tålamod',
    norweigan:'apheria bruker annonser for å gjøre det gratis å bruke. takk for din tålmodighet',
    icelandic:'apheria notar auglýsingar til að gera það ókeypis í notkun. þakka þér fyrir þolinmæðina',
    korean:'apheria는 무료로 사용할 수 있도록 광고를 사용합니다. 기다려주셔서 감사합니다',
    japanese:'apheria は無料で使用できるように広告を使用しています. いただいてありがとうございます',
);


LangString skip = LangString(
    
     english: 'skip',
    danish:'springe',
    swedish:'hoppa',
    norweigan:'hoppe',
    icelandic:'sleppa',
    korean:'건너뛰다',
    japanese:'スキップ',
);

LangString finish = LangString(
    
     english: 'finish',
    danish:'afslut',
    swedish:'avsluta',
    norweigan:'slutte',
    icelandic:'klára',
    korean:'마치다',
    japanese:'仕上げる'
);

LangString home = LangString(
    
     english: 'home',
    danish:'hejm',
    swedish:'hem',
    norweigan:'hjem',
    icelandic:'heim',
    korean:'집',
    japanese:'家'
);

LangString chooseColour = LangString(
    
     english: 'choose a colour',
    danish:'vælge en farve',
    swedish:'välj en färg',
    norweigan:'velg en farge',
    icelandic:'veldu lit',
    korean:'색상을 선택하세요',
    japanese:'色を選ぶ',
);

LangString save = LangString(
    
     english: 'save',
    danish:'gemme',
    swedish:'spara',
    norweigan:'lagre',
    icelandic:'vista',
    korean:'저장',
    japanese:'保存',
);

////////////////////////////////////////////scene texts:

LangString brittfaveString = LangString(
    
    english: "britt's favourites",
    danish:'britts favoritter',
    swedish:'britts favoriter',
    norweigan:'britts favoritter',
    icelandic:'uppáhalds Britt',
    korean:'Britt가 좋아하는 것',
    japanese:'Brittのお気に入り',
);

LangString inkboxString = LangString(
    
    english: "inkbox favourites",
    danish:'inkbox favoritter',
    swedish:'inkbox favoriter',
    norweigan:'inkbox favoritter',
    icelandic:'uppáhalds inkbox',
    korean:'inkbox가 좋아하는 것',
    japanese:'のお気に入り', // just favourites
);

LangString observatoryCeilingString = LangString(
    
    english: "observatory ceiling",
    danish:'observatoriets loft',
    swedish:'observatoriets tak',
    norweigan:'observatoriums tak',
    icelandic:'stjörnustöð loft',
    korean:'전망대 천장',
    japanese:'展望台の天井',
);

LangString angelWingsString = LangString(
    
    english: "angel wings",
    danish:'englevinger',
    swedish:'änglavingar',
    norweigan:'englevinger',
    icelandic:'englavængir',
    korean:'천사 날개',
    japanese:'天使の翼',
);


LangString apheriagirlsString = LangString(
    
    english: 'girls',
    danish:'apheria piger',
    swedish:'apheria flickor',
    norweigan:'apheria jenter',
    icelandic:'apheria stelpur',
    korean:'apheria 여자애들',
    japanese:'女の子',
);

LangString simplefilesString = LangString(
    
    english: 'simple files',
    danish:'simple filer',
    swedish:'enkla filer',
    norweigan:'enkle filer',
    icelandic:'einfaldar skrár',
    korean:'단순 파일',
    japanese:'単純なファイル',
);

LangString facesString = LangString(
    
    english: 'faces',
    danish:'ansigter',
    swedish:'ansikten',
    norweigan:'ansikter',
    icelandic:'andlit',
    korean:'얼굴들',
    japanese:'顔',
);

LangString squigglesString = LangString(
    
    english: 'squiggles',
    danish:'krøller',
    swedish:'snirklar',
    norweigan:'krøller',
    icelandic:'svífur',
    korean:'구불 구불 한 선',
    japanese:'波線',
);

LangString starsString = LangString(
    
    english: 'stars',
    danish:'stjerner',
    swedish:'stjärnor',
    norweigan:'stjerner',
    icelandic:'stjörnur',
    korean:'별',
    japanese:'スター',
);

LangString alienString = LangString(
    
    english: 'aliens',
    danish:'udlændinge',
    swedish:'utomjordingar',
    norweigan:'romvesener',
    icelandic:'geimverur',
    korean:'외계인',
    japanese:'宇宙人',
);

LangString moonlightString = LangString(
    
    english: 'moonlight',
    danish:'måneskin',
    swedish:'månsken',
    norweigan:'måneskinn',
    icelandic:'tunglsljós',
    korean:'달빛',
    japanese:'月光',
);

LangString planetsString = LangString(
    
    english: 'planets',
    danish:'planeter',
    swedish:'planeter',
    norweigan:'planeter',
    icelandic:'plánetur',
    korean:'행성',
    japanese:'惑星',
);

LangString galaxiesString = LangString(
    
    english: 'galaxies',
    danish:'galakser',
    swedish:'galaxer',
    norweigan:'galakser',
    icelandic:'vetrarbrautir',
    korean:'은하계',
    japanese:'銀河',
);

LangString stargazingString = LangString(
    
    english: 'stargazing',
    danish:'stjernekiggeri',
    swedish:'stjärnskådning',
    norweigan:'Stjernekikking',
    icelandic:'stjörnuskoðun',
    korean:'별을 관찰하다',
    japanese:'星空観察',
);

LangString constellationsString = LangString(
    
    english: 'constellations',
    danish:'konstellationer',
    swedish:'konstellationer',
    norweigan:'konstellasjoner',
    icelandic:'stjörnumerki',
    korean:'별자리',
    japanese:'星座',
);

LangString sunshineString = LangString(
    
    english: 'sunlight',
    danish:'solskin',
    swedish:'solljus',
    norweigan:'sollys',
    icelandic:'sólarljós',
    korean:'햇빛',
    japanese:'日光',
);

LangString blackholesString = LangString(
    
    english: 'black holes',
    danish:'sorte huller',
    swedish:'svarta hål',
    norweigan:'svarte hull',
    icelandic:'svarthol',
    korean:'블랙홀',
    japanese:'ブラックホール',
);

LangString bikerchickString = LangString(
    
    english: 'biker chick',
    danish:'biker chick',
    swedish:'biker brud',
    norweigan:'biker dama',
    icelandic:'mótorhjólaskvísa',
    korean:'바이커 병아리',
    japanese:'バイカーひよこ',
);

LangString bonesString = LangString(
    
    english: 'bones',
    danish:'knogler',
    swedish:'ben',
    norweigan:'bein',
    icelandic:'bein',
    korean:'뼈',
    japanese:'骨',
);

LangString skullsString = LangString(
    
    english: 'skulls',
    danish:'kranier',
    swedish:'skallar',
    norweigan:'hodeskaller',
    icelandic:'hauskúpur',
    korean:'두개골',
    japanese:'頭蓋骨',
);

LangString witchesString = LangString(
    
    english: 'witches',
    danish:'hekse',
    swedish:'häxor',
    norweigan:'hekser',
    icelandic:'nornir',
    korean:'마녀',
    japanese:'魔女',
);

LangString ghostsString = LangString(
    
    english: 'ghosts',
    danish:'spøgelser',
    swedish:'spöke',
    norweigan:'spøkelse',
    icelandic:'draugur',
    korean:'유령',
    japanese:'幽霊',
);

LangString cloudsString = LangString(
    
    english: 'clouds',
    danish:'skyer',
    swedish:'moln',
    norweigan:'skyer',
    icelandic:'skýjum',
    korean:'구름',
    japanese:'雲',
);

LangString butterfliesString = LangString(
    
    english: 'butterflies',
    danish:'sommerfugle',
    swedish:'fjärilar',
    norweigan:'sommerfugler',
    icelandic:'fiðrildi',
    korean:'나비',
    japanese:'蝶',
);

LangString teaString = LangString(
    
    english: 'tea',
    danish:'te',
    swedish:'te',
    norweigan:'te',
    icelandic:'te',
    korean:'차',
    japanese:'お茶',
);

LangString heartsString = LangString(
    
    english: 'hearts',
    danish:'hjerter',
    swedish:'hjärtan',
    norweigan:'hjerter',
    icelandic:'hjörtu',
    korean:'하트',
    japanese:'心',
);

LangString rainbowsString = LangString(
    
    english: 'rainbows',
    danish:'regnbuer',
    swedish:'regnbågar',
    norweigan:'regnbuer',
    icelandic:'regnboga',
    korean:'무지개',
    japanese:'虹',
);

LangString snacksString = LangString(
    
    english: 'snacks',
    danish:'snacks',
    swedish:'snacks',
    norweigan:'snacks',
    icelandic:'snakk',
    korean:'간식',
    japanese:'おやつ',
);

LangString dinosaursString = LangString(
    
    english: 'dinosaurs',
    danish:'dinosaurer',
    swedish:'dinosaurier',
    norweigan:'dinosaurer',
    icelandic:'risaeðlur',
    korean:'공룡',
    japanese:'恐竜',
);

LangString templeString = LangString(
    
    english: 'temple',
    danish:'tempel',
    swedish:'tempel',
    norweigan:'tinning',
    icelandic:'musteri',
    korean:'신전',
    japanese:'寺',
);

LangString oceanwavesString = LangString(
    
    english: 'ocean waves',
    danish:'havets bølger',
    swedish:'havsvågor',
    norweigan:'havbølger',
    icelandic:'sjávaröldur',
    korean:'파도',
    japanese:'海の波',
);

LangString blossomString = LangString(
    
    english: 'blossom',
    danish:'blomst',
    swedish:'blomma',
    norweigan:'blomstre',
    icelandic:'blómstra',
    korean:'벚꽃',
    japanese:'桜の花',
);

LangString foliageString = LangString(
    
    english: 'foliage',
    danish:'løv',
    swedish:'lövverk',
    norweigan:'løvverk',
    icelandic:'blað ',
    korean:'잎전부',
    japanese:'枝葉',
);

LangString flowersString = LangString(
    
    english: 'flowers',
    danish:'blomster',
    swedish:'blommor',
    norweigan:'blomster',
    icelandic:'blóm',
    korean:'꽃들',
    japanese:'花',
);

LangString leavesString = LangString(
    
    english: 'leaves',
    danish:'blade',
    swedish:'löv',
    norweigan:'blader',
    icelandic:'blöð',
    korean:'나뭇잎',
    japanese:'葉',
);

LangString plantsString = LangString(
    
    english: 'plants',
    danish:'planter',
    swedish:'växter',
    norweigan:'planter',
    icelandic:'plöntur',
    korean:'식물',
    japanese:'植物',
);
