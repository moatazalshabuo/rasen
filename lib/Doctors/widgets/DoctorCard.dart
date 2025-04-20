import 'package:arean/constant/colors.dart';
import 'package:flutter/material.dart';
class DoctorCard extends StatelessWidget {

  final String doctorName;
  final String specialty;
  final String imagePath;
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    this.onTap,
    required this.doctorName,
    required this.specialty,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          boxShadow: [BoxShadow(spreadRadius: 1,blurRadius: 1,color: Colors.black.withOpacity(0.1))],
          border: Border(left: BorderSide(color: Orange.withOpacity(0.5),width: 2))
        ),
        // elevation: 1,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // التاريخ والوقت
              // const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage('${URL}/${imagePath}'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        specialty,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),

                  Column(
                    children: [
                      Icon(Icons.circle, size: 14, color: Colors.green),
                      SizedBox(height: 12,),
                      Icon(Icons.more_vert),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
