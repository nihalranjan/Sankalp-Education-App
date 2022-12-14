import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebasePhoneAuth extends StatefulWidget {
  FirebasePhoneAuth(
      {Key key,
      @required this.imgPath,
      @required this.title,
      @required this.redirectTo,
      @required this.theamColor})
      : super(key: key);
  final String imgPath;
  final String title;
  final Color theamColor;
  final String redirectTo;

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<FirebasePhoneAuth> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exception) {
            print('${exception.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'OTP'),
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              RaisedButton(
                textColor: Colors.black,
                color: Colors.orange,
                child: Text('Done'),
                onPressed: () {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User user = auth.currentUser;
                  if (user != null) {
                    addStringToSF();
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(widget.redirectTo);
                  } else {
                    signIn();
                  }
                },
              )
            ],
          );
        });
  }

  addStringToSF() async {
    final User currentUser = await _auth.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneno', this.phoneNo);
    prefs.setString('uid', currentUser.uid);
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      var credential2 = credential;
      final User user = (await _auth.signInWithCredential(credential2)).user;
      final User currentUser = await _auth.currentUser;
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(widget.redirectTo);
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: widget.theamColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(widget.title,
            style: TextStyle(
                fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: new Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(125.0),
                  bottomLeft: Radius.circular(95.0)),
              color: Colors.white),
          height: MediaQuery.of(context).size.height - 110.0,
          width: MediaQuery.of(context).size.width,

          /* add child content here */
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 130.0,
                width: 130.0,
                child: new Image.asset(widget.imgPath),
              ),
              SizedBox(
                height: 0.0,
              ),
              new Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.title,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        color: Colors.black),
                  ),
                  SizedBox(height: 0.0),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "Mobile No",
                          contentPadding:
                              new EdgeInsets.fromLTRB(20.0, 10.0, 100.0, 10.0),
                          border: OutlineInputBorder(),
                          hintText: ' Eg. +918698502533'),
                      onChanged: (value) {
                        this.phoneNo = value;
                      },
                    ),
                  ),
                  (errorMessage != ''
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    color: Color.fromRGBO(231, 76, 60, 50.0),
                    onPressed: () {
                      verifyPhone();
                    },
                    child: Text('Verify'),
                  ),
                  SizedBox(
                    height: 30.0,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
