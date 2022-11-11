import 'package:flutter/material.dart';
import 'package:sankalp/New folder (2)//profile.dart';
import 'package:sankalp/New folder (2)//setting.dart';
import 'package:sankalp/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homepage.dart';
import '../name.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String phone, name;
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = (prefs.getString('phoneno') ?? '');
      name = (prefs.getString('name') ?? '');
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(250)),
      child: new Drawer(
        child: Drawer(
          child: ListView(
            children: <Widget>[
              ProfileHeader(
                avatar: AssetImage('assets/images/reading.png'),
                coverImage: AssetImage('assets/images/doctors.png'),
                title: phone,
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 0,
                    child: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Name()));
                    },
                  )
                ],
              ),
              Card(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ...ListTile.divideTiles(
                            color: Colors.grey,
                            tiles: [
                              ListTile(
                                title: Text(
                                  "Home",
                                  style: TextStyle(fontSize: 20),
                                ),
                                trailing: FlatButton(
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.orangeAccent.shade400,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Profile",
                                  style: TextStyle(fontSize: 20),
                                ),
                                trailing: FlatButton(
                                  child: Icon(
                                    Icons.book,
                                    color: Colors.orangeAccent.shade400,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  uemail: this.phone,
                                                  uname: this.name,
                                                )));
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Renew Subscription",
                                  style: TextStyle(fontSize: 20),
                                ),
                                trailing: FlatButton(
                                  child: Icon(
                                    Icons.payment_outlined,
                                    color: Colors.orangeAccent.shade400,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Payment()));
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Settings",
                                  style: TextStyle(fontSize: 20),
                                ),
                                trailing: FlatButton(
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.orangeAccent.shade400,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsOnePage(
                                                  name: this.name,
                                                )));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
