import 'package:flutter/material.dart';
import 'package:sankalp/authscreen.dart';

import 'name.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Authentication',
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => Name(),
        '/loginpage': (BuildContext context) => MyApp(),
      },
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FirebasePhoneAuth(
        theamColor: Colors.redAccent,
        title: "",
        imgPath: "assets/images/islogome.png",
        redirectTo: "/homepage",
      ),
    );
  }
}
