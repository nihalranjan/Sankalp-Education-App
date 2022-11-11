import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';
import 'smart_wallet_onboarding.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
bool CheckValue;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  CheckValue = prefs.containsKey('uid');
  Widget _defaultHome = new SmartWalletOnboardingPage();
  if (CheckValue == true) {
// User is logged in
    _defaultHome = new HomePage();
  }

// Run app!
  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
// Set routes for using the Navigator.
      '/homepage': (BuildContext context) => new HomePage(),
      '/loginpage': (BuildContext context) => new SmartWalletOnboardingPage()
    },
  ));
}
