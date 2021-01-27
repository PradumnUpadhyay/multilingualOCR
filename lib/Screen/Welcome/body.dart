import 'package:flutter/material.dart';
import 'package:matowork/Screen/Page1/page1.dart';
import 'package:matowork/components/document_check.dart';
import '../../components/db.dart';

//Color(0xFFF1E6FF)
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _textFieldController = TextEditingController();

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
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Create'),
                onPressed: () {
                  setState(() {
                    Db.filename = valueText;
                    print(codeDialog);
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return Page1();
                    }), ModalRoute.withName(''));
                  });
                },
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Center(
            child: Text(
          "Welcome Yagami!",
          style: TextStyle(color: Colors.black87),
        )),
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
