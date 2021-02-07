import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:matowork/Screen/Login/input_box.dart';

import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';
import 'package:matowork/components/account_check.dart';
import 'package:matowork/components/db.dart';
import '../SignUp/signup.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _obscureText = true;
  bool _toggleIcon = false;
  bool checker = false;
  bool checker2 = false;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _toggleIcon = !_toggleIcon;
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Color(0xFFF1E6FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 40),
          ),

          SizedBox(
            height: size.height * 0.03,
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
              onChanged: (value) {
                Db.email = value.trim();
              },
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
                    icon: _toggleIcon
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: _toggle,
                  ),
                  hintText: "Password",
                  border: InputBorder.none),
              onChanged: (value) {
                Db.password = value.trim();
              },
            ),
          ),
//
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: size.width * 0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                color: Color(0xFF6F35A5),
                onPressed: checker2 == true
                    ? null
                    : () async {
                        if (Db.email == "" || Db.password == "") {
                          setState(() {
                            checker = true;
                          });
                          return;
                        }
                        setState(() {
                          checker2 = true;
                        });

                        var res = await Db.client.post(
                            "https://matowork.com/user/login",
                            body: json.encode(
                                {"email": Db.email, "password": Db.password}),
                            headers: {'Content-Type': "application/json"});
                        Map body = json.decode(res.body);
                        print(res.statusCode);
                        if (body["logged-in"] == true) {
                          var box = await Hive.openBox('uname');
                          Db.username = Db.email + Db.password;
                          box.put("username", Db.username);
                          print("Login");
                          print(Db.username);
                          Db.pageLeft = await Db.getPageLimit();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return WelcomeScreen();
                          }), ModalRoute.withName(''));
                        } else {
                          setState(() {
                            checker = false;
                            checker2 = false;
                          });
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid Email or Password'),
                            duration: Duration(seconds: 5),
                          ));
                          // setState(() {
                          //   checker = true;
                          //   checker2 = false;
                          // });
                        }
                      },
                child: Text("LOGIN", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          checker == true
              ? Text("Please enter your email and password",
                  style: TextStyle(color: Colors.red, fontSize: 17))
              : Text(""),
          SizedBox(
            height: size.height * 0.03,
          ),
          AccountCheck(
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignUp();
              }));
            },
          )
        ],
      ),
    );
  }
}
