import 'dart:math';

import 'package:drink_watter/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:drink_watter/card_water_amount.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'chart.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


double drank, needToDrink, percentage, goal;
int today, sleepHours, sleepMinutes;
String name;
List<double> liters = [0.1, 0.15, 0.2, 0.25, 0.3];
Duration timeDifference;
PageController pageControllerWater = PageController(initialPage: 0);

Future _getData, _initNotification;

List daysDrank;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _initNotification = initNotification();
  _getData = getData();
  runApp(MyApp());
}




class MyApp extends StatefulWidget{

  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController _controller;

  PageController pageController = PageController();


  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 4));
    super.initState();

  }


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

            builder: (context){
                return FutureBuilder(

                  // Todo: fix the initNotification Bug
                  future: _initNotification,
                  builder: (context, snapshot) {

                    if(snapshot.hasData){
                      if(snapshot.data){
                        _getData = getData();
                      }
                      return FutureBuilder(
                        future: _getData,
                        builder: (context, snapshot) {
                          // snapshot.data = [drank, needToDrink, percentage, goal, name]
                          if(snapshot.hasData){
                            drank = snapshot.data[0];
                            needToDrink = snapshot.data[1];
                            percentage = snapshot.data[2];
                            goal = snapshot.data[3];
                            name = snapshot.data[4];

                            if(snapshot.data[0] >= snapshot.data[3]){
                              _controller.addListener(()=>setState((){}));
                              TickerFuture ticker = _controller.repeat();
                              ticker.timeout(Duration(seconds: 8),onTimeout: (){
                                _controller.forward(from: 0);
                                _controller.stop(canceled: true);
                              });
                            }

                            return Stack(
                                children: [
                                  snapshot.data[0] >= snapshot.data[3]
                                      ? LottieBuilder.network(
                                    "https://assets4.lottiefiles.com/packages/lf20_WdkR06.json",
                                    controller: _controller,
                                    frameRate: FrameRate(60),
                                  )
                                      : Container(),
                                  PageView(
                                    onPageChanged: (int index){
                                      setState(() {
                                        resetManually();
                                      });
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
                                                "${snapshot.data[4]}",
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
                                                child: LiquidCircularProgressIndicator(
                                                    value: snapshot.data[2], // Defaults to 0.5.
                                                    valueColor: AlwaysStoppedAnimation(
                                                        Color.fromRGBO(102, 180, 255, 1)), // Defaults to the current Theme's accentColor.
                                                    backgroundColor: Colors.transparent, // Defaults to the current Theme's backgroundColor.
                                                    borderColor:
                                                    Color.fromRGBO(102, 180, 255, 1),
                                                    borderWidth: 4.5,
                                                    direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                                    center: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "${snapshot.data[0]} L",
                                                          style: TextStyle(
                                                              color: (snapshot.data[2]) > 0.45
                                                                  ? Colors.white
                                                                  : Color.fromRGBO(102, 180, 255, 1),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 25
                                                          ),
                                                        ),

                                                        (snapshot.data[0]) <= snapshot.data[3]
                                                            ? Text(
                                                          "${num.parse(needToDrink.toStringAsFixed(1))} L",
                                                          style: TextStyle(
                                                              color: (snapshot.data[2]) > 0.45
                                                                  ? Color.fromRGBO(255, 255, 255, 0.7)
                                                                  : Color.fromRGBO(102, 180, 255, 0.7),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 10
                                                          ),
                                                        )
                                                            : Container()

                                                      ],
                                                    )
                                                )
                                            ),
                                            // Parte de baixo
                                            (snapshot.data[0] < snapshot.data[3])
                                                ? Column(
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
                                                      child: CardWater(pageControllerWater, snapshot.data[1], timeDifference, _getData)
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 20,bottom: 40),
                                                    child: FloatingActionButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          addLiters(pageControllerWater.page.toInt());
                                                          setNotification(needToDrink, context);
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.send,
                                                        size: 20,
                                                      ),
                                                      tooltip: "DRINK WATER",
                                                    ),
                                                  )
                                                ]
                                            )
                                                : Container(
                                                margin: EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 64
                                                ),
                                                child: Text(
                                                  "Congratulations!!!\nYou're finished for today\n🥰🎉",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                            )
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
                                                  _getData = getData();
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
                                  ),
                                ]
                            );
                          }else{
                            return Container();
                          }
                        },
                      );
                    }else{
                      return CircularProgressIndicator();
                    }
                  },
                );
              }
            ),
          )
    );

  }

  void addLiters(int index) async{

    if(drank >= goal){
      return;
    }
    setState(() {
      drank += liters[index];
      percentage = drank/goal;
      needToDrink = goal - drank;
      drank = num.parse(drank.toStringAsFixed(1));
      percentage = num.parse(percentage.toStringAsFixed(2));
      needToDrink = num.parse(needToDrink.toStringAsFixed(1));
      updateData();
    });
  }


}

Future<List<dynamic>> getData() async{
  today = getDayByName();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  resetData(prefs);

  drank = (prefs.getDouble('drank$today') ?? 0);
  goal = (prefs.getDouble('goal') ?? 2.0);
  needToDrink = (prefs.getDouble('needToDrink$today') ?? goal);
  percentage = (prefs.getDouble('percentage$today') ?? 0);
  sleepHours = (prefs.getInt('sleepHours') ?? 23);
  sleepMinutes = (prefs.getInt('sleepMinutes') ?? 00);
  name = (prefs.getString('name') ?? "Adrielly");

  Duration now = Duration(
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute
  );

  Duration sleep = Duration(hours: sleepHours, minutes: sleepMinutes);
  timeDifference = sleep - now;


  return [drank, needToDrink, percentage, goal, name];
}

Future<List<dynamic>> getAllDaysDrank() async{
  List data = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  goal = prefs.getDouble("goal");
  for(int day=0;day<=6;day++){
    var drank = prefs.getDouble("drank$day");
    if(drank == null){
      drank = 0;
      prefs.setDouble("drank$day", drank);
    }
    data.add(drank);
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
  _getData = getData();
}

void resetData(SharedPreferences prefs) async{
  if(today == 6){
    prefs.setBool("update", true);
  }else if(today != 6 && prefs.getBool("update")==true){
    await flutterLocalNotificationsPlugin.cancelAll();
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
  await flutterLocalNotificationsPlugin.cancelAll();
  if(prefs.getBool("reset_manually")==true){
    prefs.setBool("reset_manually", false);
    for(int i=0;i<=6; i++){
      prefs.setDouble("drank$i", 0);
      prefs.setDouble("needToDrink$i", goal);
      prefs.setDouble("percentage$i", 0);
    }
  }
  _getData = getData();
}

Future<bool> initNotification() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: null);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  return await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: notificationClick);
}

Future notificationClick(String payload){
  //
}

Future<void> setNotification(double needToDrink, BuildContext context) async {
  await flutterLocalNotificationsPlugin.cancelAll();

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

  var time = getTimeBasedOnUser(context);
  if(time == null){
    return null;
  }
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
  NotificationDetails platform = NotificationDetails(android, ios);
  await flutterLocalNotificationsPlugin
      .schedule(
      0,
      titles[new Random().nextInt(titles.length)],
      'You still need to drink ${needToDrink.toStringAsFixed(1)} Liters', time, platform);
}


DateTime getTimeBasedOnUser(BuildContext context){
  _getData = getData();

  int minutesRemaining = timeDifference.inMinutes;

  // liters = [0.1, 0.15, 0.2, 0.25, 0.3]
  double pageSelected = pageControllerWater.page;

  int sipAmount = (needToDrink/liters[pageSelected.toInt()]).round();
  int timeOfNextNotification = (minutesRemaining/sipAmount).round();

  Duration duration = Duration(minutes: (timeOfNextNotification - 1));

  DateTime dateTime = DateTime.now().add(duration);

  if(dateTime.compareTo(DateTime.now()) < 0){
    print("too late");
    return null;
  }

  String notificationText;

  if(duration.inHours <= 0){
    notificationText = "Next notification in ${duration.inMinutes} minutes";
  }else if((duration.inMinutes - (60*duration.inHours)) == 0){
    if(duration.inHours == 1){
      notificationText = "Next notification in 1 hour";
    }else{
      notificationText = "Next notification in ${duration.inHours} hours";
    }
  }else{
    notificationText = "Next notification in ${duration.inHours} "
        "hours and ${(duration.inMinutes - (60*duration.inHours))} minutes";
  }


  Scaffold.of(context).showSnackBar(
    SnackBar(content: Text(notificationText)
  ));
  return dateTime;
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



