import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sankalp/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time/time.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../payment.dart';

double i = 1;
String urlop = 'https://www.youtube.com/watch?v=BstW5GDKVMU';
bool subscribe = false;
String phone;
bool hdr = false;

class Live extends StatefulWidget {
  final String url;
  Live({Key key, this.url});
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  @override
  // ignore: must_call_super
  void initState() {
    setState(() {
      urlop = '${widget.url}';
      i = 1;
    });
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = (prefs.getString('phoneno') ?? '');
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube Player Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(color: Color(0xFFFF0000)),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MyHomePage(
        title: 'Youtube Player Demo',
        url: '${widget.url}',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.url}) : super(key: key);
  final String title;
  final String url;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(urlop),
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      forceHD: hdr,
      disableDragSeek: false,
    ),
  );

  void doSomething() async {
    await 150.seconds.delay;
    _showThankYouDialog();
    _controller.pause();
    // Do the other things
  }

  Future<void> getSpecie() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('user')
        .doc('userid')
        .collection(phone)
        .doc('subscription');

    await documentReference.get().then((snapshot) {
      if (snapshot.exists) {
        print('check');
        DateTime _timestamp = snapshot.data()['date'].toDate();
        var diff = DateTime.now().difference(_timestamp).inDays.toInt();
        if (diff <= 30) {
          setState(() {
            print('subscription true');
            subscribe = true;
          });
        }
        if (subscribe == false) {
          doSomething();
        }
      } else {
        doSomething();
      }
    });
  }

  void listener() {
    if (i == 1) {
      i = i + 1;
      if (mounted) {
        getSpecie();
      }
    }
  }

  @override
  void deactivate() {
    // This pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          body: Container(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SafeArea(
                    child: YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          progressIndicatorColor: Color(0xFFFF0000),
                          showVideoProgressIndicator: true,
                          controller: _controller,
                          onReady: () {
                            _controller.addListener(listener);
                          },
                          topActions: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Text(
                              'Sankalp 4 Success',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.hd_outlined,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  hdr = true;
                                });
                              },
                            ),
                          ],
                          progressColors: const ProgressBarColors(
                            playedColor: Color(0xFFFF0000),
                            handleColor: Color(0xFFFF4433),
                          ),
                        ),
                        builder: (context, player) {
                          return Column(
                            children: [
                              // some widgets
                              player,
                              //some other widgets
                            ],
                          );
                        }),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.white,
                    child: DoubtChat(),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
      // ignore: missing_return
      onWillPop: () async {},
    );
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        void close() {
          super.deactivate();
          super.dispose();
        }

        return WillPopScope(
          child: AlertDialog(
            title: Text("Get Subscription"),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  Center(child: Text("Please get subscription")),
                  Center(
                      child: Text(
                          "Please provide same number as the registered in our app or specify it in description.")),
                  Center(
                      child: Text(
                          "Subscription will be given to the number used in payment in dispute conditions.")),
                  RaisedButton(
                      child: Container(
                        child: Text('Buy now'),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        close();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Payment()));
                      })
                ],
              ),
            ),
          ),
          onWillPop: () {
            Navigator.pop(context);
            close();

            return Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        );
      },
    );
  }
}

class DoubtChat extends StatefulWidget {
  @override
  _DoubtChatState createState() => _DoubtChatState();
}

class _DoubtChatState extends State<DoubtChat> {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String userName;
  String userid;
  @override
  void initState() {
    super.initState();
    getStringValuesSF().then((uid) {
      setState(() {
        userid = uid;
      });
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      color: antiFlashWhite,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              //margin: EdgeInsets.symmetric(horizontal: 5),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("messages")
                      .orderBy(
                        "timestamp",
                      )
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Text('PLease Wait')
                        : ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot course =
                                  snapshot.data.docs[index];
                              return Message(
                                  user: course.data()['phone'],
                                  text: course.data()['text'],
                                  timestamp: course.data()['timestamp'],
                                  mine: userid == course.data()["uid"]);
                            },
                          );
                  }),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      onSubmitted: (value) => sendChat(),
                      controller: messageController,
                      cursorColor: cornFlowerBlue,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        filled: true,
                        fillColor: antiFlashWhite,
                        hintText: "Type a message",
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.paperPlane,
                    color: Colors.black,
                  ),
                  onPressed: sendChat,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String uid = prefs.getString('uid');
    if (messageController.text.length > 0) {
      await _firestore.collection("messages").add({
        'text': messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': uid,
        'phone': phone,
      });
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    }
  }
}

class Message extends StatelessWidget {
  final String user;
  final String text;
  final bool mine;
  final timestamp;
  Message({Key key, this.user, this.text, this.mine, this.timestamp})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            user != null ? user : '1234',
            style: TextStyle(
              color: mine ? Colors.black : royalBlue,
              fontSize: 13,
              fontFamily: 'Montserrat',
            ),
          ),
          Material(
            color: mine ? royalBlue : Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Text(
                text != null ? text : '1234',
                style: TextStyle(
                  color: mine ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String

  String uid = prefs.getString('uid');
  return uid;
}

Color royalBlue = Color(0xff6f6ed6),
    cornFlowerBlue = Color(0xff7d7cda),
    buff = Color(0xfff9dd7a),
    antiFlashWhite = Color(0xffebeef3);
