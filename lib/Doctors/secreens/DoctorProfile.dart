import 'package:arean/Doctors/cubit/DoctorCubit.dart';
import 'package:arean/Doctors/state/DoctorState.dart';
import 'package:arean/constant/colors.dart';
import 'package:arean/screens/Bookigs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tab_container/tab_container.dart';
import '../../DefualtLayout.dart';
import '../../screens/Home.dart';
import '../../screens/NotifcationsPage.dart';
import '../../screens/SettingsPage.dart';
import '../../widgets/AppBar.dart';

class DoctorProfilePage extends StatelessWidget {

  final int doctor_id;
  DoctorProfilePage({required this.doctor_id});

  // late final TabController _tabController = TabController( length: 3, vsync: DoctorProfilePage());

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorCubit>();
    cubit.getDoctor(this.doctor_id);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Defualtlayout(
        title: "Profile",

        body: BlocConsumer<DoctorCubit, DoctorState>(
          listener: (context, state) {},
          builder: (context, state) {
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
            final profile = doctor.profile;
            // print(doctor.schedules);
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Blue.withOpacity(0.9), Blue.withOpacity(0.6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/Header.png'),
                        fit: BoxFit.cover,
                        opacity: 0.5,
                      ),
                      borderRadius: const BorderRadius.only(
                        // bottomLeft: Radius.circular(24),
                        // bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        AppBarCustom(context,'الملف الشخصي',false),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(
                                  URL + doctor.photo!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  doctor.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  doctor.specialty,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingPage(doctor_id: doctor_id,),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Orange,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        "احجز الآن",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Icon(Icons.add_box, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 🧾 الخبرة والتقييم
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SpecialistCard(
                          title: "الخبرة",
                          icon: FontAwesomeIcons.medal,
                          subtitle: "${profile?.experienceYears ?? '--'} سنة",
                          color: Orange,
                          Bg: Orange.withOpacity(0.3),
                        ),
                        SpecialistCard(
                          title: "الحجوزات",
                          icon: FontAwesomeIcons.users,
                          subtitle: "${profile?.experienceYears ?? '--'} ",
                          color: Blue,
                          Bg: Blue.withOpacity(0.3),
                        ),
                        SpecialistCard(
                          title: "التقييم",
                          icon: FontAwesomeIcons.star,
                          subtitle: "4.5 ",
                          color: Colors.yellow,
                          Bg: Colors.yellow.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,

                    child: TabContainer(
                      tabEdge: TabEdge.top,
                      tabsStart: 0.1,
                      tabsEnd: 0.9,
                      tabMaxLength: 150,
                      borderRadius: BorderRadius.circular(10),
                      tabBorderRadius: BorderRadius.circular(10),
                      childPadding: const EdgeInsets.all(20.0),
                      selectedTextStyle: TextStyle(
                        color: Blue,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                      colors: [Colors.white, Colors.white],
                      tabs: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text('معلومات الطبيب'),
                        ),
                        Text('مواعيد العمل'),
                      ],
                      children: [
                        Container(
                          child: Column(
                            children: [
                              // // 🧾 وصف الطبيب
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sectionTitle("عن الطبيب"),
                                    const SizedBox(height: 8),
                                    Text(
                                      profile?.bio ??
                                          "لا توجد تفاصيل متاحة عن الطبيب.",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),

                              if (profile?.certifications != null) ...[
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      sectionTitle("الشهادات"),
                                      const SizedBox(height: 8),
                                      Text(
                                        profile!.certifications!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          height: 450,
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.2,
                            children:
                            doctor.schedules.map((item) {
                              return ScheduleCard(
                                day: item.day,
                                period: item.period,
                                startTime: item.startTime,
                                endTime: item.endTime,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: Blue, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}

class SpecialistCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color Bg;

  const SpecialistCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.Bg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: this.Bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          FaIcon(icon, size: 28, color: this.color),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
    IconData icon =
        period == 'morning' ? FontAwesomeIcons.solidSun : FontAwesomeIcons.moon;
    Color iconColor =
        period == 'morning' ? Colors.orange.shade600 : Colors.indigo.shade600;
    String periodLabel = period == 'morning' ? 'صباحاً' : 'مساءً';

    return Card(

      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          children: [
            // الأيقونة الدائرية
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, color: iconColor, size: 17),
            ),
            const SizedBox(width: 16),

            // التفاصيل
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$periodLabel ',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
