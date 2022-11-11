import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sankalp/homepage.dart';
import 'package:webview_flutter/webview_flutter.dart';

String url;

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState() {
    super.initState();
    urlGetter();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> urlGetter() async {
    final databaseReference = FirebaseFirestore.instance;

    databaseReference.collection('paymenturl');

    await databaseReference
        .collection('paymenturl')
        .doc('url')
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        print('check');
        setState(() {
          url = snapshot.data()['url'];
        });

        print(url);
      }
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Title(
            color: Colors.blueGrey,
            child: Text(
              'Payment',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ),
        body: Container(
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: url,
          ),
        ),
      ),
      onWillPop: () {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
    );
  }
}
