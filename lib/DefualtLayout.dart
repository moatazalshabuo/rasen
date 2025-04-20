import 'package:arean/constant/colors.dart';
import 'package:arean/screens/Home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Defualtlayout extends StatelessWidget {
  final Widget? body;
  final int currentIndex;
  final String title;
  final Function(int)? onTabSelected;

  const Defualtlayout({
    Key? key,
    this.body,
    required this.title,
    this.currentIndex = 0,
    this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:  Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],

      ),
          backgroundColor: const Color(0xFFF5F7FA),
          body:body,

          bottomNavigationBar: CurvedNavigationBar(
            index: currentIndex,
            backgroundColor: Color(0xFFF5F7FA),
            color: Blue,
            items: <Widget>[
              Icon(Icons.settings, size: 30,color: Colors.white,),
              Icon(Icons.home, size: 30,color: Colors.white,),
              Icon(Icons.notifications, size: 30,color: Colors.white,),
            ],
            onTap: (index) {
              //Handle button tap
              if(index== 1){
                // IconButton(icon: Icon(Icons.home, size: 30,color: Colors.white,),onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));

              }
            },
          )
      ),
    );
  }
}
