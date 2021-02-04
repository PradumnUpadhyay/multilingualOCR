import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:io';
class ImageUtil {

  List<File> file = new List<File>();

  Future<List<File>> imagesPath() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg']);

    if (result != null) {
      file = result.paths.map((e) => File(e));
      for(int i=0;i<file.length; i++) {
        print("Path: "+file[i].path);
      }
      return file;
    }
  } // imagesPath()

  List<MultipartFile> newList = new List<MultipartFile>();

  Future<String> ImageUpload() async {
    var request = http.MultipartRequest('POST', Uri.parse('https://matowork.com/user/upload'));

    for (int i = 0; i < file.length; i++) {
      newList.add(await http.MultipartFile.fromPath('images', file[i].path));
    }
    request.files.addAll(newList);
  }
}