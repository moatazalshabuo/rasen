

import 'package:flutter/material.dart';

import '../constant/colors.dart';

Widget AppBarCustom(context,title,none){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: none ? Blue :Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width:8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: none ? Blue :Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: none ? Blue :Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Icon(
          Icons.menu,
          color: none ? Colors.white :Blue,
          size: 28,
        ),
      ),

    ],
  );
}