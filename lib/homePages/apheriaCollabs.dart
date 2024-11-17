import 'package:apheria/constants.dart';
import 'package:apheria/widgets/violetCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Collab {
  String title;
  String exp;
  String link;
  Collab(this.title, this.exp, this.link);
}

class ApheriaCollabs extends StatefulWidget {
  const ApheriaCollabs({super.key});

  @override
  State<ApheriaCollabs> createState() => _ApheriaCollabsState();
}

class _ApheriaCollabsState extends State<ApheriaCollabs> {
  List<Collab> collabs = [
    Collab('inkbox','inkbox tattoos with printed apheria designs','https://inkbox.com/artists/apheria'),
    Collab('canva','drag and drop apheria illustrations into your canva designs','https://www.canva.com/p/apheria')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriapink,
        appBar: apheriaAppBar(context, 'apheria collabs'),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color:apheriagreen.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                                   VioletSpeech('view our apheria collabs and earn star points too',
                                   //textAlign: TextAlign.center,),
              false,false),
                        ListView.builder(
                            itemCount: collabs.length,
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape:curvedcard,
                                  color:darkapheriapink,
                                  child:ListTile(
                                    trailing:Icon(Icons.double_arrow_rounded,color:apherialemon),
                                    leading:Text('10★',style:TextStyle(color:apherialemon)),
                                    title:Text(collabs[index].title,style:TextStyle(color:Colors.white)),
                                     subtitle:Text(collabs[index].exp,style:TextStyle(color:apherialavender))
                                    
                                  )
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
