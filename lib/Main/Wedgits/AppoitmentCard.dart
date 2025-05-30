import 'package:arean/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String appointmentState;
  final String imageAssetPath;
  final DateTime appointmentDate;

  const AppointmentCard({
    Key? key,
    required this.doctorName,
    required this.specialty,
    required this.appointmentState,
    required this.imageAssetPath,
    required this.appointmentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(appointmentDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFFFF8A00), width: 5), // Orange
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(URL+imageAssetPath),
            radius: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  specialty,
                  style: const TextStyle(
                    color: Color(0xFFFF8A00), // Orange
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appointmentState,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF406B86), // Blue
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Wrap(
                      children:[ Text(
                        'الموعد: $formattedDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      )],
                    )
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
