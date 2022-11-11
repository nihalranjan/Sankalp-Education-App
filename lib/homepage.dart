import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sankalp/DetailsPage.dart';
import 'package:sankalp/New folder (2)/appdrawer.dart';
import 'package:sankalp/New folder (2)/live.dart';
import 'package:sankalp/New%20folder%20(2)/appdrawer.dart';
import 'package:sankalp/New%20folder%20(2)/profile.dart';
import 'package:sankalp/New%20folder%20(2)/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AssignmentView.dart';
import 'New folder (2)/setting.dart';
import 'name.dart';

bool Subscribe = false;
int correctans = 0;
int wrongans = 0;
int notans = 0;
int i = 1;
int _page = 0;
var _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: non_constant_identifier_names
  String Phoneno, name;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Phoneno = (prefs.getString('phoneno') ?? '');
      name = (prefs.getString('name') ?? '');
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          endDrawer: AppDrawer(),
          bottomNavigationBar: CurvedNavigationBar(
            index: 1,
            height: 46.0,
            items: <Widget>[
              GestureDetector(
                child: Icon(Icons.perm_identity_outlined, size: 30),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                uname: name,
                                uemail: Phoneno,
                              )));
                },
              ),
              GestureDetector(
                child: Icon(Icons.home_outlined, size: 30),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              GestureDetector(
                child: Icon(Icons.settings, size: 30),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsOnePage(
                                name: name,
                              )));
                },
              ),
            ],
            color: Colors.pink,
            buttonBackgroundColor: Colors.pinkAccent,
            backgroundColor: Colors.white,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
          body: MyHomePage(),
        ),
        // ignore: missing_return
        onWillPop: () async {
          deactivate();
          dispose();
          // ignore: unnecessary_statements
          SystemNavigator.pop();
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseFirestore.instance;
  String link, url;
  Future<String> getAddress({String id}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Activities').doc(id);

    await documentReference.get().then((snapshot) {
      if (snapshot.exists) {
        print('check');
        setState(() {
          link = snapshot.data()['url'];
        });
      }
    });
    return link;
  }

  Future<String> getAdd({String id}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Activities').doc(id);

    await documentReference.get().then((snapshot) {
      if (snapshot.exists) {
        print('check');
        setState(() {
          url = snapshot.data()['url'];
        });
      }
    });
    return url;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1 - 57,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () => _scaffoldKey.currentState.openDrawer(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.68, 0, 8, 0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Name()));
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 0, 15, 10),
            child: Row(
              children: [
                Text(
                  'Live Class',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 210,
            width: MediaQuery.of(context).size.width * 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream:
                        databaseReference.collection('liveclass').snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Text('PLease Wait')
                          : ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot course =
                                    snapshot.data.docs[index];
                                return CoursesItem(
                                  imgurl: course.data()['imgurl'],
                                  url: course.data()['url'],
                                );
                              },
                            );
                    }),
              ],
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 0, 15, 10),
            child: Row(
              children: [
                Text(
                  'Video Lectures',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1 - 280,
                ),
                Text(
                  'See All',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width * 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: databaseReference
                        .collection('upcomingclass')
                        .snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Text('PLease Wait')
                          : ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot course =
                                    snapshot.data.docs[index];
                                return UpcomingClass(
                                  subject: course.data()['subject'],
                                  timing: course.data()['timing'],
                                  iconurl: course.data()['iconurl'],
                                );
                              },
                            );
                    }),
              ],
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 0, 15, 10),
            child: Row(
              children: [
                Text(
                  'Activities',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1 - 220,
                ),
                Text(
                  'See All',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Container(
            height: 270,
            width: MediaQuery.of(context).size.width * 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                    child: Container(
                      height: 270,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pink,
                      ),
                      child: Column(
                        children: [
                          Container(
                              height: 190,
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/sankalpforsuccess-ded56.appspot.com/o/test.png?alt=media&token=f05c53d5-38f8-4692-91df-b4a7d48fa453',
                                  fit: BoxFit.fill,
                                ),
                              )),
                          Text(
                            'Test',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TestPage()));
                    }),
                GestureDetector(
                    child: Container(
                      height: 270,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pink,
                      ),
                      child: Column(
                        children: [
                          Container(
                              height: 190,
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/sankalpforsuccess-ded56.appspot.com/o/checklist.png?alt=media&token=1b4ddd7f-ace8-4084-a2c3-6354f2253c46',
                                  fit: BoxFit.fill,
                                ),
                              )),
                          Text(
                            'Assignment',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      await getAddress(id: 'assignment');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PDFViewerFromUrl(
                                    url: link,
                                  )));
                    }),
                GestureDetector(
                  child: Container(
                    height: 270,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink,
                    ),
                    child: Column(
                      children: [
                        Container(
                            height: 190,
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/sankalpforsuccess-ded56.appspot.com/o/strategy.png?alt=media&token=ba713505-166d-4ff1-a821-39997daa3f7e',
                                fit: BoxFit.fill,
                              ),
                            )),
                        Text(
                          'Solutions',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await getAdd(id: 'solution');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFViewerFromUrl(
                                  url: url,
                                )));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CoursesItem extends StatelessWidget {
  final String imgurl;
  final String url;
  CoursesItem({
    this.imgurl,
    this.url,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 220,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        width: MediaQuery.of(context).size.width * 1 - 20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage('$imgurl'),
              fit: BoxFit.fill,
            )),
        child: GestureDetector(
          child: Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
      onTap: () {
        if (url != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Live(
                        url: '$url',
                      )));
        }
      },
    );
  }
}

class UpcomingClass extends StatelessWidget {
  final String subject;
  final String timing;
  final String iconurl;
  UpcomingClass({this.subject, this.timing, this.iconurl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: 120,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: 260,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.lightBlueAccent),
          child: Row(
            children: [
              Container(
                width: 70,
                margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                child: Image.network(
                  '$iconurl',
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(3, 27.5, 10, 10),
                    child: AutoSizeText(
                      '$subject',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(3, 0, 10, 0),
                    child: AutoSizeText(
                      '$timing',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          )),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detailspage(
                      chapter: subject,
                    )));
      },
    );
  }
}
