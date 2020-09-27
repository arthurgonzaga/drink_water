import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CardWater extends StatefulWidget{
  final PageController controller;
  double needToDrink;
  Duration timeDifference;
  List<double> liters = [0.1, 0.15, 0.2, 0.25, 0.3];

  CardWater(this.controller, this.needToDrink, this.timeDifference);

  CardWaterState createState() => CardWaterState();
}

class CardWaterState extends State<CardWater>{


  int sipsToDrink;
  @override
  void initState() {
    sipsToDrink = (widget.needToDrink/widget.liters[0]).round();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: widget.controller,
        onPageChanged: (index){
          sipsToDrink = (widget.needToDrink/widget.liters[index]).round();
          setState(() {
          });
        },
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: "100 ml",
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
                  RichText(
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: "200 ml",
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "250 ml",
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: "300 ml",
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