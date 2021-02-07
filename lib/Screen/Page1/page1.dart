import 'package:flutter/material.dart';
import 'package:matowork/Screen/Page1/camera_screeen.dart';

import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';
import 'package:matowork/components/repeat.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:matowork/components/vertical_split.dart';
import '../../components/db.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:async';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  String str = "";
  int c = 0;
  bool isSelected = false;
//  CameraController _controller;
  List<CameraDescription> _cameras;
  List<String> images = new List<String>();
  CameraDescription firstCamera;
  List filei = [];
  @override
  void initState() {
    getPages();
    super.initState();
    _initCamera();
    _homePageRoute();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    firstCamera = _cameras.first;
    Db.pageLeft = await Db.getPageLimit();
    filei = Directory(await Db.getDir()).listSync();
    int i = 0;
    while (true) {
      if (filei.toString().contains("${Db.filename}$i.docx")) {
        //Db.filename = Db.filename + '$i';
        i++;
      } else {
        Db.filename = Db.filename + '$i';
        break;
      }
    }
  }

  void getPages() {
    Db.getPageLimit().then((val) {
      setState(() {
        Db.pageLeft = val;
      });
    });
  }

//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }

  Future<File> cropImage(String path) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: path,
        compressQuality: 100,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false));
    File file;
    if (croppedImage.readAsBytes() != null) {
      file = new File(croppedImage.path);
    } else {
      file = new File(path);
    }

    return file;
  }

  Widget buildGridView() {
    if (Db.imageList.length != 0)
      return Container(
        //decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black,width: 2.0,style: BorderStyle.solid,))),
        child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            padding: EdgeInsets.all(5.0),
            children: List.generate(Db.displayImages.length, (index) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Db.checker[index]
                            ? Colors.blue[900].withOpacity(1)
                            : Colors.black87,
                        width: Db.checker[index] ? 2.0 : 0.25,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: FlatButton(
                      padding: EdgeInsets.all(1.0),
                      child: Image.file(File(Db.displayImages[index]),
                          height: 300, width: 200),
                      onLongPress: () {
                        setState(() {
                          Db.checker[index] = !Db.checker[index];
                        });
                      },
                      onPressed: () async {
                        if (!Db.checker.contains(true)) {
                          File image;
                          image = await cropImage(Db.displayImages[index]);

                          setState(() {
                            String ind = Db.displayImages[index];
                            Db.displayImages[index] = image.path;
                            Db.imageList[Db.imageList.indexOf(ind)] =
                                image.path;
                          });
                        } else {
                          setState(() {
                            Db.checker[index] = !Db.checker[index];
                          });
                        }
                      }));
            })),
      );
    else
      return Container(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "No images Selected",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Colors.grey[600]),
          ),
        ),
      );
  }

  Future<void> loadAssets() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg']);

    if (result != null) {
      setState(() {
        images = result.paths.map((e) => File(e).path).toList();
        Db.imageList.addAll(images);
        Db.displayImages.addAll(images);
        for (int i = 0; i < Db.displayImages.length; i++) {
          Db.checker.add(false);
        }
      });

      print("Image list");
      print(Db.imageList.length);
      print(Db.displayImages.length);

      Db.languages.forEach((key, value) {
        if (value == true) {
          Db.languages[key] = false;
        }
      });
    }

    print(Db.displayImages);
  }

  void checkBoxLanguages() {
    Db.languages.forEach((key, value) {
      if (value == true) {
        //print(str);
        str = str + "+" + Db.lang[key];
      }
    });
    print('$str   langdata');
    if (str == "") return;
    print('abc');
    List l = str.split("+");
    l.remove("");
    str = l.join("+");
    print('$str   langdata2');
    if (c > 0) {
      for (int i = 0; i < Db.displayImages.length; i++) Db.config.add(str);
      Db.languages.forEach((key, value) {
        if (value == true) {
          Db.languages[key] = false;
        }
      });
    }
  }

  void _homePageRoute() {
    Timer timer;
    timer = Timer.periodic(Duration(seconds: 10), (Timer _) async {
//            print('periodic function');
      List filef = Directory(await Db.getDir()).listSync();
      if (filef.length > filei.length) {
        timer.cancel();
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', ModalRoute.withName('/'));
        Db.languages.forEach((key, value) {
          if (value == true) {
            Db.languages[key] = false;
          }
        });
      }
    });
  }

  Future<void> _convertButtonFunctionality() async {
    print('abc');
    setState(() {
      Db.convert = true;
    });

    //str = "";
    checkBoxLanguages();
    Db.displayImages = [];
    Db.config = Repeat.removeDublicate(Db.config);
    Db.buildShowDialog(context);
    await Db.ImageUpload();

    print(Db.config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (Db.checker != null && Db.checker.contains(true))
                  ? Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            setState(() {
                              Db.sexoo();
                            });
                          },
                        ),
                        Text(
                          "${Db.counter()}",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        )
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${Db.pageLeft} Pages",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
              FlatButton(
                  onPressed: () {
                    if (!Db.checker.contains(true)) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return WelcomeScreen();
                      }), ModalRoute.withName(''));
//                      setState(() {
                      Db.imageList = [];
                      Db.languages.forEach((key, value) {
                        if (value == true) {
                          Db.languages[key] = false;
                        }
//                        });
                      });
                    } else {
                      for (int i = 0; i < Db.checker.length; i++) {
                        if (Db.checker[i] == true) {
                          setState(() {
                            Db.checker[i] = false;
                          });
                          i = 0;
                        }
                      }
                    }
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 19,
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
                            color: Colors.blueAccent[400],
                            icon: Icon(Icons.add_photo_alternate),
                            onPressed: (Db.pageLeft > 0)
                                ? () async {
                                    setState(() {
                                      checkBoxLanguages();
                                      if (c != 0) {
                                        print(c);
                                        //checkBoxLanguages();
                                        Db.displayImages = [];
                                      }
                                    });
                                    str = "";
                                    await loadAssets();
                                    print(c);

                                    c = 0;
                                    print(
                                        "Display images ${Db.displayImages.length}");
                                    print("Image list ${Db.imageList.length}");
                                  }
                                : null),
                        IconButton(
                            color: Colors.blueAccent[400],
                            icon: Icon(Icons.add_a_photo),
                            onPressed: (Db.pageLeft > 0)
                                ? () async {
                                    setState(() {
                                      checkBoxLanguages();

                                      if (c != 0) {
                                        //print("${}")
                                        //checkBoxLanguages();
                                        Db.displayImages = [];
                                      }
                                    });
//                                checkBoxLanguages();
                                    str = "";
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TakePictureScreen(
                                                    camera: firstCamera)));
                                    c = 0;
                                  }
                                : null)
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
                        SizedBox(
                          height: 15,
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
                    color: Colors.green[500],
                    child: FlatButton(
                      child: Text("Convert",
                          style: (Db.imageList.length != 0 &&
                                  Db.displayImages.length != 0 &&
                                  c != 0)
                              ? TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17)
                              : TextStyle(
                                  color: Colors.white38,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17)),
                      onPressed: (Db.imageList.length != 0 &&
                              Db.displayImages.length != 0 &&
                              c != 0)
                          ? _convertButtonFunctionality
                          : null,
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
                                  onChanged: Db.imageList.length != 0
                                      ? (bool value) {
//                                      print(value);

                                          setState(() {
                                            Db.languages[key] = value;
                                            if (value)
                                              c++;
                                            else
                                              c--;
                                            //checkBoxLanguages();
                                          });
                                        }
                                      : null);
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
