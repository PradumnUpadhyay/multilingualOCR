import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:matowork/components/document_check.dart';
import '../../components/db.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//  void _getPages()  {
//    Db.getPageLimit().then((val) {
//      setState(() {
//        Db.pageLeft=val;
//      });
//    });
//  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
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
                  _textFieldController.text="";
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
                      Db.filename = valueText;

                      if(valueText != null && _textFieldController.text != "" && valueText != " ") {
                        Db.convert=false;
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.pushReplacementNamed(context,'/page1');
                      } else {
                        _scaffoldKey.currentState.showSnackBar(Db.snackBar);
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
  Widget build(BuildContext context){
    //Size size = MediaQuery.of(context).size;

//    _getPages();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple[100],

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Pages Remaining: ${Db.pageLeft}",style: TextStyle(color: Colors.black87),),

            Text(
              "Welcome",
              style: TextStyle(color: Colors.black87),
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
