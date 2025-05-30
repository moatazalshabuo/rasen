import 'package:arean/Doctors/cubit/DoctorCubit.dart';
import 'package:arean/Doctors/state/DoctorState.dart';
import 'package:arean/constant/colors.dart';
import 'package:arean/Doctors/secreens/Bookigs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tab_container/tab_container.dart';
import '../../DefualtLayout.dart';
import '../../widgets/AppBar.dart';

class DoctorProfilePage extends StatelessWidget {
  final int doctor_id;
  DoctorProfilePage({required this.doctor_id});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorCubit>();
    cubit.getDoctor(this.doctor_id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Defualtlayout(
        title: "الملف الشخصي",
        body: BlocConsumer<DoctorCubit, DoctorState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is LoadingDotorProfileState) {
              return Center(
                child: CircularProgressIndicator(
                  color: Blue,
                  strokeWidth: 3,
                ),
              );
            }

            if (state is FieldDotorProfileState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 60),
                    SizedBox(height: 16),
                    Text(
                        "فشل جلب البيانات",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        )
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => cubit.getDoctor(doctor_id),
                      icon: Icon(Icons.refresh),
                      label: Text("إعادة المحاولة"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                      ),
                    )
                  ],
                ),
              );
            }

            final doctor = cubit.doctorProfile!;
            final profile = doctor.profile;

            return CustomScrollView(
              slivers: [
                // Header with profile information
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Blue, Blue.withOpacity(0.7)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: AppBarCustom(context, 'الملف الشخصي', false),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                            child: Column(
                              children: [
                                // Profile Image
                                Hero(
                                  tag: 'doctor-${doctor_id}',
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 15,
                                          spreadRadius: 0,
                                          offset: Offset(0, 5),
                                        )
                                      ],
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(URL + doctor.photo!),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Name & Specialty
                                Text(
                                  doctor.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    doctor.specialty,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Booking Button
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingPage(doctorId: doctor_id),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.calendar_month_rounded),
                                  label: Text("احجز موعد الآن"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Orange,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(200, 50),
                                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Statistics Cards
                SliverToBoxAdapter(
                  child: Container(
                    transform: Matrix4.translationValues(0, -25, 0),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StatCard(
                            icon: FontAwesomeIcons.solidStar,
                            title: "التقييم",
                            value: "4.5",
                            color: Colors.amber,
                          ),
                          StatCard(
                            icon: FontAwesomeIcons.userMd,
                            title: "الخبرة",
                            value: "${profile?.experienceYears ?? '--'} سنة",
                            color: Orange,
                          ),
                          StatCard(
                            icon: FontAwesomeIcons.userGroup,
                            title: "الحجوزات",
                            value: "${profile?.experienceYears ?? '--'}",
                            color: Blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content Tabs
                SliverFillRemaining(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: TabContainer(
                        radius: 16,
                        tabEdge: TabEdge.top,
                        tabCurve: Curves.easeInOut,
                        // transitionDuration: const Duration(milliseconds: 300),
                        tabExtent: 60,
                        childPadding: const EdgeInsets.all(20),
                        color: Colors.white,
                        selectedTextStyle: TextStyle(
                          color: Blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedTextStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                        tabs: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, size: 18),
                              SizedBox(width: 8),
                              Text('معلومات الطبيب'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.schedule, size: 18),
                              SizedBox(width: 8),
                              Text('مواعيد العمل'),
                            ],
                          ),
                        ],
                        children: [
                          // Doctor Info Tab
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // About Doctor
                                sectionTitle("عن الطبيب", FontAwesomeIcons.userDoctor),
                                const SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Text(
                                    profile?.bio ?? "لا توجد تفاصيل متاحة عن الطبيب.",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade800,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),

                                // Certifications
                                if (profile?.certifications != null) ...[
                                  const SizedBox(height: 24),
                                  sectionTitle("الشهادات والمؤهلات", FontAwesomeIcons.award),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Text(
                                      profile!.certifications!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade800,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Schedule Tab
                          doctor.schedules.isEmpty
                              ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "لا توجد مواعيد عمل متاحة حالياً",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : GridView.builder(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.3,
                            ),
                            itemCount: doctor.schedules.length,
                            itemBuilder: (context, index) {
                              final schedule = doctor.schedules[index];
                              return ScheduleCard(
                                day: schedule.day,
                                period: schedule.period,
                                startTime: schedule.startTime,
                                endTime: schedule.endTime,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Blue),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String day;
  final String period; // morning أو evening
  final String startTime;
  final String endTime;

  const ScheduleCard({
    super.key,
    required this.day,
    required this.period,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMorning = period == 'morning';
    final IconData icon = isMorning ? FontAwesomeIcons.sun : FontAwesomeIcons.moon;
    final Color cardColor = isMorning ? Colors.amber.shade50 : Colors.indigo.shade50;
    final Color iconColor = isMorning ? Colors.amber.shade700 : Colors.indigo.shade700;
    final Color borderColor = isMorning ? Colors.amber.shade200 : Colors.indigo.shade200;
    final String periodLabel = isMorning ? 'صباحاً' : 'مساءً';

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day name with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 16),
              SizedBox(width: 8),
              Text(
                day,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          // Period indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              periodLabel,
              style: TextStyle(
                fontSize: 14,
                color: iconColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 8),

          // Time
          startTime.isNotEmpty && endTime.isNotEmpty
              ? Text(
            "$startTime - $endTime",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          )
              : Text(
            "الوقت غير محدد",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}