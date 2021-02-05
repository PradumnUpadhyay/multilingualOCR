//import 'package:flutter/material.dart';
//import 'package:matowork/components/db.dart';
//import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';
//import 'package:matowork/components/vertical_split.dart';
//
//class SplitView extends StatefulWidget {
//  @override
//  _SplitViewState createState() => _SplitViewState();
//}
//
//class _SplitViewState extends State<SplitView> {
//  int c=0;
//  String str = "";
//
//  void checkBoxLanguages() {
//    Db.languages.forEach((key, value) {
//      if (value == true) {
//        //print(str);
//        str = str + "+" + Db.lang[key];
//      }
//    });
//    if (str == "") return;
//    List l = str.split("+");
//    l.remove("");
//    str = l.join("+");
//    for (int i = 0; i < Db.imageList.length; i++)
//      Db.config.add(str);
//    Db.languages.forEach((key, value) {
//      if (value == true) {
//        Db.languages[key] = false;
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          automaticallyImplyLeading: false,
//          title: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              Text(
//                "Pages Remaining: ${Db.pageLeft}",
//                style: TextStyle(fontWeight: FontWeight.w400),
//              ),
//              FlatButton(
//                  onPressed: () {
//
//                    Navigator.pushAndRemoveUntil(context,
//                        MaterialPageRoute(builder: (context) {
//                          return WelcomeScreen();
//                        }), ModalRoute.withName(''));
////                      setState(() {
//                    Db.imageList=[];
//                    Db.languages.forEach((key, value) {
//                      if (value == true) {
//                        Db.languages[key] = false;
//                      }
////                        });
//                    });
//
//                  },
//                  child: Text(
//                    "Cancel",
//                    style: TextStyle(
//                        fontWeight: FontWeight.w400,
//                        fontSize: 20,
//                        color: Colors.white),
//                  ))
//            ],
//          ),
//          leadingWidth: MediaQuery
//              .of(context)
//              .size
//              .width / 2,
//          backgroundColor: Color(0xFF6F35A5),
//        ),
//        body: Column(
//          children: [
//            Container(
//                alignment: Alignment.center,
//                height: 35,
//                color: Colors.deepPurple,
//                width: MediaQuery
//                    .of(context)
//                    .size
//                    .width,
//                child: Text(
//                  'Total Pages Selected: ${Db.imageList.length}',
//                  style: TextStyle(
//                      fontSize: 20,
//                      fontWeight: FontWeight.w300,
//                      color: Colors.white),
//                )),
//            Expanded(
//              child: VerticalSplitView(
//                left: new Scaffold(
//                  bottomNavigationBar: BottomAppBar(
//                    color: Colors.grey[300],
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: [
//                        IconButton(
//                            color: Colors.blueAccent[400],
//                            icon: Icon(Icons.add_photo_alternate),
//                            onPressed:( Db.pageLeft > 0 && Db.pageLeft<=25 ) ? () async {
//
//                              setState(() {
//                                checkBoxLanguages();
//                                if(c!=0) {
//                                  print(c);
//                                  checkBoxLanguages();
//                                  Db.displayImages=[];
//                                }
//                              });
//                              str = "";
//                              await loadAssets();
//                              print(c);
//
//                              c=0;
//                              print("Display images ${Db.displayImages.length}");
//                              print("Image list ${Db.imageList.length}");
//                            }: null),
//                        IconButton(
//                            color: Colors.blueAccent[400],
//                            icon: Icon(Icons.add_a_photo),
//                            onPressed: (c>0 || (Db.pageLeft > 0 && Db.pageLeft<=25)) ? () async {
//                              setState(() {
//                                checkBoxLanguages();
//                              });
////                                checkBoxLanguages();
//                              str = "";
//                              Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)));
//                              setState(() {
//                                if(c!=0) {
//                                  Db.displayImages=[];
//                                  checkBoxLanguages();
//                                }
//                                c=0;
//                              });
//
//                            } : null)
//                      ],
//                    ),
//                  ),
//                  body: Container(
//                    height: MediaQuery
//                        .of(context)
//                        .size
//                        .height - 200,
////                         decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black,width: 2.0,style: BorderStyle.solid,))),
//                    child: Column(
//                      children: [
//                        Text(
//                          "Images ",
//                          style: TextStyle(
//                              fontWeight: FontWeight.w500,
//                              color: Colors.black,
//                              fontSize: 16,
//                              fontStyle: FontStyle.italic,
//                              wordSpacing: 0.2,
//                              letterSpacing: .5),
//                        ),
//                        SizedBox(height: 15,),
//                        Expanded(
//                          child: Container(
//                              decoration: BoxDecoration(
//                                  border: Border(
//                                      right: BorderSide(
//                                        color: Colors.black,
//                                        width: 2.0,
//                                        style: BorderStyle.solid,
//                                      ))),
//                              child: buildGridView()),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                right: new Scaffold(
//                  bottomNavigationBar: BottomAppBar(
//                    color: Colors.grey[300],
//                    child: FlatButton(
//                      child: Text("Convert",
//                          style: (Db.imageList.length != 0 && Db.displayImages.length != 0 && c !=0) ? TextStyle(
//                              color: Colors.blue[700],
//                              fontWeight: FontWeight.w700,
//                              fontSize: 17) :
//                          TextStyle(
//                              color: Colors.grey[700],
//                              fontWeight: FontWeight.w700,
//                              fontSize: 17)),
//                      onPressed: (Db.imageList.length != 0 && Db.displayImages.length != 0) ?
//                      _convertButtonFunctionality : Db.convert == true ?
//                      null : _convertButtonFunctionality,
//                    ),
//                  ),
//                  body: Container(
//                    child: Column(
//                      children: [
//                        Text(
//                          "Choose Languages: ",
//                          style: TextStyle(
//                              fontWeight: FontWeight.w500,
//                              color: Colors.black,
//                              fontSize: 16,
//                              fontStyle: FontStyle.italic,
//                              wordSpacing: 0.2,
//                              letterSpacing: .5),
//                        ),
//                        Expanded(
//                          child: ListView(
//                            children: Db.languages.keys.map((String key) {
//                              return new CheckboxListTile(
//                                  title: new Text(
//                                    key,
//                                    style: TextStyle(fontSize: 15),
//                                  ),
//                                  value: Db.languages[key],
//                                  onChanged: Db.imageList.length != 0 ?
//                                      (bool value) {
////                                      print(value);
//
//                                    setState(() {
//                                      Db.languages[key] = value;
//                                      if(value) c++;
//                                      else c--;
//                                      //checkBoxLanguages();
//                                    });
//
//                                  } : null);
//                            }).toList(),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ],
//        )
//    );
//  }
//}
