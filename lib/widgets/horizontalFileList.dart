//flutter

import 'dart:async';

import 'package:apheria/constants.dart';
import 'package:apheria/homePages/filesHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//packages

//firebase

//other

//project

//data
import 'package:apheria/data/langText.dart';

//home pages

//services

//widgets
import 'package:apheria/widgets/filecardui.dart';

//other

Widget FileList(
    List<String> list, Function callback, bool bought, String location) {
  return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: list.length,
      itemBuilder: (_, index) {
        return FileCardUI(index, list[index], callback, callback, location);
      });
}

class HorizontalFileList extends StatefulWidget {
  HorizontalFileList(this.list, this.name, this.color, this.callback,
      this.bigCallback, this.location);
  List<String> list;
  String name;
  Color color;
  Function callback;
  Function bigCallback;
  String location;

  @override
  State<HorizontalFileList> createState() => _HorizontalFileListState(this.list,
      this.name, this.color, this.callback, this.bigCallback, this.location);
}

class _HorizontalFileListState extends State<HorizontalFileList> {
  _HorizontalFileListState(this.list, this.name, this.color, this.callback,
      this.bigCallback, this.location);
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wait();
    //bigCallback = getFileCount()
  }

  @override
  int count = 0;
  bool loading = true;
  Function callback;
  Function bigCallback;
  String location;

  wait() async {
    await getFiles();
    //Future.delayed(Duration(seconds:5));
    getFileCount();
  }

  getFileCount() async {
    count = 0;
    userFiles.forEach((element) {
      if (list.contains(element)) {
        count = count + 1;
      }
    });
    setState(() {
      loading = false;
    });
  }

  List<String> list;
  String name;
  Color color;

  Widget build(BuildContext context) {
    //getFileCount();

    return loading == true
        ? Container()
        : Container(
            //elevation:3,
            //shape:curvedcard,
            //color:color.withOpacity(0.5),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                              child: Text(name,
                                  style: TextStyle(color: apheriapink)),
                            )),
                        StatefulBuilder(builder: (context, setState) {
                          timer = Timer.periodic(Duration(seconds: 1),
                              (Timer t) => getFileCount());

                          return Card(
                              color: apheriabluetwo,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child:
                                    Text('${count.toString()}/${list.length}'),
                              ));
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          itemBuilder: (_, index) {
                            return loading == true
                                ? Container()
                                : SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: FileCardUI(index, list[index],
                                        callback, bigCallback, location));
                          })),
                ])));
  }
}
