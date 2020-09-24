import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CardWater extends StatefulWidget{
  final PageController controller;

  const CardWater(this.controller);

  CardWaterState createState() => CardWaterState();
}

class CardWaterState extends State<CardWater>{
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
                  Text(
                    "100 ml",
                    style: TextStyle(
                        color: Color.fromRGBO(102, 180, 255, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
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
                  Text(
                    "150 ml",
                    style: TextStyle(
                        color: Color.fromRGBO(102, 180, 255, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )
          ),
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Image.asset("imgs/200ml.png"),
                    width: 45,
                    height: 45,
                  ),
                  Text(
                      "200 ml",
                      style: TextStyle(
                          color: Color.fromRGBO(102, 180, 255, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
            ),
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
                  Text(
                    "250 ml",
                    style: TextStyle(
                        color: Color.fromRGBO(102, 180, 255, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
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
                  Text(
                      "300 ml",
                      style: TextStyle(
                        color: Color.fromRGBO(102, 180, 255, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
            ),
                ],
              ),
          )],
      ),
    );
  }


}