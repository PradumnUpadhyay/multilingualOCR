import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matowork/Screen/OTP_Screen/otp_timer.dart';
import 'package:matowork/Screen/SignUp/signup.dart';
import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';
import 'package:matowork/components/db.dart';
import 'package:hive/hive.dart';

class OtpView extends StatefulWidget {
  @override
  _OtpViewState createState() => new _OtpViewState();
}

class _OtpViewState extends State<OtpView> with SingleTickerProviderStateMixin {
  // Constants
  final int time = 75;
  AnimationController _controller;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;
  int _fifthDigit;
  int _sixthDigit;
  bool disable = false;
  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;

  // Returns "Appbar"
  get _getAppbar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return SignUp();
          }), ModalRoute.withName(''));
        },
      ),
      centerTitle: true,
    );
  }

  // Return "Verification Code" label
  get _getVerificationCodeLabel {
    return Text(
      "Verification Code",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  // Return "Email" label
  get _getEmailLabel {
    return Text(
      "Please enter the OTP sent\non your Email.",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),
    );
  }

  // Return "OTP" input field
  get _getInputField {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      _getVerificationCodeLabel,
      _getEmailLabel,
      _getInputField,
      _hideResendButton ? _getTimerText : _getResendButton,
      _getOtpKeyboard
    ],
      );
  }

  // Returns "Timer" label
  get _getTimerText {
    return Container(
      height: 32,
      child: Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.access_time),
            SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, Colors.black)
          ],
        ),
      ),
    );
  }

  // Returns "Resend" button
  get _getResendButton {
    return Container(
      height: 50,
      width: 200,
      child: MaterialButton(
          splashColor: Colors.red.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: Colors.blueAccent,
          onPressed: disable == true
              ? null
              : () async {
                  setState(() {
                    disable = true;
                  });
                  print("Username: " + Db.email + Db.password);
                  http.Response _ = await Db.client.post(
                      "https://matowork.com/user/opt",
                      body: json.encode({"email": Db.email}),
                      headers: {'Content-Type': "application/json"});
                  clearOtp();
                  _startCountdown();
                },
          child: Text(
            "Resend OTP",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return Container(
        height: _screenSize.width - 80,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _sixthDigit != null,
                    child: _otpKeyboardActionButton(
                        label: Icon(
                          Icons.check_circle,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          print("OTP screen");
                          http.Response response;
                          print(Db.email + Db.password);
                          print(Db.otp);
                          print(Db.forgotPass);
                          if(Db.forgotPass == true){
                            print(Db.password);
                            response=await Db.client.post("https://matowork.com/user/password",
                                body: json.encode( {"email": Db.email,
                                  "otp": Db.otp,
                                  "username": "${Db.email}${Db.password}"} ),
                                headers: {'Content-Type': "application/json"}


                            );
                            Db.forgotPass=false;
                          }

                          else
                           {
                             print("Else ${Db.password}");
                             response = await Db.client.post(
                                 "https://matowork.com/user/registration",
                                 body: json.encode({
                                   "email": Db.email,
                                   "otp": Db.otp,
                                   "username": "${Db.email + Db.password}"
                                 }),
                                 headers: {'Content-Type': "application/json"});

                           }
                          var res = json.decode(response.body);
                          print(response.body);
                          if (res['registration'] == true || res['changed'] == "true") {
                            var box = await Hive.openBox("uname");
                            Db.username = Db.email + Db.password;
                            box.put('username', Db.username);
                            Db.pageLeft = await Db.getPageLimit();
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return WelcomeScreen();
                            }), ModalRoute.withName(''));
                          } else {
                            Db.invalidOtp = true;

                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return SignUp();
                            }), ModalRoute.withName(''));
                          }
                        }),
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_sixthDigit != null) {
                            _sixthDigit = null;
                          } else if (_fifthDigit != null) {
                            _fifthDigit = null;
                          } else if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  // Overridden methods
  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _getAppbar,
      backgroundColor: Colors.white,
      body: Container(
        width: _screenSize.width,
        //        padding: new EdgeInsets.only(bottom: 16.0),
        child: _getInputPart,
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: Text(
        digit != null ? digit.toString() : "",
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
          //            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: Colors.black,
      ))),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: Container(
          height: 80.0,
          width: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;
      } else if (_fifthDigit == null) {
        _fifthDigit = _currentDigit;
      } else if (_sixthDigit == null) {
        _sixthDigit = _currentDigit;

        Db.otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString() +
            _fifthDigit.toString() +
            _sixthDigit.toString();

        // Verify your otp by here. API call
      }
    });
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void clearOtp() {
    _sixthDigit = null;
    _fifthDigit = null;
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}
