


 import 'package:apheria/constants.dart';
import 'package:apheria/services/analytics.dart';
import 'package:flutter/material.dart';

Widget toolWidget(Color bgcolor, Color iconcolor, String title,
      String subtitle, IconData icon, Function function) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
      child: GestureDetector(
        onTap: () {
          logEvent('toolbox_action', {'action': title});
          function();
        },
        child: Card(
          elevation: 5,
          shape: curvedcard,
          color: bgcolor == Colors.white ? apheriaamber : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
                shape: curvedcard,
                color: bgcolor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // Evenly distributes space

                    children: [
                      Icon(icon, size: 40, color: iconcolor),
                      Text(title,
                          style:
                              TextStyle(color: darkapheriapink, fontSize: 25),
                          textAlign: TextAlign.center)
                    ],
                  ),
                )

                /* ListTile(
                  onTap: () {
                    logEvent('toolbox_action', {'action': title});
                    function();
                  },
                  title: Text(title, style: TextStyle(color: apheriapink)),
                  subtitle: Text(subtitle, style: TextStyle(color: darkapheriapink)),
                  leading: Icon(icon, color: apheriabluetwo),
                  trailing: Icon(Icons.touch_app, color: apheriapink),
                )*/
                ),
          ),
        ),
      ),
    );
  }

  
