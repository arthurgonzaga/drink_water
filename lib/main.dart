import 'dart:math';

import 'package:drink_watter/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:drink_watter/card_water_amount.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'chart.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


double drank, needToDrink, percentage, goal;
int today;
List<double> types = [0.1, 0.15, 0.2, 0.25, 0.3];

List daysDrank;


void main() async{
  runApp(MyApp());
}




class MyApp extends StatefulWidget{

  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {


  @override
  void initState() {
    initNotification();
    super.initState();
  }

  PageController pageControllerWater = PageController(initialPage: 0);
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Drink Water!',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          backgroundColor: Color.fromRGBO(212, 237,255 , 1),
          body: Builder(

            builder: (context) => Stack(
                children: [
                  PageView(
                    onPageChanged: (int index){
                      //getAllDaysDrank();
                    },
                    controller: pageController,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Text(
                                "Adrielly",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(26, 143, 255, 1),
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                            Container(
                                width: 200.0,
                                height: 200.0,
                                child: FutureBuilder(
                                  future: getData(),
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData){
                                      //[drank, needToDrink, percentage, goal]
                                      return LiquidCircularProgressIndicator(
                                        value: snapshot.data[2], // Defaults to 0.5.
                                        valueColor: AlwaysStoppedAnimation(Color.fromRGBO(102, 180, 255, 1)), // Defaults to the current Theme's accentColor.
                                        backgroundColor: Colors.transparent, // Defaults to the current Theme's backgroundColor.
                                        borderColor: Color.fromRGBO(102, 180, 255, 1),
                                        borderWidth: 4.5,
                                        direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                        center: Text(
                                          "${snapshot.data[0]} L",
                                          style: TextStyle(
                                              color: (snapshot.data[2]) > 0.45 ? Colors.white : Color.fromRGBO(102, 180, 255, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25
                                          ),
                                        ),
                                      );
                                    }else{
                                      return Container(width: 0,height: 0,);
                                    }
                                  },
                                )
                            ),
                            // Parte de baixo
                            Column(
                                children: [
                                  // White Card
                                  Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.1),
                                              offset: Offset(0,5),
                                              blurRadius: 5,
                                            )
                                          ]
                                      ),
                                      child: CardWater(pageControllerWater)
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20,bottom: 40),
                                    child: FloatingActionButton(
                                      onPressed: (){
                                        addLiters(pageControllerWater.page.toInt());
                                        setNotification(needToDrink);
                                      },
                                      child: Icon(
                                        Icons.send,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ]
                            ),
                          ],
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: FutureBuilder(
                                future: getAllDaysDrank(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return Chart(snapshot.data, goal);
                                  }else{
                                    return Container();
                                  }
                                },
                              )
                            ),
                            FloatingActionButton.extended(
                              icon: Icon(Icons.settings),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Settings(),
                                      ),

                                  );
                                  setState(() {
                                    resetManually();
                                  });
                                },
                                label: Text("Settings")
                            )
                          ],
                        )
                    ],
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SmoothPageIndicator(
                              controller: pageController,  // PageController
                              count:  2,
                              axisDirection: Axis.horizontal,
                              effect:  SwapEffect(
                                dotHeight: 10,
                                spacing: 8,
                                dotWidth: 10,
                                activeDotColor: Color.fromRGBO(102, 180, 255, 1),
                                dotColor: Color.fromRGBO(102, 180, 255, 0.3),

                              ),  // your preferred effect
                              onDotClicked: (index){
                                pageController.animateToPage(
                                    index,
                                    duration: new Duration(seconds: 1),
                                    curve: Curves.linearToEaseOut
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              ),
            ),
          )
    );

  }

  void addLiters(int index){

    if(drank >= goal){
      setState(() {

      });
      return;
    }
    setState(() {
      drank += types[index];
      percentage = drank/goal;
      needToDrink = goal - drank;
      drank = num.parse(drank.toStringAsFixed(2));
      percentage = num.parse(percentage.toStringAsFixed(2));
      needToDrink = num.parse(needToDrink.toStringAsFixed(2));
      updateData();
    });
  }


}

Future<List<double>> getData() async{
  today = getDayByName();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  resetData(prefs);

  drank = (prefs.getDouble('drank$today') ?? 0);
  goal = (prefs.getDouble('goal') ?? 2.0);
  needToDrink = (prefs.getDouble('needToDrink$today') ?? goal);
  percentage = (prefs.getDouble('percentage$today') ?? 0);
  return [drank, needToDrink, percentage, goal];
}

Future<List<dynamic>> getAllDaysDrank() async{
  List data = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  goal = prefs.getDouble("goal");
  for(int i=0;i<=6;i++){
    data.add(prefs.getDouble("drank$i"));
    //print(data);
  }
  return data;
}

void updateData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble("drank$today", drank);
  prefs.setDouble("needToDrink$today", needToDrink);
  prefs.setDouble("percentage$today", percentage);
  prefs.setDouble("goal", goal ?? 2.0);
}

void resetData(SharedPreferences prefs){
  if(today == 6){
    prefs.setBool("update", true);
  }else if(today != 6 && prefs.getBool("update")==true){
    prefs.setBool("update", false);
    for(int i=0;i<=6; i++){
      prefs.setDouble("drank$i", 0);
      prefs.setDouble("needToDrink$i", goal);
      prefs.setDouble("percentage$i", 0);
    }
  }
}

void resetManually() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getBool("reset_manually")==true){
    prefs.setBool("reset_manually", false);
    for(int i=0;i<=6; i++){
      prefs.setDouble("drank$i", 0);
      prefs.setDouble("needToDrink$i", goal);
      prefs.setDouble("percentage$i", 0);
    }
  }
}

Future<void> initNotification() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: null);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: notificationClick);
}

Future notificationClick(String payload){
  //
}

Future<void> setNotification(double needToDrink) async {

  List titles = [
    "Drink water, Darling ❤",
    "Water time, My love ❤",
    "Be hydrated, Honey ❤",
    "Drink water, Babe ❤",
    "Water time, Sweetie ❤"
  ];

  if(drank >= goal){
    return null;
  }

  var time = DateTime.now().add(Duration(seconds: 2));
  var android = AndroidNotificationDetails(
      'DRINK_WATER_ID',
      titles[new Random().nextInt(titles.length)],
      'You stil need to drink $needToDrink Liters',
    importance: Importance.Max,
    priority: Priority.High,
    color: Colors.blueAccent,
    enableVibration: true,
    visibility: NotificationVisibility.Public,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('water_sound')

  );
  var ios = IOSNotificationDetails();
  NotificationDetails plataform = NotificationDetails(android, ios);
  await flutterLocalNotificationsPlugin
      .schedule(
      0,
      titles[new Random().nextInt(titles.length)],
      'You stil need to drink $needToDrink Liters', time, plataform);
}

int getDayByName(){
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat.E();
  String string = dateFormat.format(now);


  switch(string){
    case 'Mon':
      return 0;
      break;
    case 'Tue':
      return 1;
      break;
    case 'Wed':
      return 2;
      break;
    case 'Thu':
      return 3;
      break;
    case 'Fri':
      return 4;
      break;
    case 'Sat':
      return 5;
      break;
    case 'Sun':
      return 6;
      break;
  }
}



