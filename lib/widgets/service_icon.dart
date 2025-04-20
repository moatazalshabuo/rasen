import 'package:arean/constant/colors.dart';
import 'package:flutter/material.dart';
Widget buildServiceIcon(String iconPath, String label,VoidCallback? onTap) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),

            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
            border: Border.all(color: Blue.withOpacity(0.9),width: 5,)
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(iconPath, width: 60, height: 50),
        ),
      ),
      SizedBox(height: 6),
      Text(label,style: TextStyle(fontWeight: FontWeight.w500),),
    ],
  );
}
