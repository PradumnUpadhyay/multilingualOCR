import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matowork/Screen/Login/input_box.dart';
import 'package:matowork/Screen/OTP_Screen/otp_screen.dart';
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
            "Welcome!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 43),
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
                setState(() {
                  Db.email = value;
                });
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
                setState(() {
                  Db.password = value;
                });
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
                onPressed: () async {
                  var _ = await http.post("https://matowork.com/user/otp",
                      body: {"email": Db.email, "password": Db.password});
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return OtpView();
                  }), ModalRoute.withName(''));
                },
                child: Text("LOGIN", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),

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
