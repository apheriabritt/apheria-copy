import 'package:apheria/constants.dart';
import 'package:apheria/homePages/adProducts.dart';
import 'package:apheria/homePages/creationCard.dart';
import 'package:apheria/homePages/filesHomePage.dart';
import 'package:apheria/homePages/violetCreationBuilder.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:flutter/material.dart';



class Creation {
  String title, subtitle, image;
  List<String> materials = [];
  List<String> tools = [];
  List<String> method = [];
  List<String> files = [];
  List<creationAd> ads = [];

  Creation(this.title, this.subtitle, this.image, this.materials, this.tools,
      this.method, this.files,this.ads);
}

class NewAddPage extends StatefulWidget {
  const NewAddPage({super.key});

  @override
  State<NewAddPage> createState() => _NewAddPageState();
}

class _NewAddPageState extends State<NewAddPage> {
  callback() {
    setState(() {});
  }

  List<Creation> creationList = [
    Creation('sun and moon finger tattoos', 'with inkbox',
        'images/cardImages/inkboxImages/sparkle.jpeg', [
      'just your thumbs!'
    ], [
      'inkbox freehand marker or eyeliner'
    ], [
      'using the files provided, draw the files onto your thumbs. you can use the apheria lens drawing tool to do this!'
    ], 
    ['ob14','fg83'],
    [inkboxFreehandPen]
    ),
    //Creation('observatory bag', 'with preworn',
    //    'images/cardImages/wardrobe/wardrobeSpaceBag.jpg'),
    //Creation('embroidered sun top', 'with preworn',
    //   'images/cardImages/wardrobe/sunEmbroidery.jpg'),

//Creation('personalised phone case', 'with wave phone case'),
//Creation('nail art designs', 'with ...'),
    // Creation('patchwork jeans', 'with preworn'),
    //Creation('DIY tarot deck', "with crafter's companion"),
    // Creation('personalised popSocket', "with amazon"),
    // Creation("violet's lavender latte", "with ..."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriapink,
        //appBar:
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back,
                            color: Colors.white, size: 30)),
                    Text('welcome!', style: TextStyle(fontSize: 33)),
                    starPointCounter('new add page'),
                  ],
                ),
                SizedBox(height: 6),
                Card(
                    elevation: 5,
                    color: darkapheriapink,
                    shape: curvedcard,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                          onTap: () {
                            goTo(FilesListHome(callback), context);
                          },
                          leading: Image.asset('images/icon/colourplanet.png'),
                          trailing:
                              Icon(Icons.arrow_forward, color: apheriaamber),
                          title: Text(
                            'apheria freestyle',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    )),
                SizedBox(height: 6),
                Card(
                    elevation: 5,
                    color: apherialilac,
                    shape: curvedcard,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                          leading: Image.asset('images/icon/violet.png'),
                          trailing:
                              Icon(Icons.arrow_forward, color: apheriaamber),
                          onTap: () {
                            goTo(Violetcreationbuilder(), context);
                          },
                          title: Text(
                            "violet's creation builder",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    )),
                Divider(
                  color: Colors.white,
                  thickness: 3,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: creationList.length, // Number of cards to build
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          goTo(CreationCard(creationList[index]), context);
                        },
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                  height: 100,
                                  width: 100,
                                  color: apheriapink,
                                  child: Image.asset(
                                    creationList[index].image,
                                    fit: BoxFit.cover,
                                  )),
                              SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /* Card(
                                        color:apheriablue,
                                        child:Row(
                                         children: [
                                           Text(' 100'),
                                           Icon(Icons.star,color:Colors.amber)
                                         ],
                                       )),*/

                                  Text(creationList[index].title,
                                      style: TextStyle(color: apheriabluetwo)),
                                  Text(
                                    creationList[index].subtitle,
                                    style: TextStyle(
                                        color: darkapheriapink,
                                        fontStyle: FontStyle.italic),
                                  ),
                                 /* Text(
                                    'coming soon...',
                                    style: TextStyle(
                                        color: apheriapurpletwo,
                                        fontStyle: FontStyle.italic),
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        )),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
