import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

class tempReport extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<tempReport> {
  double ph = 0.0;

  List<FlSpot> _plot = [];
  List<String> _time = [];

  int graphCount = 0;
  bool isLoaded = false;
  bool hasValue = true;

  @override
  void initState() {
    getph();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Reports'),
      ),
      body: isLoaded
          ? hasValue
              ? Center(
                  child: Container(
                    width: graphCount * 60.0,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: FlChart(
                      chart: LineChart(
                        LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: _plot,
                                isCurved: true,
                                barWidth: 4,
                                belowBarData: BelowBarData(
                                  show: false,
                                ),
                                dotData: FlDotData(show: true),
                              ),
                            ],
                            minY: 0,
                            titlesData: FlTitlesData(
                                getVerticalTitles: (val) {
                                  return val.toString();
                                },
                                verticalTitleMargin: 10,
                                horizontalTitleMargin: 20,
                                verticalTitlesReservedWidth: 30,
                                showVerticalTitles: true,
                                getHorizontalTitles: (val) {
                                  return _time.elementAt(val.toInt());
                                },
                                verticalTitlesTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                                horizontalTitlesTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                )),
                            gridData: FlGridData(
                              drawHorizontalGrid: true,
                            ),
                            borderData: FlBorderData(
                              show: true,
                            ),
                            clipToBorder: true),
                      ),
                    ),
                  ),
                )
              : Text('No data found')
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  getph() async {
    FirebaseDatabase db = FirebaseDatabase.instance;
    var data =
        db.reference().child('bot/temp').orderByChild('time').limitToLast(6);
    data.onValue.listen((Event onvalue) {
      if (onvalue.snapshot.value == null) {
        setState(() {
          isLoaded = true;
          hasValue = false;
        });
      }
      double s = 0;
      Map<dynamic, dynamic> snapshot = onvalue.snapshot.value;
      List<dynamic> list = snapshot.values.toList()
        ..sort((a, b) => b['time'].compareTo(a['time']));
      print(list.toString());
      print(onvalue.snapshot.value.toString());
      list = list.reversed.toList();
      double i = 0;
      _plot.clear();
      list.forEach((value) {
        s = value['value'] * 1.0;
        _plot.add(FlSpot(i, s));
        DateTime time = DateTime.fromMillisecondsSinceEpoch(value['time']);
        _time.add(time.toString().split(' ').last.split('.').first);
        i++;
        graphCount++;
      });
      setState(() {
        isLoaded = true;
      });
    });
  }
}
