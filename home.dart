import 'package:aqua_bot/routes/maps.dart';
import 'package:aqua_bot/routes/tempReports.dart';
import 'package:aqua_bot/routes/reports.dart';
import 'package:aqua_bot/widgets/progress.dart';
import 'package:circular_progress_gauge_odo/odo.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  List<FlSpot> tdsPlot = [];
  String status = '';
  double _value = 0;
  double ph = 0;
  String phTime = '';
  String tempTime = '';
  String ductTime = '';
  double temp = 0;
  double weight = 0;
  @override
  void initState() {
    getstatus();
    getvalue();
    getph();
    gettemp();
    getweight();
    _firebaseMessaging.getToken().then((token) {
      print("tokeen : " + token);
    });
    executeMessage();
    super.initState();
  }

  final ThemeData somTheme = new ThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.black,
      backgroundColor: Colors.grey);
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.location_on),
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return MapsPage();
            }));
          },
        ),
        appBar: AppBar(
          title:
              Stack(alignment: AlignmentDirectional.center, children: <Widget>[
            Opacity(
              child: Image.asset(
                'img/logo.png',
              ),
              opacity: 0.5,
            ),
            Opacity(
              child: Text("AQUABOT"),
              opacity: 1.0,
            )
          ]),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'img/logo.png',
                width: 50,
                height: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  ('status:$status'),
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'Roboto', color: Colors.green),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'SPEEDOMETER',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Odo(
                      displayBackgroundColor: Colors.grey[850],
                      displayBorderColor: Colors.transparent,
                      bottomCircleColor: Colors.grey[850],
                      displayColor: Colors.transparent,
                      indicatorColor: Colors.white,
                      size: 300.0,
                      innerCircleColor: Colors.grey[850],
                      minRangeColor: Colors.green,
                      midRangeColor: Colors.yellow,
                      maxRangeColor: Colors.red,
                      inputValue: _value / 40.0,
                      rangeMinValue: 0.0,
                      rangeMaxValue: 40.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'pH',
                        style: TextStyle(fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("14pH"),
                      ),
                      Container(
                        height: 300,
                        width: 50,
                        child: GestureDetector(
                            child: FAProgressBar(
                              currentValue: (ph * 10).toInt(),
                              maxValue: 140,
                              size: 10,
                              animatedDuration:
                                  const Duration(milliseconds: 400),
                              direction: Axis.vertical,
                              verticalDirection: VerticalDirection.up,
                              borderRadius: 20,
                              backgroundColor: Colors.white,
                              progressColor: Colors.blue,
                              changeColorValue: 90,
                              changeProgressColor: Colors.red,
                              displayText: '$ph',
                            ),
                            onLongPress: () {
                              bool isNormal = ph < 8.0;
                              showDialog<Null>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('pH Indicators'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            isNormal
                                                ? Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CircleAvatar(
                                                          radius: 10,
                                                          backgroundColor:
                                                              Colors.blue,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('Normal'),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CircleAvatar(
                                                          radius: 10,
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('Risk'),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            onDoubleTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return Report();
                              }));
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('0pH'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(phTime),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Temperature',
                        style: TextStyle(fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("100°C"),
                      ),
                      Container(
                        height: 300,
                        width: 50,
                        child: GestureDetector(
                            child: FAProgressBar(
                                maxValue: 100,
                                size: 50,
                                borderRadius: 20,
                                progressColor: Colors.red,
                                backgroundColor: Colors.white,
                                currentValue: (temp).toInt(),
                                displayText: '$temp',
                                direction: Axis.vertical,
                                verticalDirection: VerticalDirection.up),
                            onLongPress: () {
                              showDialog<Null>(
                                  context: context,
                                  barrierDismissible:
                                      true, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Temperature Indicators'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('Normal'),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.brown,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('Risk'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            onDoubleTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return tempReport();
                              }));
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('0 °C'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(tempTime),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Duct',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("25kg"),
                      ),
                      Container(
                        height: 300,
                        width: 50,
                        child: GestureDetector(
                          child: FAProgressBar(
                            maxValue: 250,
                            borderRadius: 20,
                            size: 40,
                            progressColor: Colors.brown,
                            backgroundColor: Colors.white,
                            currentValue: (weight * 10).toInt(),
                            displayText: '$weight',
                            animatedDuration: const Duration(milliseconds: 800),
                            direction: Axis.vertical,
                            verticalDirection: VerticalDirection.up,
                          ),
                          onLongPress: () {
                            showDialog<Null>(
                                context: context,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Weight Indicators'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.brown,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text('Normal'),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text('Over weight'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('0kg'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(ductTime),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            )
          ],
        ));
  }

  getvalue() async {
    FirebaseDatabase db = FirebaseDatabase.instance;
    var data = db.reference().child('bot/acc').limitToLast(1);
    data.onValue.listen((Event onData) {
      double s = 0;
      Map<dynamic, dynamic> a = onData.snapshot.value;
      print(a.toString());
      a.forEach((key, value) {
        s = value['value'] * 1.0;
      });
      setState(() {
        _value = s;
      });
    });
  }

  getph() async {
    FirebaseDatabase db = FirebaseDatabase.instance;
    var data = db.reference().child('bot/ph').limitToLast(1);
    data.onValue.listen((Event onData) {
      String t;
      double s = 0;
      Map<dynamic, dynamic> a = onData.snapshot.value;
      print(a.toString());
      a.forEach((key, value) {
        s = value['value'] * 1.0;

        t = DateTime.fromMillisecondsSinceEpoch(value['time'])
            .toString()
            .split(' ')
            .last
            .split('.')
            .first;
      });
      setState(() {
        ph = s;
        phTime = t;
      });
    });
  }

  gettemp() async {
    FirebaseDatabase db = FirebaseDatabase.instance;
    var data = db.reference().child('bot/temp').limitToLast(1);
    data.onValue.listen((Event onData) {
      double s = 0;
      String t;
      Map<dynamic, dynamic> a = onData.snapshot.value;
      print(a.toString());
      a.forEach((key, value) {
        s = value['value'] * 1.0;
        t = DateTime.fromMillisecondsSinceEpoch(value['time'])
            .toString()
            .split(' ')
            .last
            .split('.')
            .first;
      });
      setState(() {
        temp = s;
        tempTime = t;
      });
    });
  }

  getweight() async {
    FirebaseDatabase db = FirebaseDatabase.instance;
    var data = db.reference().child('bot/weight').limitToLast(1);
    data.onValue.listen((Event onData) {
      double s = 0;
      String t;
      Map<dynamic, dynamic> a = onData.snapshot.value;
      print(a.toString());
      a.forEach((key, value) {
        s = value['value'] * 1.0;
        t = DateTime.fromMillisecondsSinceEpoch(value['time'])
            .toString()
            .split(' ')
            .last
            .split('.')
            .first;
      });
      setState(() {
        weight = s;
        ductTime = t;
      });
    });
  }

  getstatus() async {
    FirebaseDatabase db = FirebaseDatabase.instance;
    var data = db.reference().child('bot/status').limitToLast(1);
    data.onValue.listen((Event onData) {
      String t;
      Map<dynamic, dynamic> a = onData.snapshot.value;
      print(a.toString());
      a.forEach((key, value) {
        t = value['value'];
      });
      print(t);
      setState(() {
        status = t;
      });
    });
  }

  executeMessage() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }
}
