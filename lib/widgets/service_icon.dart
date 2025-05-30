import 'package:arean/constant/colors.dart';
import 'package:flutter/material.dart';

Widget buildServiceIcon(String iconPath, String label, VoidCallback? onTap) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
            border: Border(
              left: BorderSide(
                color: Orange.withOpacity(0.9),
                width: 3,
              ),
              bottom: BorderSide(
                color: Orange.withOpacity(0.9),
                width: 4,
              ),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.3,
        ),
      ),
    ],
  );
}