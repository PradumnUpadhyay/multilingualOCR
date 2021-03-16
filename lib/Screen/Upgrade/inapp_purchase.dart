import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';
import 'package:matowork/Screen/Welcome/WelcomeScreen.dart';
import 'package:matowork/components/db.dart';

class InAppPurchases extends StatefulWidget {
  @override
  _InAppPurchasesState createState() => _InAppPurchasesState();
}

class _InAppPurchasesState extends State<InAppPurchases> {

  bool available=true;
  InAppPurchaseConnection _connection=InAppPurchaseConnection.instance;
  final Set<String> _prodIds={'multilingual_diamond','multilingual_gold','multilingual_silver'};

  List<ProductDetails> _products=[];
  List<PurchaseDetails> _purchases=[];


  @override
  void initState() {
    initStore();
    super.initState();
  }

  Future<void> initStore() async {
     available=await _connection.isAvailable();
    print("inside initstore");
    if(!available) print("No products found");
    else {
      print("Products found");
      await queryProducts();
      await _getPurchases();
      _verifyPurchase();
    }
  }

  Future<void> queryProducts() async {
     ProductDetailsResponse response=await _connection.queryProductDetails(_prodIds);

    setState(() {
      _products=response.productDetails;
    });
print('Products $_products');
  }

  Future<void> _getPurchases() async {
    QueryPurchaseDetailsResponse response= await _connection.queryPastPurchases();

    for(PurchaseDetails purchase in response.pastPurchases) {
      print("getPurhases method $purchase");
        if(purchase.pendingCompletePurchase) {
          _connection.completePurchase(purchase);
        }
    }

    setState(() {
      print("Past Purchases(getpurchases) ${response.pastPurchases}");
      _purchases=response.pastPurchases;
    });
  }

  PurchaseDetails _hasPurchased(String productId) {
    print("Purchases(hasPurchased) $_purchases");
    return _purchases.firstWhere((prod) => prod.productID == productId, orElse: ()=>null);
}

void _verifyPurchase() async {
  PurchaseDetails purchaseDetails;

      for(String productDetails in _prodIds) {
        purchaseDetails=_hasPurchased(productDetails);
      print("Inside for-loop $purchaseDetails");
        if(purchaseDetails!=null) break;
      }

    //@TODO: serverside verification and record consumable in database
    print(purchaseDetails);
//      _purchases=[];
    if(purchaseDetails!=null && purchaseDetails.status == PurchaseStatus.purchased) {
        await _connection.completePurchase(purchaseDetails);
        print("Purchase Details ${purchaseDetails.productID} ${purchaseDetails.purchaseID} ${purchaseDetails.verificationData.localVerificationData} ${purchaseDetails.verificationData.serverVerificationData}");

        Db.tier=purchaseDetails.productID.split("_")[1];
        print("Tier ${Db.tier}");

        if(json.decode(purchaseDetails.verificationData.localVerificationData)["acknowledged"] == true) {
          print("Payment Acknowledged");
          var res = await Db.client.post(
              "https://matowork.com/user/verification",
              body: json.encode(
                  {
                    "orderid": purchaseDetails.purchaseID,
                    "username": Db.username,
                    "tier": Db.tier
                  }),
              headers: {"Content-Type": "application/json"}
          );

         var box=await Hive.openBox('uname');
          box.put("tier", Db.tier);
          print(json.decode(res.body));
          if (res.statusCode == 200) _pagesConsumed(purchaseDetails);
        } else {
          print("Payment was not Acknowledged");
        }
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return WelcomeScreen();
            }), ModalRoute.withName(''));

    print("inside verify");
    }
}

Future<void> _buyProduct(ProductDetails prod) async{
    final PurchaseParam purchaseParam=PurchaseParam(productDetails: prod);
    print(purchaseParam);

   await _connection.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    print("product details $prod");
//    await _getPurchases();
//    _verifyPurchase();
    print("BuyProduct verify");
}

void _pagesConsumed(PurchaseDetails purchaseDetails) async{

    //@TODO: update state of consumable to backend db
      var res=await _connection.consumePurchase(purchaseDetails);
      print((res.debugMessage));
      print("inside consumed method");
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
        child: ListView.builder(itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: 170,
              child: Card(
                color: Colors.white.withOpacity(0.89),
                borderOnForeground: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_products[index].title.split('(')[0], style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20
                    ),),
                    SizedBox(height: 15,),
                    Text(_products[index].description,style: TextStyle(
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
                        onPressed: () async{
                         await _buyProduct(_products[index]);
                        print("Buy now button $_purchases");
//                          _pagesConsumed(_purchases[index]);
//                          _connection.completePurchase(purchase);
                        } ,
                        child: Text('Buy',style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        ,itemCount: _products.length,),
      ),
    );
  }
}
