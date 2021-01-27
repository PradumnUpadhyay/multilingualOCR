import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AccountCheck({
    Key key,
    this.login=true,
    this.press
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
     Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text( login ? "Don't have an Account? " : "Already have an Account? ", style: TextStyle(
                color: Color(0xFF6F35A5)
            ),
            ),

            GestureDetector(
              onTap: press,
              child: Text( login ? "Sign Up" : "Sign In", style: TextStyle(
                  color: Color(0xFF6F35A5),
                  fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              ),),
            )
          ],
    );
  }
}
