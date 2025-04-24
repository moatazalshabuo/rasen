import 'package:arean/DefualtLayout.dart';
import 'package:arean/Doctors/cubit/DoctorCubit.dart';
import 'package:arean/Doctors/state/DoctorState.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:arean/constant/colors.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/AppBar.dart';

class BookingPage extends StatelessWidget {
  final int doctor_id;

  const BookingPage({super.key, required this.doctor_id});
  @override

  Widget build(BuildContext context) {
    final cubit = context.read<DoctorCubit>();
    cubit.getDoctor(this.doctor_id);

    return BlocConsumer<DoctorCubit,DoctorState>(listener: (context,state){},
    builder: (context,state){
      if (state is LoadingDotorProfileState) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is FieldDotorProfileState) {
        return const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, color: Colors.yellow),
              SizedBox(width: 8),
              Text("فشل جلب البيانات", style: TextStyle(fontSize: 18)),
            ],
          ),
        );
      }
      final doctor = cubit.doctorProfile!;
      final schedules = doctor.schedules;
      return Directionality(
        textDirection: TextDirection.rtl,
        child:
        Defualtlayout(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الجزء العلوي
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Blue.withOpacity(0.9), Blue.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/Header.png'),
                      fit: BoxFit.cover,
                      opacity: 0.2,
                    ),
                    borderRadius: const BorderRadius.only(
                      // bottomLeft: Radius.circular(24),
                      // bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24,
                          vertical: 25,),
                        child: AppBarCustom(context, 'حجز موعد' ,false),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: CircleAvatar(
                              radius:40,
                              backgroundImage: NetworkImage(URL+'${doctor.photo}'),
                            ),
                          ),
                          SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              Text(
                                "د.${doctor.fullName}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${doctor.specialty}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text('اختيار الموعد',textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Blue)),
                ),
                SizedBox(height: 12),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(10),
                  padding:  EdgeInsets.all(15.0),
                  child:TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                    enabledDayPredicate: (day) {
                      // ترجع false لو اليوم معطّل
                      print(schedules.map((e)=>e.day).toList());
                      return schedules.map((e)=>cubit.getArabicWeekdayName(e.day)).toList().contains(day.weekday);
                    },
                    calendarStyle: CalendarStyle(
                      disabledTextStyle: TextStyle(color: Colors.grey),
                      // نص الأيام المعطلة
                      todayDecoration: BoxDecoration(
                        
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Blue,
                        shape: BoxShape.circle,
                      ),
                  ),
                ),),

                SizedBox(height: 25,),
                Container(
                  margin: const EdgeInsets.all(30),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => const ConfirmBookingSheet(),
                      );
                    },
                    child: const Text(
                      "تأكيد الحجز",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              ],
            ),
          ), title: '',
        ),
      );
    });
  }
}

class ConfirmBookingSheet extends StatefulWidget {
  const ConfirmBookingSheet({super.key});

  @override
  State<ConfirmBookingSheet> createState() => _ConfirmBookingSheetState();
}

class _ConfirmBookingSheetState extends State<ConfirmBookingSheet> {
  String whoFor = 'me';
  String bookingType = 'new';
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Text("تأكيد الحجز",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Blue)),
                const SizedBox(height: 16),

                // لمن الحجز؟
                Text("الحجز لـ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Text("لي"),
                      selected: whoFor == 'me',
                      selectedColor: Orange,
                      onSelected: (selected) {
                        setState(() => whoFor = 'me');
                      },
                      labelStyle: TextStyle(
                        color: whoFor == 'me' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text("لشخص آخر"),
                      selected: whoFor == 'other',
                      selectedColor: Orange,
                      onSelected: (selected) {
                        setState(() => whoFor = 'other');
                      },
                      labelStyle: TextStyle(
                        color: whoFor == 'other' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // نوع الحجز
                const SizedBox(height: 24),
                Text("نوع الحجز", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Text("مراجعة"),
                      selected: bookingType == 'review',
                      selectedColor: Orange,
                      onSelected: (selected) {
                        setState(() => bookingType = 'review');
                      },
                      labelStyle: TextStyle(
                        color: bookingType == 'review' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text("حجز جديد"),
                      selected: bookingType == 'new',
                      selectedColor: Orange,
                      onSelected: (selected) {
                        setState(() => bookingType = 'new');
                      },
                      labelStyle: TextStyle(
                        color: bookingType == 'new' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),


                // حقول إضافية إذا لشخص آخر
                if (whoFor == 'other') ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "اسم الشخص",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "العمر",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(whoFor == 'other'
                            ? "تم الحجز لـ ${nameController.text} (${ageController.text} سنة)"
                            : "تم الحجز لك بنجاح ✅"),
                        backgroundColor: Blue,
                      ));
                    },
                    child: const Text(
                      "إتمام الحجز",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
