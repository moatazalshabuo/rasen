import 'package:arean/Doctors/cubit/DoctorCubit.dart';
import 'package:arean/Doctors/models/DoctorModel.dart';
import 'package:arean/Doctors/secreens/DoctorProfile.dart';
import 'package:flutter/material.dart';

import '../secreens/Bookigs.dart';
import 'DoctorCard.dart';

class DoctorListTab extends StatelessWidget {
  final String showSpecialists;

  const DoctorListTab({super.key, required this.showSpecialists});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DoctorModel>>(
      future: DoctorCubit().fetchDoctorsByRole(showSpecialists),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("حدث خطأ أثناء جلب البيانات"));
        }

        final doctors = snapshot.data ?? [];

        if (doctors.isEmpty) {
          return const Center(child: Text("لا يوجد أطباء في هذا القسم"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: doctors.length,
          itemBuilder:
              (context, index) => Column(
                children: [
                  DoctorCard(
                    doctorName: doctors[index].fullName,
                    specialty: doctors[index].specialty,
                    imagePath: doctors[index].photo!,
                    onTap:
                        () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DoctorProfilePage(
                                    doctor_id: doctors[index].id,
                                  ),
                            ),
                          ),
                        },
                    onTapBook:
                        () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      BookingPage(doctorId: doctors[index].id),
                            ),
                          ),
                        },
                  ),
                  SizedBox(height: 10),
                ],
              ),
        );
      },
    );
  }
}
