import 'package:arean/constant/colors.dart';
import 'package:flutter/material.dart';
Color choseType(String type){
  switch (type){
  case 'success':
    return Colors.green;
    case 'error':
      return Colors.red;
    default:
      return Orange;
  }
}
void showSuccessSnackBar(BuildContext context ,String text,String type) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
    backgroundColor: choseType(type),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'إغلاق',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}