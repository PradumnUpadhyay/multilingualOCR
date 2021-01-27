import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';

class Db {
  static Future<File> _getFile(String filename) async {
    final dir = await getExternalStorageDirectory();
    return File("${dir.path}/$filename.docx");
  }

  static String filename;
  static String email;
  static String password;
  static String otp;
  static int pageLeft = 0;
  static List<int> imageList = [];
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
  static var file;
  static var req = http.MultipartRequest(
      'POST', Uri.parse("https://matowork.com/user/upload"));

  static void addingImage(List<int> image, String name) async {
    Db.req.files
        .add(http.MultipartFile.fromBytes("images", image, filename: name));
  }

  static void addingField(String filename, String username) async {
    Db.req.fields.addAll({'filename': filename, 'username': username});
    Db.file = await Db.req.send();

    final fileName = await _getFile(filename);
    await fileName.writeAsBytes(Db.file.readAsByteSync());

//    Db.file.stream.listen((List<int> newBytes) {
//      bytes.addAll(newBytes);
//    },
//    onDone: () async {
//      await Db.file.writeAsBytes(bytes);
//    }
//    );
  }
}
