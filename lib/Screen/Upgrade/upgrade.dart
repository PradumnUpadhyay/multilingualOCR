import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:matowork/Screen/Page1/page1.dart';
import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';
import 'package:matowork/components/db.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class UpgradeScreen extends StatefulWidget {
  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  Razorpay razorpay;
  String orderID="";
  List<Map<String, dynamic>> orders=[
    {
     "name":"Matowork",
    "prodId": "silver",
    "description": "1500 pages for 28 days",
    "amount" : 350
  },
    {
      "name":"Matowork",
      "prodId": "gold",
      "description": "3000 pages for 28 days",
      "amount" : 500
    },
    {
      "name":"Matowork",
      "prodId": "diamond",
      "description": "28000 pages for 28 days",
      "amount" : 1000
    },
  ];

@override
void initState() {
  super.initState();
  razorpay=Razorpay();
  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }

@override
void dispose() {
  super.dispose();
 razorpay.clear();
}

void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  // Do something when payment succeeds
  print("SUCCESSFUL PAYMENT");
//  print(json.decode(response));
  print("${response.signature} ${response.paymentId} ${response.orderId}");

  http.Response res=await http.post(
      "https://matowork.com/user/verification",
      body: json.encode({
        "razorpay_order_id": response.orderId,
        "razorpay_payment_id": response.paymentId,
        "razorpay_payment_idrazorpay_signature":response.signature,
        "id": orderID,
        "username":Db.username
      }),
      headers: { "Content-Type" : "application/json" }
  );
    Map body=json.decode(res.body);
    try {
      if(res.statusCode == 200 && body['verification'].toString() == 'true') {
        print("Verification Successful");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return WelcomeScreen();
            }), ModalRoute.withName(''));
      } else {
        print("Verification Failed");
      }
    } catch(e) {
      print(e);
    }
  }
  void _handlePaymentError(PaymentFailureResponse response) {
  // Do something when payment fails
    print("Error: $response");
    }
    void _handleExternalWallet(ExternalWalletResponse response) {
  // Do something when an external wallet is selected
      }

void openCheckout(String name,int amount, String orderId, String prodId) async{
  //@TODO
  print(amount);
  print("$name $orderId");
  var box=await Hive.openBox("uname");
  await box.put("tier", prodId);
  String tier=prodId[0].toUpperCase();
  Db.tier=tier+prodId.substring(1);
  print(Db.tier);
  var options = {
    'key': 'rzp_test_S37YIf8khcCyPI',
    'amount': amount, //in the smallest currency sub-unit.
    'name': name,
    'order_id': orderId, // Generate order_id using Orders API
    'description': prodId, // change description
    'timeout': 60, // in seconds
    'prefill': {
      'email': Db.email
    }
  };

  try {
    razorpay.open(options);
  } catch (e) {
    debugPrint(e);
  }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
                  return WelcomeScreen();
                }), ModalRoute.withName(''));
          },
        ),
        title: Align(
          alignment: Alignment.center,
            widthFactor: 3,
            child: Text("Upgrade")
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple[100].withOpacity(0.35),
        child:
          ListView.builder(
          itemCount: orders.length,
              itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                height: 170,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Card(
//                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//                  elevation: 30,
                    color: Colors.white.withOpacity(0.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(orders[index]['prodId'].toString().toUpperCase(), style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20
                        ),),
                        SizedBox(height: 15,),
                        Text(orders[index]['description'], style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                        ),),
                        SizedBox(height: 25,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: RaisedButton(
                            color: Colors.deepPurple[400],
                            padding: EdgeInsets.all(17),
                            onPressed: () async {

                              Db.buildShowDialog(context);
                              http.Response res=await http.post(
                               ("https://matowork.com/user/orders"),
                                body: json.encode({ "amount": orders[index]['amount'], "prodId": orders[index]['prodId']}),
                                headers: { "Content-Type": "application/json" }
                              );
                              print(res.body);
                              print("Inside on checkout");
                              Map body= json.decode(res.body);
                              orderID=body["id"];
                              print("Response body: ");
                              print(body);
                              openCheckout(orders[index]['name'],orders[index]['amount'],body['id'],orders[index]['prodId']);
                            },

                            child: Text("Buy", style: TextStyle(
                              color: Colors.white
                            ),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
              }
          )
      ),
    );
  }
}
