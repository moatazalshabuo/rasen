import 'package:arean/constant/colors.dart';
import 'package:arean/Doctors/secreens/infoDoctors.dart';
import 'package:arean/widgets/service_icon.dart';
import 'package:flutter/material.dart';

import 'SettingsPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الترحيب
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'مرحبا مجددا !',
                              style: TextStyle(color: Colors.black87, fontSize: 14,fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'عيادة الراسن',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'احجز استشارتك الآن بسهولة',
                              style: TextStyle(color: Colors.black87.withOpacity(0.5), fontSize: 14,fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: 130,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Blue,
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              child: Align(child: Image(image: AssetImage('assets/icons/logo.png'),width: 120,height: 80,),),
                            )

                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  Text('الخدمات',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildServiceIcon('assets/icons/1.png', 'حجز موعد',()=>{
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedulePage()))
                      }),
                      buildServiceIcon('assets/icons/2.png', 'حجزاتي',()=>{}),
                      buildServiceIcon('assets/doctorsvic.png', 'نبدة الاطباء',(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedulePage()));
                      }),
                    ],
                  ),

                  SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('اخر الحجوزات',
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      TextButton(onPressed: () {}, child: Text('عرض الكل',style: TextStyle(color: Orange,fontWeight: FontWeight.w700),))
                    ],
                  ),

                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18),
                      SizedBox(width: 8),
                      Text('اليوم Jun 20 • 8:35'),
                    ],
                  ),

                  SizedBox(height: 12),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(left: BorderSide(color: Orange,width: 5))
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/d3.jpg'),
                          radius: 30,
                          foregroundColor:  Color.fromRGBO(224, 105, 77, 1),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('د. تقوى',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800, fontSize: 14)),
                              SizedBox(height: 3),
                              Text('أخصائي', style: TextStyle(color: Orange,fontSize: 12,fontWeight: FontWeight.w600)),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('في انتظار الدفع',
                                        style: TextStyle(
                                            fontSize: 12, color: Blue)),
                                  ),
                                  // Text('الموعد : 25 a')
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
          )

        ],
      );
  }
}