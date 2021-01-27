import 'package:flutter/material.dart';
import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';
import 'package:matowork/components/repeat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:matowork/components/vertical_split.dart';
import '../../components/db.dart';
import 'package:image/image.dart' as img;

//[hin, hin+hin+Devanagari, hin+hin+Devanagari+hin+Devanagari+eng]
class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List<Asset> images = [];
  String _error;
  String str = "";
  List<Asset> resultList;

  Future<img.Image> _pickcamera() async {
    final _picker = ImagePicker();
    var _pickedfile = await _picker.getImage(source: ImageSource.camera);
    LostData res = await _picker.getLostData();
    if (!res.isEmpty) {
      _pickedfile = res.file;
    }
    img.Image image = img.decodeImage(await _pickedfile.readAsBytes());
    // var temp = img.encodeJpg(image, quality: 80);
    // image = img.decodeImage(temp);
    return image;
  }

  Widget buildGridView() {
    if (images != null)
      return Container(
        //decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black,width: 2.0,style: BorderStyle.solid,))),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(images.length, (index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: AssetThumb(
                asset: images[index],
                width: 400,
                height: 400,
              ),
            );
          }),
        ),
      );
    else
      return Container(
        child: Text(
          "No images Selected",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      );
  }

  Future<void> loadAssets() async {
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(maxImages: 25);
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      //images.addAll(resultList);
      Db.imageList.addAll(resultList);
      if (error == null) _error = "No error detected";
    });

    Db.languages.forEach((key, value) {
      if (value == true) {
        Db.languages[key] = false;
      }
    });
  }

  void checkBoxLanguages() {
    Db.languages.forEach((key, value) {
      if (value == true) {
        //print(str);
        str = str + "+" + Db.lang[key];
      }
    });
    if (str == "") return;
    List l = str.split("+");
    l.remove("");
    str = l.join("+");
    for (int i = 0; i < resultList.length; i++) Db.config.add(str);
    //print("From function");
    // print(Db.config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pages left: ${Db.pageLeft}",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return WelcomeScreen();
                    }), ModalRoute.withName(''));
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ))
            ],
          ),
          leadingWidth: MediaQuery.of(context).size.width / 2,
          backgroundColor: Color(0xFF6F35A5),
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.center,
                height: 35,
                color: Colors.deepPurple,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Total Pages Selected: ${Db.imageList.length}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                )),
            Expanded(
              child: VerticalSplitView(
                left: new Scaffold(
                  bottomNavigationBar: BottomAppBar(
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            color: Colors.black54,
                            icon: Icon(Icons.add_a_photo),
                            onPressed: () async {
                              checkBoxLanguages();
                              str = "";
                              await loadAssets();
                            }),
                        IconButton(
                            color: Colors.black54,
                            icon: Icon(Icons.add_photo_alternate),
                            onPressed: () async {
                              checkBoxLanguages();
                              str = "";
                              await loadAssets();
                            })
                      ],
                    ),
                  ),
                  body: Container(
                    height: MediaQuery.of(context).size.height - 200,
//                         decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black,width: 2.0,style: BorderStyle.solid,))),
                    child: Column(
                      children: [
                        Text(
                          "Images ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              wordSpacing: 0.2,
                              letterSpacing: .5),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                                style: BorderStyle.solid,
                              ))),
                              child: buildGridView()),
                        ),
                      ],
                    ),
                  ),
                ),
                right: new Scaffold(
                  bottomNavigationBar: BottomAppBar(
                    color: Colors.grey[300],
                    child: FlatButton(
                      child: Text("Convert",
                          style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
                      onPressed: Db.imageList.length !=0 ?() {
                        str = "";
                        checkBoxLanguages();
                        Db.config = Repeat.removeDublicate(Db.config);
                        print(Db.config);
                      } : null,
                    ),
                  ),
                  body: Container(
                    child: Column(
                      children: [
                        Text(
                          "Choose Languages: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              wordSpacing: 0.2,
                              letterSpacing: .5),
                        ),
                        Expanded(
                          child: ListView(
                            children: Db.languages.keys.map((String key) {
                              return new CheckboxListTile(
                                  title: new Text(
                                    key,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  value: Db.languages[key],
                                  onChanged: Db.imageList.length !=0 ? (bool value) {
                                    setState(() {
                                      Db.languages[key] = value;
                                      //checkBoxLanguages();
                                    });
                                  } : null);
                            }).toList(),
                          ),
                        ),
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
