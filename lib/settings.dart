import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

double height, weight, bmi, goal;


class Settings extends StatefulWidget{

  SettingsState createState() => SettingsState();
}


class SettingsState extends State<Settings>{
  
  final controllerHeight = TextEditingController();
  final controllerWeight = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        home: Scaffold(
            backgroundColor: Color.fromRGBO(212, 237,255 , 1),
            body: SafeArea(
              child: Column(
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
                              }),
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
                                color: Color.fromRGBO(26, 143, 255, 1)),
                            onPressed: () async{
                              resetData();
                            }),
                      ],

                    ),
                  ),
                  FutureBuilder(
                    future: getData(),

                      // Snapshot is list like: [height, weight, bmi, goal];
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          controllerWeight.text = snapshot.data[0].toString();
                          controllerHeight.text = snapshot.data[1].toString();
                          return SafeArea(
                            child: Column(
                              children: [
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
                                  margin: EdgeInsets.only(top: 20),
                                  child: RaisedButton(
                                    onPressed: (){
                                      saveData(context);
                                    },
                                    color: Colors.blue,
                                    child: Text("Save",style: TextStyle(color: Colors.white),),
                                  ),
                                )
                              ],
                            ),
                          );
                        }else{
                          return Container();
                        }
                  })
                ],
              ),
            ),
      ),
    );
  }


  Future<List<double>> getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    height = (prefs.getDouble('height') ?? 1.69);
    weight = (prefs.getDouble('weight') ?? 73);
    bmi = (prefs.getDouble('bmi') ?? (weight/sqrt(height)));
    goal = (prefs.getDouble('goal') ?? 2.0);

    //print([height, weight, bmi, goal]);
    return [height, weight, bmi, goal];
  }

  Future<void> saveData(BuildContext context) async{
    // Todo: fix some bugs here (update and round the numbers)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("height", double.parse(controllerHeight.text));
    prefs.setDouble("weight", double.parse(controllerWeight.text));
    prefs.setDouble("bmi",
        double.parse(controllerWeight.text)/sqrt(double.parse(controllerHeight.text)));
    prefs.setDouble("goal", 0.035 * double.parse(controllerWeight.text));

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("Saved Successfully"))
    );
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

  Future<void> resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("reset_manually", true);
  }

}

