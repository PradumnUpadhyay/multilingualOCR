import 'package:flutter/material.dart';
import 'package:matowork/Screen/Login/input_box.dart';
import 'package:matowork/Screen/Login/login.dart';
import 'package:matowork/components/account_check.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _obscureText = true;
  bool _match = true;
  String _confPass, _pass;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _confPass = _confPass;
      _pass = _pass;
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      alignment: Alignment.center,

      color: Color(0xFFF1E6FF),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Let's get started!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 43),
          ),

          SizedBox(
            height: size.height * 0.02,
          ),
          InputBox(
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Color(0xFF6F35A5),
                  ),
                  hintText: "Your Email",
                  border: InputBorder.none),
              onChanged: (value) {},
            ),
          ),

          SizedBox(
            height: size.height * 0.02,
          ),
          InputBox(
            child: TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: Color(0xFF6F35A5),
                  ),
                  suffixIcon: IconButton(
                    icon: _obscureText
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: _toggle,
                  ),
                  hintText: "Password",
                  border: InputBorder.none),
              onChanged: (value) {},
            ),
          ),
//
          SizedBox(
            height: size.height * 0.02,
          ),
          InputBox(
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: Color(0xFF6F35A5),
                  ),
                  hintText: "Confirm Password",
                  border: InputBorder.none),
              onChanged: (value) {},
            ),
          ),
          _match == false
              ? Text(
                  "Passwords do not match",
                  style: TextStyle(color: Colors.red),
                )
              : Text(""),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: size.width * 0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                color: Color(0xFF6F35A5),
                onPressed: () {
                  if (_pass == _confPass) {
//                            _match=true;
                    setState(() {
                      _match = true;
                    });

                    print(_match);
                  } else {
                    setState(() {
                      _match = false;
                    });
                  }
                },
                child: Text(
                  "SIGN UP",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          SizedBox(
            height: size.height * 0.01,
          ),
          AccountCheck(
            login: false,
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }));
            },
          )
        ],
      ),

//          ),
    );
  }
}
