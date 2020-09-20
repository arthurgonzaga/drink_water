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
          Center(child: Text("100 ml")),
          Center(child: Text("200 ml")),
          Center(child: Text("300 ml")),
        ],
      ),
    );
  }


}