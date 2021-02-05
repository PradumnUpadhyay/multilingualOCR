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

//[hin, hin+hin+Devanagari, hin+hin+Devanagari+hin+Devanagari+eng]
class Page1 extends StatefulWidget {

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  String str = "";
  int c=0;
  bool isSelected=false;
//  CameraController _controller;
  List<CameraDescription> _cameras;
  List<String> images=new List<String>();
  CameraDescription firstCamera;
  List filei=[];
  @override
  void initState(){
    getPages();
    super.initState();
    _initCamera();
    _homePageRoute();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    firstCamera=_cameras.first;
   Db.pageLeft=await Db.getPageLimit();
    filei = Directory(await Db.getDir()).listSync();
    while (true) {
      if (filei.toString().contains("${Db.filename}.docx"))
        Db.filename= Db.filename + '_1';
      else
        break;
    }
  }

  void getPages()  {
    Db.getPageLimit().then((val) {
    setState(() {
    Db.pageLeft=val;
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
          padding: EdgeInsets.all(5.0),
          children:
           List.generate(Db.displayImages.length, (index)
          {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
              decoration: BoxDecoration(
              border: Border.all(color: Colors.black,width: 1.0),
              ),
              child: FlatButton(
              padding: EdgeInsets.all(1.0),

                child: Image.file(File(Db.displayImages[index]), height: 300, width: 200),
                  onLongPress: () {
                      _showSelectedOverlay(context, index);
                  },
                  onPressed: () async {
                  File image;
                  image=await cropImage(File(Db.displayImages[index]).path);

                  setState(() {
                  Db.displayImages[index]=image.path;
                  });

          })
          );

          })
        ),
      );
    else
      return Container(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "No images Selected",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.grey[600]),
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
      if (str == "") return;
      List l = str.split("+");
      l.remove("");
      str = l.join("+");
      for (int i = 0; i < Db.imageList.length; i++)
        Db.config.add(str);
      Db.languages.forEach((key, value) {
        if (value == true) {
          Db.languages[key] = false;
        }
      });
    }

    void _homePageRoute() {
      Timer timer;
      timer = Timer.periodic(Duration(seconds: 10),
              (Timer _) async {

//            print('periodic function');
            List filef = Directory(await Db.getDir()).listSync();
            if (filef.length > filei.length) {
              timer.cancel();
              Navigator.pushNamedAndRemoveUntil(context,'/home',ModalRoute.withName('/'));
              Db.languages.forEach((key, value) {
                if (value == true) {
                  Db.languages[key] = false;
                }
              });

            }
          });

    }

  Future<void> _convertButtonFunctionality() async {
    setState(() {
      Db.convert=true;
    });
    str = "";
    checkBoxLanguages();
    Db.config = Repeat.removeDublicate(Db.config);
    Db.buildShowDialog(context);
    await Db.ImageUpload();

    print(Db.config);
  }

  Future<void> _showSelectedOverlay(BuildContext context,int index) {
    return showDialog(context: context,
      builder: (context) {
          return Scaffold(
            body: InkWell(
              onTap: () {
                setState(() {
                  isSelected=!isSelected;
                  if(isSelected) {
                    Db.selectedImage.add(Db.displayImages[index]);
                  } else{
                    Db.selectedImage.remove(Db.displayImages[index]);
                  }
                });

                print("$index : ${Db.selectedImage[index]}");
//              widget.isSelected(isSelected);
              },

              child: Stack(
                children: <Widget>[
                  Image.file(File(Db.displayImages[index]), color: Colors.black.withOpacity(isSelected ? 0.9: 0.0), colorBlendMode:  BlendMode.color,),

                  isSelected ?
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      ),
                    ),
                  ) :
                  Container()
                ],
              ),
            ),
          );
      }
    );
  }

  @override
    Widget build(BuildContext context) {

//      Timer timer;
//      timer = Timer.periodic(Duration(seconds: 10),
//              (Timer _) async {
//
////            print('periodic function');
//            List filef = Directory(await Db.getDir()).listSync();
//            if (filef.length > filei.length) {
//              timer.cancel();
//              Navigator.pushNamedAndRemoveUntil(context,'/home',ModalRoute.withName('/'));
//              Db.languages.forEach((key, value) {
//                if (value == true) {
//                  Db.languages[key] = false;
//                }
//              });
//
//            }
//          });

      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pages Remaining: ${Db.pageLeft}",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                FlatButton(
                    onPressed: () {

                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                            return WelcomeScreen();
                          }), ModalRoute.withName(''));
//                      setState(() {
                        Db.imageList=[];
                        Db.languages.forEach((key, value) {
                          if (value == true) {
                            Db.languages[key] = false;
                          }
//                        });
                      });

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
            leadingWidth: MediaQuery
                .of(context)
                .size
                .width / 2,
            backgroundColor: Color(0xFF6F35A5),
          ),
          body: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 35,
                  color: Colors.deepPurple,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                              onPressed:( Db.pageLeft > 0 && Db.pageLeft<=25 ) ? () async {

                                setState(() {
                                  checkBoxLanguages();
                                  if(c!=0) {
                                    print(c);
                                    checkBoxLanguages();
                                    Db.displayImages=[];
                                  }
                                });
                                str = "";
                                await loadAssets();
                                print(c);

                                c=0;
                                print("Display images ${Db.displayImages.length}");
                                print("Image list ${Db.imageList.length}");
                              }: null),
                          IconButton(
                              color: Colors.blueAccent[400],
                              icon: Icon(Icons.add_a_photo),
                              onPressed: (c>0 || (Db.pageLeft > 0 && Db.pageLeft<=25)) ? () async {
                                setState(() {
                                  checkBoxLanguages();
                                });
//                                checkBoxLanguages();
                                str = "";
                               Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)));
                               setState(() {
                                 if(c!=0) {
                                   Db.displayImages=[];
                                   checkBoxLanguages();
                                 }
                                 c=0;
                               });

                              } : null)
                        ],
                      ),
                    ),
                    body: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height - 200,
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
                          SizedBox(height: 15,),
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
                            style: (Db.imageList.length != 0 && Db.displayImages.length != 0 && c !=0) ? TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 17) :
                            TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 17)),
                        onPressed: (Db.imageList.length != 0 && Db.displayImages.length != 0) ?
                        _convertButtonFunctionality : Db.convert == true ?
                        null : _convertButtonFunctionality,
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
                                    onChanged: Db.imageList.length != 0 ?
                                        (bool value) {
//                                      print(value);

                                      setState(() {
                                        Db.languages[key] = value;
                                        if(value) c++;
                                        else c--;
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
          )
      );
    }
  }

