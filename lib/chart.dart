import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List daysDrank = [0.0,0.0,0.0,0.0,0.0,0.0,0.0];
double goal;

class BarChartSample1 extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = Colors.white;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;


  @override
  void initState() {
    super.initState();
    getAllDaysDrank().then((value){
      setState(() {
        daysDrank = value;
      });
    });
    getGoal().then((value){
      setState(() {
        goal = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        color: Colors.white,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Semana',
                      style: TextStyle(

                          color: Color.fromRGBO(26, 143, 255, 1), fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BarChart(mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = true,
        Color barColor = Colors.blue,
        double width = 18,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 0.05 : y,
          color: isTouched ? Color.fromRGBO(26, 143, 255, 1) : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: goal,
            color: Color.fromRGBO(26, 143, 255, 0.1),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }


  Future<List<dynamic>> getAllDaysDrank() async{
    List data = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int i=0;i<=6;i++){
      data.add(prefs.getDouble("drank$i"));
      //print(data);
    }
    return data;
  }

  Future<double> getGoal() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    goal = prefs.getDouble("goal") ?? 2.0;
    return goal;
  }


  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
      switch (i) {
        case 0:
          print(daysDrank[i]);
          return makeGroupData(0, daysDrank[i], isTouched: i == touchedIndex);
        case 1:
          print(daysDrank[i]);
          return makeGroupData(1, num.parse(daysDrank[i].toStringAsFixed(2)), isTouched: i == touchedIndex);
        case 2:
          print(daysDrank[i]);
          return makeGroupData(2, num.parse(daysDrank[i].toStringAsFixed(2)), isTouched: i == touchedIndex);
        case 3:
          print(daysDrank[i]);
          return makeGroupData(3, num.parse(daysDrank[i].toStringAsFixed(2)), isTouched: i == touchedIndex);
        case 4:
          print(daysDrank[i]);
          return makeGroupData(4, num.parse(daysDrank[i].toStringAsFixed(2)), isTouched: i == touchedIndex);
        case 5:
          return makeGroupData(5, num.parse(daysDrank[i].toStringAsFixed(2)), isTouched: i == touchedIndex);
        case 6:
          return makeGroupData(6, num.parse(daysDrank[i].toStringAsFixed(2)), isTouched: i == touchedIndex);
        default:
          return null;
      }
    });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              double drank;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  drank = daysDrank[0];
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  drank = daysDrank[1];
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  drank = daysDrank[2];
                  break;
                case 3:
                  weekDay = 'Thursday';
                  drank = daysDrank[3];
                  break;
                case 4:
                  weekDay = 'Friday';
                  drank = daysDrank[4];
                  break;
                case 5:
                  weekDay = 'Saturday';
                  drank = daysDrank[5];
                  break;
                case 6:
                  weekDay = 'Sunday';
                  drank = daysDrank[6];
                  break;
              }
              return BarTooltipItem(
                  "$weekDay\n$drank L", TextStyle(color: Colors.white));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }
}