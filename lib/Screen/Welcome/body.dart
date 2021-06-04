import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:matowork/Screen/Login/login.dart';
import 'package:matowork/Screen/Upgrade/inapp_purchase.dart';
import 'package:matowork/components/document_check.dart';
import '../../components/db.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _BodyState() {
    Db.getPageLimit().then((value) {
      setState(() {
        Db.pageLeft = value;
      });
    });

    Db.getExpiry().then((value) {
      setState(() {
        Db.expiry = value;
      });
    });
  }

  void initState() {
    super.initState();

    showMessage();
  }

  Future<void> showMessage() async {
    if (await Db.getVersion() == null)
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Container(
//              color: Colors.deepPurple[200],
              height: 50,
              child: Text(
                "Alert!",
                style: TextStyle(
//                color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w400),
              ),
            ),
            content: Text(
                "A new Version of app is available. To continue using this application, please download the latest version."),
            actions: [
              FlatButton(
                  onPressed: () async {
                    if (await canLaunch(
                        "https://matowork.com/multilingual/download")) {
                      await launch(
                        "https://matowork.com/multilingual/download",
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch';
                    }
                  },
                  child: Text("Download"))
            ],
          );
        },
      );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Filename'),
            backgroundColor: Colors.white,
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Filename"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  _textFieldController.text = "";
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              Builder(
                builder: (context) => FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('CREATE'),
                  onPressed: () {
                    setState(() {
                      (valueText != null)
                          ? Db.filename = valueText.trim()
                          : Db.filename = "";
                      print(Db.filename);
                      if (Db.filename.contains('_')) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              "Filename cannot contain an underscore  ( _ ) "),
//                          duration: Duration(seconds: 2),
                        ));
                        setState(() {
                          Db.filename = "";
                        });
                        return;
                      }
                      if (valueText != null &&
                          _textFieldController.text != "" &&
                          valueText != " ") {
                        Db.convert = false;
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacementNamed(context, '/page1');
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Filename is empty'),
//                          duration: Duration(seconds: 2),
                        ));
                      }
                    });
                  },
                ),
              ),
            ],
          );
        });
  }

  String valueText;
  String codeDialog;

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

//    _getPages();

    return Scaffold(
      key: _scaffoldKey,
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Drawer(
              child: ListView(
//          padding: EdgeInsets.all(8.0),
            children: <Widget>[
              SafeArea(
                child: UserAccountsDrawerHeader(
                  accountEmail: Text("${Db.username.split("com")[0] + "com"}"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      "${Db.username[0].toUpperCase()}",
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.timer,
                ),
                title: Text(
                  "${Db.expiry} days left",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Divider(
                  color: Colors.black38,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.cloud_upload,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  "Upgrade",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 19,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return InAppPurchases();
                  }), ModalRoute.withName(''));
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Divider(
                  color: Colors.black38,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                ),
                title: Text("LogOut",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 19,
                        fontWeight: FontWeight.w500)),
                onTap: () async {
                  var box = await Hive.openBox("uname");
                  box.deleteFromDisk();
                  Db.email = "";
                  Db.password = "";
                  Db.username = "";

                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }), ModalRoute.withName(''));
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Divider(
                  color: Colors.black38,
                ),
              ),
              Db.tier != "" && Db.tier != null
                  ? ListTile(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return InAppPurchases();
                        }), ModalRoute.withName(''));
                      },
                      title: Text(
                        "Upgraded: ${Db.tier}",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                      ),
                    )
                  : Text("")
            ],
          )),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.deepPurple,
//        Colors.deepPurple[100],

        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
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
//            FlatButton(
//              child: Text(
//                "LogOut",
//                style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 20,
//                    fontWeight: FontWeight.w400),
//              ),
//              onPressed: () async {
//                var box = await Hive.openBox("uname");
//                box.deleteFromDisk();
//                Db.email = "";
//                Db.password = "";
//                Db.username = "";
//
//                Navigator.pushAndRemoveUntil(context,
//                    MaterialPageRoute(builder: (context) {
//                  return LoginScreen();
//                }), ModalRoute.withName(''));
//              },
//            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: ListFiles(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF6F35A5),
      ),
    );
  }
}
