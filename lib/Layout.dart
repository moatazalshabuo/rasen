import 'package:arean/constant/colors.dart';
import 'package:arean/screens/Home.dart';
import 'package:arean/screens/NotifcationsPage.dart';
import 'package:arean/screens/SettingsPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Layout extends StatefulWidget {


  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _currentIndex = 1;
  final List<Widget> _pages = [
    SettingsPage(),
    HomePage(),
    Notifcationspage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          height: 60,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Color(0xFFF5F7FA),
          color: Blue,
          items: <Widget>[
            Icon(Icons.settings, size: 30,color: Colors.white,),
            Icon(Icons.home, size: 30,color: Colors.white,),
            Icon(Icons.notifications, size: 30,color: Colors.white,),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: _pages[_currentIndex],
      ),
    );
  }
}
