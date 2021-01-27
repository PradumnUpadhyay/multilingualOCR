import 'package:flutter/material.dart';
import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color(0xFF6F35A5),
          scaffoldBackgroundColor: Colors.white),
      home: WelcomeScreen(),
    );
  }
}
