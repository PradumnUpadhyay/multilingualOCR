import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class Db {
  static final snackBar = SnackBar(
    content: Text('Filename is empty'),
    duration: Duration(seconds: 2),
  );

  static bool forgotPass=false;
  static bool invalidOtp = false;
  static List<bool> checker = new List<bool>();
  static bool convert = false;
  static var client = http.Client();
  static String filename;
  static String email = "";
  static String username = "";
  static List<String> displayImages = new List<String>();
  static String password = "";
  static int pageLeft = 0;
  static String otp;
  static List<String> imageList = new List<String>();
  static Map<String, bool> languages = {
    "Hindi": false,
    "Sanskrit": false,
    'English': false,
    "German": false,
    "French": false,
    "Spanish": false,
    "Hebrew": false,
    "Japanese": false,
    "Arabic": false
  };
  static Map<String, String> lang = {
    "Hindi": "hin",
    "Sanskrit": "Devanagari",
    "English": "eng",
    "German": "Latin",
    "French": "Latin",
    "Spanish": "Latin",
    "Hebrew": "Hebrew",
    "Japanese": "Japanese",
    "Arabic": "Arabic"
  };
  static List<String> config = [];

  static buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
            ),
          );
        });
  }

  static Future<File> getFile(String filename) async {
    final dir = await getExternalStorageDirectory();
    return File("${dir.path}/$filename.docx");
  }

  static Future<String> getDir() async {
    final dir = await getExternalStorageDirectory();
    return dir.path;
  }

  // Storing image files
  static Future<void> ImageUpload() async {
    List<MultipartFile> fileList = new List<MultipartFile>();
    print(Db.config);
    print("${Db.imageList.length}  imageLength");
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://matowork.com/user/upload"));

    for (int i = 0; i < imageList.length; i++) {
      fileList.add(await http.MultipartFile.fromPath('images', imageList[i]));
    }
    request.files.addAll(fileList);

    Map<String, String> data = new Map<String, String>();

    data = {
      'filename': Db.filename,
      'username': Db.username,
      "config": Db.config.join("\$")
    };

    request.fields.addAll(data);

    var res = await request.send();
    print(res);
    Db.imageList = [];
    Db.config = [];
    Db.displayImages = [];
    List<int> bytes = [];

    final file = await getFile(Db.filename);
    await file.writeAsBytes(bytes);
    res.stream.listen((List<int> newBytes) {
      bytes.addAll(newBytes);
    }, onDone: () async {
      print("writing to file");
      print(Db.filename);
      await file.writeAsBytes(bytes);
      Db.imageList = [];
    }, onError: (e) {
      print(e);
    });

    print("Response code: ${res.statusCode}");
  }

  static Future<int> getPageLimit() async {
    var res = await Db.client.post("https://matowork.com/user/getlimit",
        body: json.encode({"username": Db.username}),
        headers: {'Content-Type': "application/json"});

    Map body = json.decode(res.body);
//    print(body);
    return body['pagelimit'];
  }

  static Future<String> checkEmail() async {
    if (Db.email == "") {
      return "";
    }
    var res = await Db.client.post("https://matowork.com/user/exist",
        body: json.encode({"email": Db.email}),
        headers: {'Content-Type': "application/json"});
    print("Response body: ");
    print(res.body);
    print(res.statusCode);
    Map body = json.decode(res.body);
    print(body['exist']);
    if (body.containsKey('exist')) if (body['exist'] == true)
      return "false";
    else
      return 'true';
    else
      return Db.checkEmail();
  }

  static void sexoo() {
    for (int i = 0; i < Db.checker.length; i++) {
      if (Db.checker[i] == true) {
        Db.imageList.remove(Db.displayImages[i]);
        Db.displayImages.removeAt(i);
        Db.checker.removeAt(i);
        i = 0;
      }
    }
    for (int i = 0; i < Db.checker.length; i++) {
      if (Db.checker[i] == true) {
        Db.checker[i] = false;
        i = 0;
      }
    }
  }

  static int counter() {
    int c = 0;
    for (int i = 0; i < Db.checker.length; i++) {
      if (Db.checker[i] == true) {
        c++;
      }
    }

    return c;
  }

}
