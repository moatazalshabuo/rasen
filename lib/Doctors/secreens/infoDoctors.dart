import 'package:arean/DefualtLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';

import '../../constant/colors.dart';
import '../widgets/DoctorList.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key});
  final _controller = ValueNotifier('specialist');

  @override
  Widget build(BuildContext context) {
    return Defualtlayout(
      title: 'نبذة عن الأطباء',
      currentIndex: 1,
      body: Column(
        children: [
          const SizedBox(height: 10),
          AdvancedSegment(
            controller: _controller,
            segments: {'specialist': 'أخصائي', 'doctor': 'طبيب'},
            backgroundColor: Orange.withOpacity(
              0.15,
            ), // خلفية أفتح (زُرقة خفيفة جدًا)
            sliderColor: Colors.white,
             // لون الزر البرتقالي بشكل أفتح
            borderRadius: BorderRadius.circular(20),
            itemPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 25,
            ),
            inactiveStyle: TextStyle(
              color: Blue.withOpacity(0.5), // أزرق فاتح للنصوص غير النشطة
              fontSize: 18,
            ),
            activeStyle: TextStyle(
              color: Blue, // نص واضح، مش أبيض
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, selected, _) {
              if (selected == 'specialist') {
                return Expanded(
                  child: DoctorListTab(showSpecialists: selected),
                );
              } else {
                return Expanded(
                  child: DoctorListTab(showSpecialists: selected),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
