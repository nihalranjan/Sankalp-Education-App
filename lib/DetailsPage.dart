import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sankalp/New folder (2)/live.dart';

class Detailspage extends StatefulWidget {
  final String chapter;
  Detailspage({Key key, this.chapter}) : super(key: key);
  @override
  _DetailspageState createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  final databaseReference = FirebaseFirestore.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.blueGrey,
          child: Text(
            '${widget.chapter}',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: databaseReference
                .collection('upcomingclass')
                .doc('${widget.chapter}')
                .collection('chapter')
                .snapshots(),
            // ignore: missing_return
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Text('PLease Wait')
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot course = snapshot.data.docs[index];
                        return Chapter(
                          subject: course.data()['subject'],
                          chapter: '${widget.chapter}',
                        );
                      },
                    );
            }),
      ),
    );
  }
}

class Chapter extends StatefulWidget {
  final String subject;
  final String chapter;
  Chapter({Key key, this.subject, this.chapter}) : super(key: key);
  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  final databaseReference = FirebaseFirestore.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(0, 0, 15, 10),
            width: MediaQuery.of(context).size.width * 1 - 50,
            child: Row(
              children: [
                Text(
                  '${widget.subject}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 220,
            child: StreamBuilder<QuerySnapshot>(
                stream: databaseReference
                    .collection('upcomingclass')
                    .doc('${widget.chapter}')
                    .collection('chapter')
                    .doc('${widget.subject}')
                    .collection('topic')
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
                            DocumentSnapshot course = snapshot.data.docs[index];
                            return Topic(
                                url: course.data()['url'],
                                thumbnail: course.data()['thumbnail']);
                          },
                        );
                }),
          ),
        ],
      ),
    );
  }
}

class Topic extends StatefulWidget {
  final String url;
  final String thumbnail;
  Topic({Key key, this.url, this.thumbnail}) : super(key: key);
  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 160,
        margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
        width: MediaQuery.of(context).size.width * 1 - 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage('${widget.thumbnail}'),
              fit: BoxFit.fill,
            )),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Live(
                      url: '${widget.url}',
                    )));
      },
    );
  }
}
