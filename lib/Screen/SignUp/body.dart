import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:matowork/Screen/Login/input_box.dart';
import 'package:matowork/Screen/Login/login.dart';
import 'package:matowork/Screen/OTP_Screen/otp_screen.dart';
import 'package:matowork/components/account_check.dart';
import 'package:matowork/components/db.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _obscureText = true;
  bool _match = true; bool email=false;
  bool gmail=false;
  String _confPass, _pass;
  bool empty=false;
  bool checkEmail=false;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _confPass = _confPass;
      _pass = _pass;
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        height: size.height,
        alignment: Alignment.center,
        color: Color(0xFFF1E6FF),
        child: SingleChildScrollView(
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
                  onChanged: (value) {
                    setState(() {
                      Db.email=value;
                    });

//                  print(Db.email);
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
                        icon: _obscureText
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: _toggle,
                      ),
                      hintText: "Password",
                      border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {
                      _pass=value;
                    });

                  },
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
                  onChanged: (value) {
                    setState(() {
                      _confPass=value;
                    });

                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.45,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    color: Color(0xFF6F35A5),
                    onPressed: () async {
                      if (_pass == _confPass && Db.email !="") {
                        if(!Db.email.contains("@gmail.com")){
                          setState(() {
                            gmail=true;
                            _match = true;
                            email=false;
                            Db.password=_confPass;
                          });

                          print("Inside onpressed");
                          print(Db.email+ Db.password);
                          return;
                        }

                          if(Db.email.contains("@gmail.com")){
                            int i=Db.email.indexOf("@gmail.com");
                            String temp=Db.email.substring(i);
                            if(temp!="@gmail.com"){
                              setState(() {
                                gmail=true;
                                _match = true;
                                email=false;
                              });
                              return ;
                            }
                          }
//                            _match=true;
                        setState(() {
                          _match = true;
                          email=false;

                        });
                        var client=http.Client();

                        if(await Db.checkEmail()=='true') {
                          setState(() {

                          });

                          var res=await client.post("https://matowork.com/user/opt", body: json.encode( { "email": Db.email } ),
                              headers: {'Content-Type': "application/json"});
                          print(res.statusCode);
//                        print(Db.email);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return OtpView();
                              }));

                          print(_match);
                        }
                        if(await Db.checkEmail()=='false'){
                          setState(() {
                            email=false;
                            checkEmail=true;
                          });
                        }
                      } if(_pass != _confPass && Db.email !="") {
                        setState(() {
                          email=false;
                          _match = false;
                          gmail=false;
                        });
                      }

                      if(Db.email=="") {
                        setState(() {
                          _match=true;
                          email=true;
                        });
                      }

                      if(Db.password == "" || Db.password == " ") {
                        setState(() {
                          empty=true;
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
               _match == false
                  ? Text(
                      "Passwords do not match",
                      style: TextStyle(color: Colors.red),
                    )
                  : (empty == true) ? Text("Password cannot be empty", style: TextStyle(color: Colors.red, fontSize: 17)) : Text(""),

                checkEmail == true ? Text("Email Already exists",style: TextStyle(color: Colors.red, fontSize: 17)): Text(""),

              email==true ? Text("Enter your Email", style: TextStyle(color: Colors.red, fontSize: 17)) : Text(""),
              gmail==true ? Text("Please enter a gmail account", style: TextStyle(color: Colors.red, fontSize: 17),) : Text(""),
              SizedBox(
                height: size.height * 0.02,
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
        ),

//          ),
      ),
    );
  }
}
