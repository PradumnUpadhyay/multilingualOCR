import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:matowork/Screen/Login/login.dart';
import 'package:matowork/components/document_check.dart';
import '../../components/db.dart';

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
                      (valueText!=null) ?
                      Db.filename = valueText.trim(): Db.filename="";
                      print(Db.filename);
                      if (Db.filename.contains('_')) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              "Filename cannot contain an underscore  ( _ ) "),
//                          duration: Duration(seconds: 2),
                        ));
                        setState(() {
                          Db.filename="";
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
//        Colors.deepPurple[100],

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            FlatButton(
              child: Text(
                "LogOut",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              onPressed: () async {
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
            )
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
