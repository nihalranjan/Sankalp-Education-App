import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sankalp/New folder (2)/result page.dart';

import '../homepage.dart';

int ques;
int correctans = 0;
int wrongans = 0;
int notans = 0;
String ispic;
List<int> answers = [
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
  4,
];

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final databaseReference = FirebaseFirestore.instance;
  @override
  void dispose() {
    super.dispose();
  }

  void getYou() {
    FirebaseFirestore.instance
        .collection("quiz")
        .get()
        .then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      setState(() {
        ques = querySnapshot.docs.length;
      });
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
          ),
          body: Container(
            color: Colors.deepPurple,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 1 - 150,
                  width: MediaQuery.of(context).size.width * 1,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: databaseReference.collection('quiz').snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Text('PLease Wait')
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot course =
                                      snapshot.data.docs[index];
                                  return Column(
                                    children: [
                                      CoursesItem(
                                        question: course.data()['question'],
                                        optionone: course.data()['optionone'],
                                        optiontwo: course.data()['optiontwo'],
                                        optionthree:
                                            course.data()['optionthree'],
                                        optionfour: course.data()['optionfour'],
                                        correctopt: course.data()['correctopt'],
                                        height: course.data()['height'],
                                        imgurl: course.data()['imgurl'],
                                        number: index + 1,
                                      ),
                                    ],
                                  );
                                },
                              );
                      }),
                ),
                RaisedButton(
                  color: Colors.orange,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    getYou();
                    setState(() {
                      wrongans = 0;
                      correctans = 0;
                    });
                    final answersMap = answers.asMap();
                    for (var i = 0; i < 80; i++) {
                      if (answersMap[i] == 1) {
                        correctans++;
                      }
                      if (answersMap[i] == 0) {
                        wrongans++;
                      }
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          wrongans: wrongans,
                          correctans: correctans,
                          number: ques,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // ignore: missing_return
        onWillPop: () async {
          _showThankYouDialog();
          // ignore: unnecessary_statements
        });
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "Did you want to exit the test, you current progress will not be saved"),
          content: Container(
            height: 100,
            child: Row(
              children: [
                RaisedButton(
                    child: Container(
                      child: Text('Back'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                RaisedButton(
                    child: Container(
                      child: Text('Exit'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}

enum SingingCharacter { lafayette, jefferson, hello, world, you }

class CoursesItem extends StatefulWidget {
  final String question;
  final String optionone;
  final String optiontwo;
  final String optionthree;
  final String optionfour;
  final String correctopt;
  final String imgurl;
  final int number;
  final int height;
  CoursesItem(
      {Key key,
      @required this.question,
      this.optionfour,
      this.optionone,
      this.optionthree,
      this.optiontwo,
      this.number,
      this.correctopt,
      this.height,
      this.imgurl})
      : super(key: key);

  @override
  _CoursesItemState createState() => _CoursesItemState();
}

class _CoursesItemState extends State<CoursesItem> {
  final databaseReference = FirebaseFirestore.instance;
  SingingCharacter _character = SingingCharacter.lafayette;
  String pic;

  @override
  Widget build(BuildContext context) {
    double cardheight = double.parse('${widget.height}');
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: cardheight,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  Expanded(
                    child: Text(
                      '${widget.question}',
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (widget.imgurl != null) ...[
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                          height: 150,
                          child: Center(
                            child: Image(
                              image: NetworkImage(
                                '${widget.imgurl}',
                              ),
                              fit: BoxFit.fill,
                            ),
                          )),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeroPhotoViewRouteWrapper(
                              imageProvider: NetworkImage(
                                widget.imgurl,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  RadioListTile<SingingCharacter>(
                    title: Text('${widget.optionone}'),
                    value: SingingCharacter.hello,
                    groupValue: _character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        _character = value;
                        var questionindex = int.parse('${widget.number}');
                        var option = '${widget.optionone}';
                        var correctoption = '${widget.correctopt}';
                        if (option == correctoption) {
                          answers.removeAt(questionindex);
                          answers.insert(questionindex, 1);
                        } else {
                          answers.removeAt(questionindex);
                          answers.insert(questionindex, 0);
                        }
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: Text('${widget.optiontwo}'),
                    value: SingingCharacter.world,
                    groupValue: _character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        _character = value;
                        var questionindex = int.parse('${widget.number}');
                        var optiontwo = '${widget.optiontwo}';
                        var correctoption = '${widget.correctopt}';
                        if (optiontwo == correctoption) {
                          answers.removeAt(questionindex);
                          answers.insert(questionindex, 1);
                        } else {
                          answers.removeAt(questionindex);
                          answers.insert(questionindex, 0);
                        }
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: Text('${widget.optionthree}'),
                    value: SingingCharacter.you,
                    groupValue: _character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        _character = value;
                        var questionindex = int.parse('${widget.number}');
                        var optionthree = '${widget.optionthree}';
                        var correctoption = '${widget.correctopt}';
                        if (optionthree == correctoption) {
                          answers.removeAt(questionindex);
                          answers.insert(questionindex, 1);
                        } else {
                          answers.removeAt(questionindex);
                          answers.insert(questionindex, 0);
                        }
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: Text('${widget.optionfour}'),
                    value: SingingCharacter.jefferson,
                    groupValue: _character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        _character = value;
                        var questionindex = int.parse('${widget.number}');
                        var optionfour = '${widget.optionfour}';
                        var correctoption = '${widget.correctopt}';
                        if (optionfour == correctoption) {
                          answers.removeAt(questionindex);
                          answers.insert(questionindex, 1);
                        } else {
                          answers.removeAt(questionindex);
                          answers.insert(questionindex, 0);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueGrey,
                child: Text(
                  '${widget.number}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  HeroPhotoViewRouteWrapper({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
