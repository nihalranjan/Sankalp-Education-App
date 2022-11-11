import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sankalp/name.dart';

class ProfilePage extends StatefulWidget {
  final String uemail;
  final String uname;

  ProfilePage({
    Key key,
    @required this.uname,
    this.uemail,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final databaseReference = FirebaseFirestore.instance;
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                avatar: AssetImage('assets/images/reading.png'),
                coverImage: AssetImage('assets/images/doctors.png'),
                title: "${widget.uname}",
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
              const SizedBox(height: 10.0),
              UserInfo(uemail: '${widget.uemail}'),
              StreamBuilder<QuerySnapshot>(
                  stream: databaseReference
                      .collection('user')
                      .doc('userid')
                      .collection('${widget.uemail}')
                      .doc('detail')
                      .collection('payment')
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Text('No Payment')
                        : ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot course =
                                  snapshot.data.docs[index];
                              return PaymentHist(
                                date: course.data()['date'],
                                amount: course.data()['amount'],
                              );
                            },
                          );
                  }),
              Container(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: databaseReference
                      .collection('user')
                      .doc('userid')
                      .collection('${widget.uemail}')
                      .doc('detail')
                      .collection('test')
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Text('No Test Results')
                        : ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot course =
                                  snapshot.data.docs[index];
                              return PaymentHist(
                                date: course.data()['timestamp'].toString(),
                                amount: course.data()['text'],
                              );
                            },
                          );
                  }),
            ],
          ),
        ));
  }
}

class PaymentHist extends StatefulWidget {
  final String date;
  final String amount;
  PaymentHist({
    Key key,
    @required this.date,
    this.amount,
  }) : super(key: key);

  @override
  _PaymentHistState createState() => _PaymentHistState();
}

class _PaymentHistState extends State<PaymentHist> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.subscriptions_rounded),
      title: Text("Last done : ${widget.date}"),
      subtitle: Text("           ${widget.amount}"),
    );
  }
}

class UserInfo extends StatefulWidget {
  final String uemail;

  UserInfo({
    Key key,
    @required this.uemail,
  }) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "User Information",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
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
                            leading: Icon(Icons.phone),
                            title: Text("Phone"),
                            subtitle: Text("${widget.uemail}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text("About Me"),
                            subtitle: Text(
                                "A  former student looking forward for brightness."),
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
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      @required this.coverImage,
      @required this.avatar,
      @required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      @required this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image,
        ),
      ),
    );
  }
}
