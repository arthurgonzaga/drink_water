import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:drink_watter/card_water_amount.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

double drank;
double needToDrink;
double percentage;
int today;
List<double> types = [0.1, 0.2, 0.3];
final double goal = 2.0;

void main(){
  runApp(MyApp());
}




class MyApp extends StatefulWidget{

  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {




  @override
  void initState() {
    super.initState();
    initNotification();
  }

  PageController pageController = PageController(initialPage: 0);

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
          body: Center(
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
                    future: getData(today), // TODO: implement the database
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: Text("loading..."),
                        );
                      }else{
                        return LiquidCircularProgressIndicator(
                          value: percentage, // Defaults to 0.5.
                          valueColor: AlwaysStoppedAnimation(Color.fromRGBO(102, 180, 255, 1)), // Defaults to the current Theme's accentColor.
                          backgroundColor: Colors.transparent, // Defaults to the current Theme's backgroundColor.
                          borderColor: Color.fromRGBO(102, 180, 255, 1),
                          borderWidth: 4.5,
                          direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                          center: Text(
                            "$drank L",
                            style: TextStyle(
                                color: percentage > 0.45 ? Colors.white : Color.fromRGBO(102, 180, 255, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),
                          ),
                        );
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
                      child: CardWater(pageController)
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: FloatingActionButton(
                        onPressed: (){
                          addLiters(pageController.page.toInt());
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
        ),
    );

  }

  void changePage(){

  }

  void addLiters(int index){
    setState(() {
      drank += types[index];
      percentage = drank/goal;
      needToDrink = goal - drank;
      drank = num.parse(drank.toStringAsFixed(2));
      percentage = num.parse(percentage.toStringAsFixed(2));
      needToDrink = num.parse(needToDrink.toStringAsFixed(2));
      saveData(today);
    });
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
    case 'Mon':
      return 6;
      break;
  }
}



