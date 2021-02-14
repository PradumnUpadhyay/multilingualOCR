//import 'package:flutter/material.dart';
//import 'package:in_app_purchase/in_app_purchase.dart';
//import 'dart:io';
//import 'dart:async';
//
//final List<String> prodIds=["mulitilingual_silver","mulitilingual_gold","mulitilingual_diamond"];
//
//class InAppPurchases extends StatefulWidget {
//  @override
//  _InAppPurchasesState createState() => _InAppPurchasesState();
//}
//
//class _InAppPurchasesState extends State<InAppPurchases> {
//
//  bool exists=true;
//
//  InAppPurchaseConnection _inAppPurchaseConnection= InAppPurchaseConnection.instance;
//
//  List<ProductDetails> _products=[];
//  List<PurchaseDetails> _purchases=[];
//
//  StreamSubscription _streamSubscription;
//
//
//  @override
//  void initState() {
//    super.initState();
//    _initialize();
//  }
//
//  @override
//  void dispose(){
//    _streamSubscription.cancel();
//    super.dispose();
//  }
//
//  void _initialize() async {
//      exists=await _inAppPurchaseConnection.isAvailable();
//
//      if(exists) {
//        await _getProducts();
//        await _getPurchases();
//
//        _verifyPurchase();
//      }
//  }
//
//  Future<void> _getProducts() async {
//      Set<String> id= Set.from(prodIds);
//
//      ProductDetailsResponse _productDetails=await _inAppPurchaseConnection.queryProductDetails(id);
//
//      setState(() {
//        _products=_productDetails.productDetails;
//      });
//  }
//
//  Future<void> _getPurchases() async{
//
//    QueryPurchaseDetailsResponse _queryPurchase=await _inAppPurchaseConnection.queryPastPurchases();
//
//    for(PurchaseDetails purchase in _queryPurchase.pastPurchases) {
//          final pending= purchase.pendingCompletePurchase;
//
//          if(pending) {
//            InAppPurchaseConnection.instance.completePurchase(purchase);
//          }
//    }
//
//    setState(() {
//      _purchases=_queryPurchase.pastPurchases;
//    });
//
//  }
//
//  PurchaseDetails _hasPurchased(String productId) {
//    return _purchases.firstWhere((purchase) => purchase.productID == productId, orElse: () => null);
//  }
//
//  _verifyPurchase() {
//    PurchaseDetails purchaseDetails= _hasPurchased();
//
//    // server logic to implement
//
//    if(purchaseDetails != null && purchaseDetails.status == PurchaseStatus.purchased) {
//      // logic
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
