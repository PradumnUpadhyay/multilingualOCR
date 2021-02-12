import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:matowork/Screen/Page1/page1.dart';
import 'package:matowork/components/db.dart';
import 'dart:io';
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
 List<String> files=new List<String>();
 XFile file;
 int c=0;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Images Clicked: $c', style: TextStyle(
            fontWeight: FontWeight.w300
          ),),
          FlatButton(
              onPressed: () async {
                Db.displayImages.addAll(files);
              Db.imageList.addAll(files);
                for(int i=0;i<Db.displayImages.length;i++) {
                  Db.checker.add(false);
                }
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return Page1();
              }), ModalRoute.withName(''));}, child: Text("Done", style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Colors.white)))
        ],
      ),
       ),
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            file=await _controller.takePicture();
            setState(() {
              c++;
              print(c);
              print(file.path);
              files.add(file.path);
            });

          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
