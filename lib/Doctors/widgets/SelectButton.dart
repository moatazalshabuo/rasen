import 'package:flutter/material.dart';
import '../../constant/colors.dart';

Widget buildSelectionButton({
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
  required IconData icon,
  required bool desibled, // typo remains as in your original code
}) {
  print(desibled);
  return InkWell(
    onTap: desibled ? null : onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: desibled
            ? Colors.grey[200]
            : (isSelected ? Blue.withOpacity(0.1) : Colors.white),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: desibled
              ? Colors.grey[400]!
              : (isSelected ? Blue : Colors.grey[300]!),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: desibled
                ? Colors.grey[400]
                : (isSelected ? Blue : Colors.grey[600]),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: desibled
                  ? Colors.grey[500]
                  : (isSelected ? Blue : Colors.grey[800]),
              fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}
