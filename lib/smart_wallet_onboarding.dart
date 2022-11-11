import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:sankalp/authservice.dart';

class SmartWalletOnboardingPage extends StatefulWidget {
  @override
  _SmartWalletOnboardingPageState createState() =>
      _SmartWalletOnboardingPageState();
}

class _SmartWalletOnboardingPageState extends State<SmartWalletOnboardingPage> {
  final pages = [
    PageViewModel(
      pageColor: Color(0xff452650),
      bubbleBackgroundColor: Colors.indigo,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Welcome to Sankalp Education'),
          Text(
            'Plan your study, anytime, anywhere.',
            style: TextStyle(color: Colors.white70, fontSize: 16.0),
          ),
        ],
      ),
      mainImage: Image.asset(
        'assets/images/inter.jpg',
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.white),
    ),
    PageViewModel(
      pageColor: Color(0xff009688),
      iconColor: null,
      bubbleBackgroundColor: Colors.indigo,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Daily Test and Assignment'),
          Text(
            'Tests and assignment on the regular basis.',
            style: TextStyle(color: Colors.black54, fontSize: 16.0),
          ),
        ],
      ),
      mainImage: Image.asset(
        'assets/images/tes.jpg',
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black),
    ),
    PageViewModel(
      pageColor: Color(0xff3F51B5),
      iconColor: null,
      bubbleBackgroundColor: Colors.indigo,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Unleash your full potential'),
          Text(
            'Expand ypur limits with us by our regular support.',
            style: TextStyle(color: Colors.white70, fontSize: 16.0),
          ),
        ],
      ),
      mainImage: Image.asset(
        'assets/images/last.jpg',
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.white),
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Stack(
          children: <Widget>[
            IntroViewsFlutter(
              pages,
              onTapDoneButton: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              showSkipButton: false,
              doneText: Text(
                "Get Started",
              ),
              pageButtonsColor: Colors.white,
              pageButtonTextStyles: new TextStyle(
                // color: Colors.indigo,
                fontSize: 25.0,
                fontFamily: "Regular",
              ),
            ),
            Positioned(
                top: 40.0,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: Image.asset(
                  'assets/images/log.jpeg',
                  width: 100,
                )),
          ],
        ),
      ),
    );
  }
}
