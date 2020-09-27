import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CardWater extends StatefulWidget{
  final PageController controller;
  double needToDrink;
  Future _getData;
  Duration timeDifference;
  List<double> liters = [0.1, 0.15, 0.2, 0.25, 0.3];

  CardWater(this.controller, this.needToDrink, this.timeDifference, this._getData);

  CardWaterState createState() => CardWaterState();
}

class CardWaterState extends State<CardWater>{


  int sipsToDrink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: widget.controller,
        children: [
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Image.asset("imgs/100ml.png"),
                    width: 45,
                    height: 45,
                  ),
                  FutureBuilder(
                      future: widget._getData,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          sipsToDrink = (snapshot.data[1]/widget.liters[0]).round();
                          return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "150 ml",
                                    style: TextStyle(
                                        color: Color.fromRGBO(102, 180, 255, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  sipsToDrink != null
                                      ? TextSpan(
                                    text: "\n${sipsToDrink}x",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : TextSpan(),
                                ]
                            ),
                          );
                        }else{
                          return Container();
                        }
                      }
                  )
                ],
              )
          ),
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Image.asset("imgs/150ml.png"),
                    width: 45,
                    height: 45,
                  ),

                  FutureBuilder(
                  future: widget._getData,
                      builder: (context, snapshot) {
                      if(snapshot.hasData){
                        sipsToDrink = (snapshot.data[1]/widget.liters[1]).round();
                        return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "150 ml",
                                    style: TextStyle(
                                        color: Color.fromRGBO(102, 180, 255, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  sipsToDrink != null
                                      ? TextSpan(
                                            text: "\n${sipsToDrink}x",
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 0.2),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                      : TextSpan(),
                                        ]
                                    ),
                            );
                          }else{
                            return Container();
                          }
                      }
                  )
                ],
              )
          ),
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Image.asset("imgs/200ml.png"),
                    width: 45,
                    height: 45,
                  ),
                  FutureBuilder(
                      future: widget._getData,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          sipsToDrink = (snapshot.data[1]/widget.liters[2]).round();
                          return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "150 ml",
                                    style: TextStyle(
                                        color: Color.fromRGBO(102, 180, 255, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  sipsToDrink != null
                                      ? TextSpan(
                                    text: "\n${sipsToDrink}x",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : TextSpan(),
                                ]
                            ),
                          );
                        }else{
                          return Container();
                        }
                      }
                  )
                ],
              )
          ),
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: Image.asset("imgs/250ml.png"),
                    width: 50,
                    height: 50,
                  ),
                  FutureBuilder(
                      future: widget._getData,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          sipsToDrink = (snapshot.data[1]/widget.liters[3]).round();
                          return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "150 ml",
                                    style: TextStyle(
                                        color: Color.fromRGBO(102, 180, 255, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  sipsToDrink != null
                                      ? TextSpan(
                                    text: "\n${sipsToDrink}x",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : TextSpan(),
                                ]
                            ),
                          );
                        }else{
                          return Container();
                        }
                      }
                  )
                ],
              )
          ),
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Image.asset("imgs/250ml.png"),
                    width: 50,
                    height: 50,
                  ),
                  FutureBuilder(
                      future: widget._getData,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          sipsToDrink = (snapshot.data[1]/widget.liters[4]).round();
                          return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "150 ml",
                                    style: TextStyle(
                                        color: Color.fromRGBO(102, 180, 255, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  sipsToDrink != null
                                      ? TextSpan(
                                    text: "\n${sipsToDrink}x",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : TextSpan(),
                                ]
                            ),
                          );
                        }else{
                          return Container();
                        }
                      }
                  )
                ],
              ),
          )],
      ),
    );
  }

  int getSipAmount(){

  }


}