import 'package:apheria/constants.dart';
import 'package:apheria/data/scenesData.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/services/googleWallet.dart';
import 'package:apheria/widgets/horizontalFileList.dart';
import 'package:apheria/widgets/filecardui.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:url_launcher/url_launcher.dart';

Widget sceneText(String text, Color color) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: curvycard,
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
            shape: curvycard,
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            )),
      ),
    ),
  );
}

Widget curvedCardImage(String image) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
        elevation: 2,
        shape: curvedcard,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(image))),
  );
}

class ObservatoryScene extends StatefulWidget {
  const ObservatoryScene({super.key});

  @override
  State<ObservatoryScene> createState() => _ObservatorySceneState();
}

class _ObservatorySceneState extends State<ObservatoryScene> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  curvedCardImage('images/world/observatory.jpg'),
                  Text('inside')
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  curvedCardImage('images/world/observatoryOutside.jpg'),
                  Text('outside')
                ],
              ),
            ),
          ],
        ),
        Divider(color: Colors.white),
        SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text('the observatory girl:'),
          FileCardUI(0, 'ob57', () {}, () {}, 'observatory')
        ]),
        //HorizontalFileList(stars, 'other files in the pictures',Colors.transparent, () {}, (){}),

        SizedBox(height: 12),
        Divider(color: Colors.white),
        sceneText('the observatory ceiling', apheriapurple),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
              'an apheria project I started in 2019 on my bedroom ceiling, using all 100 observatory files'),
        ),
        curvedCardImage('images/world/obCeilingMain.jpg'),
        Row(
          children: [
            Expanded(child: curvedCardImage('images/world/obc1.png')),
            Expanded(child: curvedCardImage('images/world/obc2.png')),
            Expanded(child: curvedCardImage('images/world/obc3.png')),
            //Expanded(child: curvedCardImage('images/cardImages/obc4.jpg')),
          ],
        ),

        // sceneText('observatory creations:'),
        Row(
          children: [
            // curvedCardImage('images/cardImages/wardrobe/sunEmbroidery.jpg'),
            // curvedCardImage('images/cardImages/wardrobe/wardrobeSpaceBag.jpg'),
            //curvedCardImage('images/cardImages/wardrobe/wardrobeSpaceTee.jpg'),
          ],
        ),
        sceneText('observatory files:', darkapheriapink),
        HorizontalFileList(
            stars, 'stars', Colors.transparent, () {}, () {}, 'observatory'),
        HorizontalFileList(
            blackHoles, 'black holes', Colors.transparent, () {}, () {},'observatory'),
        HorizontalFileList(
            constellations, 'constellations', Colors.transparent, () {}, () {},'observatory'),
        HorizontalFileList(
            stargazing, 'stargazing', Colors.transparent, () {}, () {},'observatory')
      ],
    ));
  }
}

class ApheriaHQ extends StatefulWidget {
  const ApheriaHQ({super.key});

  @override
  State<ApheriaHQ> createState() => _ApheriaHQState();
}

class _ApheriaHQState extends State<ApheriaHQ> {
  int years = 0;
  int months = 0;
  int days = 0;
  int birthdaymonths = 0;
  int remainingDays = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget goddessCard(String title, desc, Color color) {
    return Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(title),
              Text(desc),
            ],
          ),
        ));
  }

  Widget dateCard(int number, String thing, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(number.toString(), style: TextStyle(fontSize: 50)),
            Text(thing)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        curvedCardImage('images/world/brittDesk.jpg'),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                  color: apheriaamber,
                  child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.cake, color: apheriablue)),
                      title: Card(
                        color: darkapheriapink,
                        shape: curvycard,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "apheria's birthday:",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      subtitle: Card(
                        shape: curvycard,
                        color: apheriapink,
                        child: Text(
                          '5th September 2016',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ))),
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text('apheria logos'),
          FileCardUI(0, 'planet', () {}, () {}, 'apheria hq'),
          FileCardUI(0, 'apheriaA', () {}, () {}, 'apheria hq')
        ]),

        // Text('apheria is currently:'),

        /* Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dateCard(years, 'years', darkapheriapink),
            dateCard(months, 'months', darkapheriapink),
            dateCard(days, 'days', darkapheriapink),
          ],
        ),
        Text("days until apheria's birthday:"),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dateCard(birthdaymonths, 'months', apheriapink),
            dateCard(remainingDays, 'days', apheriapink),
          ],
        ),*/
        /*  Text('current number of downloads:'),
           Card(color:apheriaamber,child:Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('100',
             style:TextStyle(fontSize:50
             )),
           )),*/ //could make this led to dail users, link to number of users basically, for me too
        Divider(color: Colors.white),
        sceneText('apheria history', apheriapurple),

        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                curvedCardImage('images/world/apheria2016.png'),
                Text('2016: jewellery')
              ],
            )),
            Expanded(
                child: Column(
              children: [
                curvedCardImage('images/world/apheria2018.png'),
                Text('2018: illustration')
              ],
            ))
          ],
        ),
        sceneText('covid 2020: learning to code apps', darkapheriapink),
        Row(
          children: [
            Expanded(child: curvedCardImage('images/world/covid1.jpg')),
            Expanded(child: curvedCardImage('images/world/covid2.jpg')),
            Expanded(child: curvedCardImage('images/world/covid3.jpg')),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('in January 2020, the first apheria app was born!'),
        ),
        Divider(color: Colors.white),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('where does the name apheria come from?'),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            goddessCard('aphrodite', 'goddess of love', darkapheriapink),
            Text('+'),
            goddessCard('athena', 'goddess of craft and wisdom', apheriablue),
            Text('+'),
            goddessCard('hera', 'goddess of women', apheriapink),
            Text('+'),
            goddessCard('hestia', 'goddess of the home', apheriapurple),
          ],
        ),
      ]),
    );
  }
}

class TarotScene extends StatefulWidget {
  const TarotScene({super.key});

  @override
  State<TarotScene> createState() => _TarotSceneState();
}

class _TarotSceneState extends State<TarotScene> {
  Widget tarotRow(String title, desc, file, color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              children: [
                sceneText(title, color),
                Text(desc, textAlign: TextAlign.center),
              ],
            ),
          ),
          FileCardUI(0, file, () {}, () {}, 'tarot tent'),
          SizedBox(width: 12)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        tarotRow(
            'the queen of cups',
            'follow your intuition despite resistance',
            'queen_cups',
            apheriablue),
        tarotRow(
            'the queen of wands',
            'go after your goals with a vision and inspire others',
            'queen_wands',
            apheriapink),
        tarotRow(
            'the queen of pentacles',
            'self sufficient hard worker nurturing others',
            'queen_pentacles',
            apheriaamber),
        tarotRow(
            'the queen of swords',
            'speak your truth grounded in facts and figures',
            'queen_swords',
            apherialilac),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 3,
            shape: curvedcard,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                color: darkapheriapink,
                shape: curvedcard,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('save tarot to your phone',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text('access the deck from anywhere',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('images/cardImages/tarotTate.png',
                          width: 250),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddToWalletButton(
                          'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImZhMjJhM2QwMWNiYmI5NzFjMjk2NmIyODlmMzlmOGNlMzRkMzBmMjgifQ.eyJpc3MiOiJhcGhlcmlhZ29vZ2xld2FsbGV0QGRvb2RsaW5nZGVjYXRobGV0ZS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImF1ZCI6Imdvb2dsZSIsInR5cCI6InNhdmV0b3dhbGxldCIsImlhdCI6MTcwODk1MzUyNCwib3JpZ2lucyI6WyJ3d3cuZXhhbXBsZS5jb20iXSwicGF5bG9hZCI6eyJnZW5lcmljT2JqZWN0cyI6W3siaWQiOiIzMzg4MDAwMDAwMDIyMTMwODIyLnF1ZWVub2ZjdXBzdjAuMS4zIiwiY2xhc3NJZCI6IjMzODgwMDAwMDAwMjIxMzA4MjIuYXBoZXJpYV90YXJvdF9jYXJkIiwiZ3JvdXBpbmdJbmZvIjp7Imdyb3VwaW5nSWQiOiJhcGhlcmlhVGFyb3REZWNrIiwic29ydEluZGV4IjoxfSwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9pLnBvc3RpbWcuY2MvWjVRTXh4M1AvYmxhY2stdGFyb3QtbG9nby5wbmcifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJhcGhlcmlhIGxvZ28ifX19LCJjYXJkVGl0bGUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6ImFwaGVyaWEgdGFyb3QifX0sInN1YmhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiZm9sbG93IHlvdXIgaW50dWl0aW9uIGRlc3BpdGUgcmVzaXN0YW5jZSJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJ0aGUgcXVlZW4gb2YgY3VwcyJ9fSwidGV4dE1vZHVsZXNEYXRhIjpbeyJpZCI6InF1YWxpdGllcyIsImhlYWRlciI6InF1YWxpdGllcyIsImJvZHkiOiJpbnR1aXRvbiJ9LHsiaWQiOiJmbG93aW5nIiwiaGVhZGVyIjoiIiwiYm9keSI6ImZsb3dpbmcifSx7ImlkIjoiY2FyaW5nIiwiaGVhZGVyIjoiIiwiYm9keSI6ImNhcmluZyJ9XSwiaGV4QmFja2dyb3VuZENvbG9yIjoiIzQ2OWJmNCIsImhlcm9JbWFnZSI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9pLnBvc3RpbWcuY2MveVlSR3lic1YvcXVlZW4tb2YtY3Vwcy13aGl0ZS1iZy5wbmcifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJhcGhlcmlhIHRhcm90IGNhcmRzIn19fX0seyJpZCI6IjMzODgwMDAwMDAwMjIxMzA4MjIucXVlZW5vZnBlbnRhY2xlc3YwLjEuMSIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMTMwODIyLmFwaGVyaWFfdGFyb3RfY2FyZCIsImdyb3VwaW5nSW5mbyI6eyJncm91cGluZ0lkIjoiYXBoZXJpYVRhcm90RGVjayIsInNvcnRJbmRleCI6MX0sImxvZ28iOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vaS5wb3N0aW1nLmNjL1o1UU14eDNQL2JsYWNrLXRhcm90LWxvZ28ucG5nIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiYXBoZXJpYSBsb2dvIn19fSwiY2FyZFRpdGxlIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJhcGhlcmlhIHRhcm90In19LCJzdWJoZWFkZXIiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6InNlbGYgc3VmZmljaWVudCBoYXJkIHdvcmtlciBwcm92aWRpbmcgZmluYW5jZXMgYW5kIG51dHVyZSB0byBvdGhlcnMifX0sImhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoidGhlIHF1ZWVuIG9mIHBlbnRhY2xlcyJ9fSwidGV4dE1vZHVsZXNEYXRhIjpbeyJpZCI6InF1YWxpdGllcyIsImhlYWRlciI6InF1YWxpdGllcyIsImJvZHkiOiJwcm92aWRlciJ9LHsiaWQiOiJmbG93aW5nIiwiaGVhZGVyIjoiIiwiYm9keSI6IndlYWx0aCJ9LHsiaWQiOiJjYXJpbmciLCJoZWFkZXIiOiIiLCJib2R5IjoicHJhY3RpY2FsIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjZmZjNzAwIiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2kucG9zdGltZy5jYy9iZGZTME1nRC9xdWVlbi1vZi1wZW50YWNsZXMtd2hpdGUtYmcucG5nIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiYXBoZXJpYSB0YXJvdCBjYXJkcyJ9fX19LHsiaWQiOiIzMzg4MDAwMDAwMDIyMTMwODIyLnF1ZWVub2Zzd29yZHN2LjAuMS4wIiwiY2xhc3NJZCI6IjMzODgwMDAwMDAwMjIxMzA4MjIuYXBoZXJpYV90YXJvdF9jYXJkIiwiZ3JvdXBpbmdJbmZvIjp7Imdyb3VwaW5nSWQiOiJhcGhlcmlhVGFyb3REZWNrIiwic29ydEluZGV4IjoxfSwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9pLnBvc3RpbWcuY2MvWjVRTXh4M1AvYmxhY2stdGFyb3QtbG9nby5wbmcifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJhcGhlcmlhIGxvZ28ifX19LCJjYXJkVGl0bGUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6ImFwaGVyaWEgdGFyb3QifX0sInN1YmhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoic3BlYWsgeW91ciB0cnV0aCBncm91bmRlZCBpbiBmYWN0cyBhbmQgZmlndXJlcyJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJ0aGUgcXVlZW4gb2Ygc3dvcmRzIn19LCJ0ZXh0TW9kdWxlc0RhdGEiOlt7ImlkIjoicXVhbGl0aWVzIiwiaGVhZGVyIjoicXVhbGl0aWVzIiwiYm9keSI6InRydXRoIn0seyJpZCI6ImZsb3dpbmciLCJoZWFkZXIiOiIiLCJib2R5IjoiaW50ZWxsZWN0In0seyJpZCI6ImNhcmluZyIsImhlYWRlciI6IiIsImJvZHkiOiJvdXRzcG9rZW4ifV0sImhleEJhY2tncm91bmRDb2xvciI6IiNiYjllZjUiLCJoZXJvSW1hZ2UiOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vaS5wb3N0aW1nLmNjLzhrajlqQ1lmL3F1ZWVuLW9mLXN3b3Jkcy13aGl0ZS1iZy5wbmcifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJhcGhlcmlhIHRhcm90IGNhcmRzIn19fX0seyJpZCI6IjMzODgwMDAwMDAwMjIxMzA4MjIucXVlZW5vZndhbmRzdjAuMC42IiwiY2xhc3NJZCI6IjMzODgwMDAwMDAwMjIxMzA4MjIuYXBoZXJpYV90YXJvdF9jYXJkIiwiZ3JvdXBpbmdJbmZvIjp7Imdyb3VwaW5nSWQiOiJhcGhlcmlhVGFyb3REZWNrIiwic29ydEluZGV4IjoxfSwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9pLnBvc3RpbWcuY2MvWjVRTXh4M1AvYmxhY2stdGFyb3QtbG9nby5wbmcifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJhcGhlcmlhIGxvZ28ifX19LCJjYXJkVGl0bGUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6ImFwaGVyaWEgdGFyb3QifX0sInN1YmhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiZ28gYWZ0ZXIgeW91ciBnb2FscyB3aXRoIGEgdmlzaW9uIGFuZCBpbnNwaXJlIG90aGVycyB0byBkbyB0aGUgc2FtZSJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJ0aGUgcXVlZW4gb2Ygd2FuZHMifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJxdWFsaXRpZXMiLCJoZWFkZXIiOiJxdWFsaXRpZXMiLCJib2R5IjoicGFzc2lvbmF0ZSJ9LHsiaWQiOiJmbG93aW5nIiwiaGVhZGVyIjoiIiwiYm9keSI6ImRldGVybWluZWQifSx7ImlkIjoiY2FyaW5nIiwiaGVhZGVyIjoiIiwiYm9keSI6Im9wdGltaXN0aWMifV0sImhleEJhY2tncm91bmRDb2xvciI6IiNmZmE0ZTIiLCJoZXJvSW1hZ2UiOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vaS5wb3N0aW1nLmNjLzA1RjNtc2dXL3F1ZWVuLW9mLXdhbmRzLXdoaXRlLWJnLnBuZyJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6ImFwaGVyaWEgdGFyb3QgY2FyZHMifX19fV19fQ.BdpanHGEakkvss3UD-UuxAB2zP5wwnAPidJ67IaylZOS2FHc1p_IIRlOFvPgIsyZMxfOYVpKZQL25pju1bR0_syLR1fe4K9fpr7VcDE5wxTxU_C4i0fC7Rj6HYyo_OB8xYqX11QJOeaLUmEBIJyeU18aeG8zPWKD_pxA-ljKbhaMbkprxvpVUFe-qTdck9Fowywsw-MlKuonWrE0tu6s6JBJ9Goe_NNl9cnJ8ouRBPKa4v-eT1kROBEVmy71pb-UlbYEr7L9y6Dbp7wZ1U-GJr_iUjsGDi4o5CwQbJkjFA93hfizFU-YNJKuJ4GMk7jjHooIs1UmY-kdRLswezw5qQ',
                          'tarot deck'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BoutiqueScene extends StatefulWidget {
  const BoutiqueScene({super.key});

  @override
  State<BoutiqueScene> createState() => _BoutiqueSceneState();
}

class _BoutiqueSceneState extends State<BoutiqueScene> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: curvedCardImage('images/world/boutique.jpg'),
        ),
        sceneText("britt's wardrobe", apherialilac),
        Text('items made with apheria:'),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              curvedCardImage('images/cardImages/wardrobe/angelWings.png'),
              curvedCardImage('images/cardImages/wardrobe/sunEmbroidery.jpg'),
              curvedCardImage(
                  'images/cardImages/wardrobe/wardrobeFrillyShirt.jpg'),
              curvedCardImage('images/cardImages/wardrobe/wardrobePenTee.jpg'),
              curvedCardImage(
                  'images/cardImages/wardrobe/wardrobeSpaceBag.jpg'),
              curvedCardImage(
                  'images/cardImages/wardrobe/wardrobeSpaceTee.jpg'),
              curvedCardImage('images/cardImages/wardrobe/wardrobeTeaTee.jpg')
            ],
          ),
        ),
        Text('files used in the wardrobe:'),
        HorizontalFileList([
          'cl12',
          'ob5',
          'fg99',
          'fg34',
          'cl93',
          'ob37',
          'ob50',
          'ob81',
          'ob33',
          'ob22',
          'ob11',
          'ob30',
          'ob74',
          'ob24',
          'ob95',
          'bg2',
          'cf1'
        ], 'wardrobe files', apheriapink, () {}, () {},'apheria hq'),
        sceneText('fast fashion', darkapheriapink),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '10% of global co2 emissions are produced by the textile industry',
                textAlign: TextAlign.center)),
        sceneText('help tackle the climate crisis:', apheriapurple),
        worldAd(
            'images/cardImages/brands/banners/brokensocietybanner.jpg',
            'https://www.awin1.com/cread.php?s=3635792&v=50895&q=463448&r=1548542',
            apheriapink,
            'broken society'),
        worldAd(
            'images/cardImages/brands/banners/preworn2.jpg',
            'https://preworn.ltd/?ref=apheria',
            apherialilac,
            'preworn')
      ],
    );
  }
}

Widget worldAd(String image, String url, Color color, String brand) {
  return GestureDetector(
    onTap: () {
      launchUrl(Uri.parse(url));
      logEvent('world_action', {'action': 'world_ad_click', 'brand': brand});
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 5,
          shape: curvedcard,
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: curvedCardImage(image),
          )),
    ),
  );
}
