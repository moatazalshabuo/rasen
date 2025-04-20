import 'package:arean/DefualtLayout.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:arean/constant/colors.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedPeriod;
  final _controller = ValueNotifier('specialist');
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: 1,
          backgroundColor: Color(0xFFF5F7FA),
          color: Blue,
          items: <Widget>[
            Icon(Icons.settings, size: 30, color: Colors.white),
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.notifications, size: 30, color: Colors.white),
          ],
          onTap: (index) {
            //Handle button tap
          },
        ),
        backgroundColor: const Color(0xFFF9FAFB),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // الجزء العلوي
              Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Blue.withOpacity(0.9), Blue.withOpacity(0.2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'حجز موعد',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.notifications_active,
                            color: Colors.yellow,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage('assets/d4.jpg'),
                          ),
                        ),
                        SizedBox(width: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Text(
                              "د. فاطمة موسى",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "أخصائي عظام",
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EasyDateTimeLine(
                  initialDate: _focusedDay,
                  onDateChange: (selectedDate) {
                    setState(() {
                      _selectedDay = selectedDate;
                      _focusedDay = selectedDate;
                    });
                  },
                  activeColor: Orange,
                  headerProps: const EasyHeaderProps(
                    monthPickerType: MonthPickerType.switcher,
                    showMonthPicker: true,
                  ),
                  dayProps: EasyDayProps(
                    dayStructure: DayStructure.dayStrDayNum,
                    // borderRadius: 12,
                    activeDayStyle: DayStyle(
                      decoration: BoxDecoration(
                        color: Orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      dayStrStyle: TextStyle(color: Colors.white),
                      dayNumStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    inactiveDayStyle: DayStyle(
                      decoration: BoxDecoration(
                        color: Blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      dayStrStyle: TextStyle(color: Blue),
                      dayNumStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(25),
                width: double.infinity,
                child:AdvancedSegment(
                  controller: _controller,
                  segments: {'specialist': 'صباح', 'doctor': 'مساء'},
                  backgroundColor: Orange.withOpacity(0.2), // خلفية رصاصية
                  sliderColor: Colors.white, // الزر النشط أبيض
                  borderRadius: BorderRadius.circular(20),
                  itemPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  inactiveStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  activeStyle: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
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
        ),
      ),
    );
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
