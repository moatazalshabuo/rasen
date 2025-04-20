import 'package:arean/constant/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainLayout extends StatelessWidget {
  final Widget? body;
  final int currentIndex;
  final Function(int)? onTabSelected;

  const MainLayout({
    Key? key,
    this.body,
    this.currentIndex = 0,
    this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Stack(
          children: [
            Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(59, 99, 124, 1),
                    // image: DecorationImage(image:  AssetImage('assets/background.jpg'),fit: BoxFit.cover),
                  ),
                  // clipBehavior: Clip.hardEdge,
                  child:  Stack(
                    children: [
                      Positioned(
                        child:Icon(Icons.circle_outlined,size: 280,color: Colors.white.withOpacity(0.3),) ,
                        top: -150,
                        right: -60,
                      ),
                    ],
                  ),
                  // child: Image(image:,),
                ),

              ],
            ),
            // المحتوى الرئيسي مع margin علوي لتفادي تداخل العناصر
            Padding(
              padding: const EdgeInsets.only(top: 90.0, left: 16, right: 16),
              child: body ?? Container(),
            ),

            // Row العلوي,
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('assets/d2.jpg'),
                    ),
                    Icon(Icons.notifications_none, color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),
          ],
        ),

        bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFFF5F7FA),
        color: Blue,
        items: <Widget>[
          Icon(Icons.settings, size: 30,color: Colors.white,),
          Icon(Icons.home, size: 30,color: Colors.white,),
          Icon(Icons.notifications, size: 30,color: Colors.white,),
        ],
        onTap: (index) {
          //Handle button tap
        },
      )
      ),
    );
  }
}
