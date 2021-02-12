import 'dart:convert';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:matowork/components/db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

class ListFiles extends StatefulWidget {
  @override
  _ListFilesState createState() => _ListFilesState();
}

class _ListFilesState extends State<ListFiles> {
  String dir;
  List file = new List();

  @override
  void initState() {
    super.initState();
    listFiles();
  }

  // Function to get files
  void listFiles() async {
    dir = (await getExternalStorageDirectory()).path;
    setState(() {
      file = Directory(dir).listSync();
      print(file);
    });
  }

  // Function to open file
  Future<void> openFile(String filename) async {
    print(filename);
    //List<Application> apps = await DeviceApps.getInstalledApplications();
    bool checker = await DeviceApps.isAppInstalled(
        'com.google.android.apps.docs.editors.docs');
    if (checker == true)
      await OpenFile.open(filename);
    else
      await launch(
          'https://play.google.com/store/apps/details?id=com.google.android.apps.docs.editors.docs');
  }

  @override
  Widget build(BuildContext context) {
    if (file.length == 0)
      return Container(
        alignment: Alignment.center,
        child: Text(
          'You haven\'t created any document',
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      );
    else
      return Container(
        height: MediaQuery.of(context).size.height,
        //color: Colors.grey,
        child: ListView.separated(
            itemBuilder: (context, index) {
              var item = file[index].toString();
              var pos = item.split('/').length - 1;
              if (item.split('/')[pos] == "Pictures'")
                return Container(
                  width: 0,
                  height: 0,
                );
              else
                return Opacity(
                  opacity: 1,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, color: Colors.purple[50]),
                        borderRadius: BorderRadius.circular(8.0)),
                    color: Colors.lightBlue[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 2, 5, 2),
                          alignment: Alignment.centerLeft,
                          //width: MediaQuery.of(context).size.width - 100,
                          child: FlatButton(
                            onPressed: () async {
                              print("Card clicked!");
                              final String path = (item
                                  .toString()
                                  .split("File: '")[1]
                                  .replaceAll("'", ""));
                              openFile(path);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.split('/')[pos].replaceAll("'", ""),
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[900],
                          ),
                          onPressed: () async {
                            final String path = (item
                                .toString()
                                .split("File: '")[1]
                                .replaceAll("'", ""));
                            File temp = File(path);
                            await temp.delete();
                            //print();
                            print(item.split('/')[pos].replaceAll("'", ""));
                            var res = await Db.client.post(
                                Uri.parse("https://matowork.com/user/delete"),
                                body: json.encode({
                                  "filename":
                                      '${item.split('/')[pos].replaceAll("'", "")}',
                                  "username": Db.username
                                }),
                                headers: {"Content-Type": "application/json"});

                            Map body = json.decode(res.body);
                            print(body);
                            setState(() {
                              file = Directory(dir).listSync();
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 8.0,
                ),
            itemCount: file.length),
      );
  }
}
