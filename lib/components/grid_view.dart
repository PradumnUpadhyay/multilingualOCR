import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class GridViewImages extends StatefulWidget {
  @override
  GridViewImagesState createState() => GridViewImagesState();
}

class GridViewImagesState extends State<GridViewImages> {
  final List<String> entries = <String>['A', 'B', 'C', 'D'];

  List<Asset> images = List<Asset>();
  String _error;

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 2,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];

          return Container(
            child: AssetThumb(
              asset: asset,
              width: 100,
              height: 100,
            ),
          );
        }),
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
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
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
      if (error == null) _error = "No error detected";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildGridView());
  }
}
