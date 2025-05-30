import 'package:arean/Appointment/secrean/AppoitmetsPage.dart';
import 'package:arean/Main/Cubit/HomeCubit.dart';
import 'package:arean/Main/states/HomeStates.dart';
import 'package:arean/constant/colors.dart';
import 'package:arean/Doctors/secreens/infoDoctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Appointment/Widget/AppointmentCard.dart';
import '../../Appointment/secrean/AppointmentDetailPage.dart';
import '../../auth/secrees/Login.dart';
import '../../screens/SettingsPage.dart';
import '../../widgets/Drawer.dart';
import '../Wedgits/AppoitmentCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<Homecubit>();
    cubit.fetchUserAppointments();

    return BlocConsumer<Homecubit, HomeState>(
      listener: (context, state) {
        // يمكن إضافة معالجة الحالات المختلفة هنا
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: Stack(
            children: [
              // خلفية الجزء العلوي
              Container(
                height: 240,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2D5D7B), // لون أغمق
                      Color(0xFF3B637C), // اللون الأصلي
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    // العناصر الزخرفية في الخلفية
                    Positioned(
                      top: -120,
                      right: -60,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -70,
                      left: -40,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // المحتوى الرئيسي
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // شريط العنوان
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // التنقل إلى صفحة الملف الشخصي
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child:Text(''),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // فتح الإشعارات
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      IconButton(onPressed: () async {
                                        final prefs = await SharedPreferences.getInstance();

                                        final firstName = prefs.getString('first_name') ?? '';
                                        final lastName = prefs.getString('last_name') ?? '';
                                        final username = prefs.getString('username') ?? '';

                                        SmartDialog.show(
                                          alignment: Alignment.centerLeft,
                                          clickMaskDismiss: true,
                                          backDismiss: true,
                                          builder:
                                              (_) => buildCustomDrawer(
                                              fullName: '$firstName $lastName',
                                              username: username,
                                              photoUrl: 'https://i.pravatar.cc/150?img=3',
                                              context: context,
                                              logout: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginPage()));
                                              }

                                          ),
                                        );
                                      },
                                          icon:  Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                        size: 24,
                                      ),),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // بطاقة الترحيب
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16, bottom: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'مرحبا مجددا !',
                                style: TextStyle(
                                  color: Color(0xFF3B637C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'عيادة الراسن',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'احجز استشارتك الآن بسهولة',
                                style: TextStyle(
                                  color: Colors.black87.withOpacity(0.5),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Blue, Blue.withOpacity(0.8)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Blue.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Image(
                                  image: AssetImage('assets/icons/logo.png'),
                                  width: 120,
                                  height: 80,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // قسم الخدمات
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'الخدمات',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: const [
                                    Text(
                                      'المزيد',
                                      style: TextStyle(
                                        color: Color(0xFF3B637C),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: Color(0xFF3B637C),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // أيقونات الخدمات
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child:
                          Row(
                            children: [
                              Expanded(
                                child: _buildServiceCard(
                                  'assets/icons/1.png',
                                  'حجز موعد',
                                  Orange,
                                      () {
                                    // Navigate to booking
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildServiceCard(
                                  'assets/icons/2.png',
                                  'حجزاتي',
                                  Blue,
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          AppointmentsPage()),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildServiceCard(
                                  'assets/doctorsvic.png',
                                  'نبذة الأطباء',
                                  Orange,
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SchedulePage()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // قسم آخر الحجوزات
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'آخر الحجوزات',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // عرض كل الحجوزات
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentsPage()
                                      )
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'عرض الكل',
                                        style: TextStyle(
                                          color: Orange,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: Orange,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // التاريخ الحالي
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.calendar_today, size: 16,
                                  color: Color(0xFF3B637C)),
                              SizedBox(width: 8),
                              Text(
                                'اليوم Jun 20 • 8:35',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF3B637C),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // قائمة الحجوزات
                        cubit.appointments.isNotEmpty
                            ? AppointmentBookingCard(
                          appointment: cubit.appointments[0],
                          onBook: () {
                            // فتح صفحة الحجز أو تأكيد الموعد
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AppointmentDetailPage(
                                      appointment: cubit.appointments[0],
                                    ),
                              ),
                            );
                          },
                          onToggleFavorite: () {
                            // تغيير حالة المفضلة
                          },
                          isFavorite: false,
                        )
                            : Container(
                          width: double.infinity,
                          height: 150,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'لا توجد حجوزات حالياً',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // إنشاء حجز جديد
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Orange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: const Text('إنشاء حجز جديد'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // تحديث دالة بناء أيقونة الخدمة لتتماشى مع التصميم الجديد
  Widget _buildServiceCard(String iconPath, String label, Color color,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                iconPath,
                width: 32,
                height: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

}