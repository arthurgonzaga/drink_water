import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

double height, weight, bmi, goal;
int sleepHours, sleepMinutes;
String name;


class Settings extends StatefulWidget{
  Future _getData;

  Settings(this._getData);

  SettingsState createState() => SettingsState();
}


class SettingsState extends State<Settings>{
  
  final controllerHeight = TextEditingController();
  final controllerWeight = TextEditingController();
  final controllerName = TextEditingController();


  @override
  void initState() {
    widget._getData = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        home: Scaffold(
          resizeToAvoidBottomPadding: false,
            backgroundColor: Color.fromRGBO(212, 237,255 , 1),
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        vertical: 32
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_rounded,
                              size: 32,
                              color: Color.fromRGBO(26, 143, 255, 1)),
                            onPressed: (){
                                  Navigator.of(context).pop(true);
                                  },
                            tooltip: "BACK",
                          ),
                          Text(
                            "Settings",
                            style: TextStyle(
                                color: Color.fromRGBO(26, 143, 255, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 40
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.refresh,
                                  size: 32,
                                  color: Color.fromRGBO(26, 143, 255, 1)
                              ),
                            onPressed: () async{
                                  resetData(widget._getData);
                                  },
                            tooltip: "RESET DATA",
                          ),
                        ],

                      ),
                    ),
                    FutureBuilder(
                      future: widget._getData,

                        // Snapshot is list like: [height, weight, bmi, goal];
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            controllerHeight.text = snapshot.data[0].toString();
                            controllerWeight.text = snapshot.data[1].toString();
                            controllerName.text = snapshot.data[4].toString();
                            height = snapshot.data[0];
                            weight = snapshot.data[1];
                            bmi = snapshot.data[2];
                            goal = snapshot.data[3];
                            name = snapshot.data[4];

                            return SafeArea(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                    child: TextFormField(
                                      controller: controllerName,
                                      decoration: InputDecoration(
                                        labelText: 'Type your Name',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                    child: TextFormField(
                                      controller: controllerHeight,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Type your Height',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                    child: TextFormField(
                                      controller: controllerWeight,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Type your Weight'
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        OutlineButton(
                                            onPressed: () async{
                                              TimeOfDay time = TimeOfDay(hour: sleepHours, minute: sleepMinutes);
                                              TimeOfDay picked = await showTimePicker(
                                                  context: context,
                                                  initialTime: time,
                                                builder: (BuildContext context, Widget child) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                                    child: child,
                                                  );
                                                },
                                              );
                                              if(picked == null){
                                                return;
                                              }
                                              sleepHours = picked.hour;
                                              sleepMinutes = picked.minute;
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setInt("sleepHours", sleepHours);
                                              prefs.setInt("sleepMinutes", sleepMinutes);
                                            },
                                          color: Colors.blue,
                                          child: Text("SLEEP TIME", style: TextStyle(color: Colors.blue),),
                                          splashColor: Color.fromRGBO(255, 255, 255, 0.4),
                                          highlightColor: Colors.transparent,
                                        )
                                      ],
                                    )
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: RaisedButton(
                                      onPressed: (){
                                        saveData(context, widget._getData);
                                      },
                                      color: Colors.blue,
                                      child: Text("Save",style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.all(32),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.blue),
                                          children: [
                                            TextSpan(text:"You need to drink "),
                                            TextSpan(text:"${goal.toStringAsFixed(1)}", style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                              fontSize: 21
                                            )),
                                            TextSpan(text: " liters of water\n"),
                                            TextSpan(text:"Your BMI is "),
                                            TextSpan(text:"${bmi.toStringAsFixed(1)}", style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                                fontSize: 21
                                            )),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),

                                ],
                              ),
                            );
                          }else{
                            return Container();
                          }
                    }),
                  ],
                ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.all(32),
                          child: FlatButton(
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_){
                                    var style = TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black);

                                    return AlertDialog(
                                        elevation: 2,

                                        backgroundColor: Colors.white,
                                        title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children:[
                                              Text(
                                                "IMC                Situation",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ]
                                        ),
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("16 to 19.9",style: style),
                                                Text("20 to 24.9",style: style),
                                                Text("25 to 29.9",style: style),
                                                Text("30 to 39.9",style: style),
                                                Text(">40",style: style),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Underweight",style: style),
                                                Text("Normal",style: style),
                                                Text("Overweight",style: style),
                                                Text("Obese",style: style),
                                                Text("Extremely Obese",style: style),
                                              ],
                                            )
                                          ],
                                        )
                                    );
                                  }
                              );
                            },
                            child: Text(
                              "HELP",
                              style: TextStyle(color: Color.fromRGBO(0,0, 0, 0.3)),
                            ),
                            splashColor: Color.fromRGBO(255, 255, 255, 0.5),
                            highlightColor: Color.fromRGBO(255, 255, 255, 0.4),
                          ),
                        ),
                      ],
                    ),
                  )
      ]
              ),
            ),
      ),
    );
  }


  Future<List<dynamic>> getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    height = (prefs.getDouble('height') ?? 1.69);
    weight = (prefs.getDouble('weight') ?? 73);
    double height2 = height*height;

    bmi = (prefs.getDouble('bmi') ?? (weight/height2));
    goal = (prefs.getDouble('goal') ?? 2.0);
    sleepHours = (prefs.getInt('sleepHours') ?? 23);
    sleepMinutes = (prefs.getInt('sleepMinutes') ?? 00);
    name = prefs.getString('name') ?? "Adrielly";

    //print([height, weight, bmi, goal, name]);
    return [height, weight, bmi, goal, name];
  }

  Future<void> saveData(BuildContext context, Future _getData) async{

    // The body needs 35ml for every 1kg of the body
    goal = 0.035 * double.parse(double.parse(controllerWeight.text).toStringAsFixed(1));
    height = double.parse(controllerHeight.text);
    weight = double.parse(controllerWeight.text);

    double heightSquared = height*height;
    bmi = weight/heightSquared;


    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("weight", weight);
    prefs.setDouble("height", height);
    prefs.setDouble("bmi", bmi);
    prefs.setDouble("goal", goal);
    prefs.setInt("sleepHours", sleepHours);
    prefs.setString("name", controllerName.text);

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("Saved Successfully"))
    );
    setState(() {
      _getData = getData();
    });
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

  Future<void> resetData(Future _getData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int i=0;i<=6; i++){
      prefs.setDouble("drank$i", 0);
      prefs.setDouble("needToDrink$i", goal);
      prefs.setDouble("percentage$i", 0);
    }
    _getData = getData();
  }

}


