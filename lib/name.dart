import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sankalp/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username;

class Name extends StatefulWidget {
  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  String name;
  FirebaseAuth _auth = FirebaseAuth.instance;
  profile() async {
    try {
      final User currentUser = await _auth.currentUser;
      await currentUser.updateProfile(
        displayName: this.name,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', this.name);
    } catch (e) {
      print(e);
      final User currentUser = await _auth.currentUser;
      print(currentUser.displayName);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/islogome.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Welcome',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "Enter Full Name",
                          hoverColor: Colors.orange,
                          fillColor: Colors.orange,
                          focusColor: Colors.orange,
                          contentPadding:
                              new EdgeInsets.fromLTRB(20.0, 10.0, 100.0, 10.0),
                          border: OutlineInputBorder(),
                          hintText: 'Full Name'),
                      onChanged: (value) {
                        this.name = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                    child: ElevatedButton.icon(
                      label: Text('Go Next'),
                      icon: Icon(
                        Icons.double_arrow_outlined,
                        color: Colors.pink,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        print('Pressed');
                        await profile();
                        final User currentUser = await _auth.currentUser;
                        print(currentUser.displayName);
                        dispose();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
