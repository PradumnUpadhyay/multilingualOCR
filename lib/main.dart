import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:matowork/Screen/Forgot_Password/forgot_pass.dart';
import 'package:matowork/Screen/Page1/page1.dart';
import 'package:matowork/Screen/SignUp/signup.dart';
import 'package:hive/hive.dart';
import 'package:matowork/Screen/Upgrade/inapp_purchase.dart';
import 'package:matowork/Screen/Upgrade/upgrade.dart';
import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';
import 'package:matowork/components/db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

List<CameraDescription> cameras;
bool userChecker = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var x = await getApplicationDocumentsDirectory();
  Hive.init(x.path);
  var box = await Hive.openBox('uname');
  String un = box.get('username');
  Db.username = un;
  Db.tier=box.get("tier");
  print("tier ${Db.tier.runtimeType}");
  print("Username");
  print(Db.username);
  Db.pageLeft= await Db.getPageLimit();
  print("Pages left ${Db.pageLeft}");
  (un != null && un != "") ? userChecker = true : userChecker = false;
  cameras = await availableCameras();
  InAppPurchaseConnection.enablePendingPurchases();
//  print(Db.pageLeft);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFF6F35A5),
          scaffoldBackgroundColor: Colors.white),
      home:
//          InAppPurchases(),
//      ForgotPasswordScreen(),
//UpgradeScreen(),
          userChecker == true ? WelcomeScreen() : SignUp(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => WelcomeScreen(),
        '/page1': (BuildContext context) => Page1()
      },
    );
  }
}
