import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  WebViewExample({Key key, this.title}) : super(key: key);
  final String title;
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl:
          'https://firebasestorage.googleapis.com/v0/b/sankalpforsuccess-ded56.appspot.com/o/Admit%20Card.pdf?alt=media&token=3eb9c954-d85c-4a0d-9bdf-a513009bbe16',
    );
  }
}
