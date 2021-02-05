//import 'package:flutter/material.dart';
//import '../../components/db.dart';
//import 'package:image_cropper/image_cropper.dart';
//import 'dart:io';
//
//import 'dart:async';
//import 'package:camera/camera.dart';
//import 'package:matowork/components/repeat.dart';
//
//class Page1Body extends StatefulWidget {
//  @override
//  _Page1BodyState createState() => _Page1BodyState();
//}
//
//class _Page1BodyState extends State<Page1Body> {
//
////  int c=0;
//
//  List<CameraDescription> _cameras;
//  List<String> images=new List<String>();
//  CameraDescription firstCamera;
//  List filei=[];
//  @override
//  void initState(){
//    getPages();
//    super.initState();
//    _initCamera();
//
//  }
//
//  void getPages()  {
//    Db.getPageLimit().then((val) {
//      setState(() {
//        Db.pageLeft=val;
//      });
//    });
//  }
//
//  Future<void> _convertButtonFunctionality() async {
//    setState(() {
//      Db.convert=true;
//    });
//    str = "";
//    checkBoxLanguages();
//    Db.config = Repeat.removeDublicate(Db.config);
//    await Db.ImageUpload();
//
//    print(Db.config);
//  }
//
//  Future<void> _initCamera() async {
//    _cameras = await availableCameras();
//    firstCamera=_cameras.first;
//    Db.pageLeft=await Db.getPageLimit();
//    filei = Directory(await Db.getDir()).listSync();
//    while (true) {
//      if (filei.toString().contains("${Db.filename}.docx"))
//        Db.filename= Db.filename + '_1';
//      else
//        break;
//    }
//  }
//
//  Future<File> cropImage(String path) async {
//    File croppedImage = await ImageCropper.cropImage(
//        sourcePath: path,
//        compressQuality: 100,
//        androidUiSettings: AndroidUiSettings(
//            toolbarTitle: 'Cropper',
//            toolbarColor: Colors.deepPurple,
//            toolbarWidgetColor: Colors.white,
//            initAspectRatio: CropAspectRatioPreset.original,
//            lockAspectRatio: false));
//    File file;
//    if (croppedImage.readAsBytes() != null) {
//      file = new File(croppedImage.path);
//    } else {
//      file = new File(path);
//    }
//
//    return file;
//  }
//
//  Widget buildGridView() {
//    if (Db.imageList.length != 0)
//
//      return Container(
//        //decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black,width: 2.0,style: BorderStyle.solid,))),
//        child: GridView.count(
//            crossAxisCount: 2,
//            padding: EdgeInsets.all(5.0),
//            children:
//            List.generate(Db.displayImages.length, (index)
//            {
//              return Container(
//                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
//                  decoration: BoxDecoration(
//                    border: Border.all(color: Colors.black,width: 1.0),
//                  ),
//                  child: FlatButton(
//                      padding: EdgeInsets.all(1.0),
//
//                      child: Image.file(File(Db.displayImages[index]), height: 300, width: 200),
//                      onLongPress: () {},
//                      onPressed: () async {
//                        File image;
//                        image=await cropImage(File(Db.displayImages[index]).path);
//
//                        setState(() {
//                          Db.displayImages[index]=image.path;
//                        });
//
//                      })
//              );
//
//            })
//        ),
//      );
//    else
//      return Container(
//        width: 200,
//        child: Padding(
//          padding: const EdgeInsets.all(15.0),
//          child: Text(
//            "No images Selected",
//            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.grey[600]),
//          ),
//        ),
//      );
//  }
//
//  void homePageRoute() async {
//    Timer timer;
//    timer = Timer.periodic(Duration(seconds: 10),
//            (Timer _) async {
//
////            print('periodic function');
//          List filef = Directory(await Db.getDir()).listSync();
//          if (filef.length > filei.length) {
//            timer.cancel();
//            Navigator.pushNamedAndRemoveUntil(context,'/home',ModalRoute.withName('/'));
//            Db.languages.forEach((key, value) {
//              if (value == true) {
//                Db.languages[key] = false;
//              }
//            });
//
//          }
//        });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
