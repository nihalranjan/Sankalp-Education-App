import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sankalp/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPage extends StatefulWidget {
  int wrongans;
  int correctans;
  int number;
  ResultPage({
    Key key,
    @required this.wrongans,
    this.correctans,
    this.number,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> sendChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String phone = prefs.getString('phoneno');
    String name = prefs.getString('name');
    await _firestore.collection("testresult").add({
      'text': '${widget.correctans} / ${widget.number}',
      'timestamp': FieldValue.serverTimestamp(),
      'phone': phone,
      'name': name,
    });
    await _firestore
        .collection("user")
        .doc('userid')
        .collection(phone)
        .doc('detail')
        .collection('test')
        .add({
      'text': '${widget.correctans} / ${widget.number}',
      'timestamp': FieldValue.serverTimestamp(),
      'phone': phone,
      'name': name,
    });
  }

  @override
  Widget build(BuildContext context) {
    int correct = 0;

    final TextStyle titleStyle = TextStyle(
        color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Result'),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.pink],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Total Questions", style: titleStyle),
                  trailing: Text('${widget.number}', style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Score", style: titleStyle),
                  trailing: Text("${widget.correctans / widget.number * 100}%",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Correct Answers", style: titleStyle),
                  trailing: Text("${widget.correctans}/${widget.number}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Incorrect Answers", style: titleStyle),
                  trailing: Text("${widget.wrongans}/${widget.number}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.deepPurple.withOpacity(0.8),
                    textColor: Colors.white,
                    child: Text("Go to Home"),
                    onPressed: () {
                      setState(() {
                        wrongans = 0;
                        correctans = 0;
                      });
                      sendChat();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => HomePage()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
