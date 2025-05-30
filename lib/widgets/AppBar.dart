import 'package:arean/widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/secrees/Login.dart';
import '../constant/colors.dart';

Widget AppBarCustom(context, title, none) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: none ? Blue : Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: none ? Blue : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      IconButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();

          final firstName = prefs.getString('first_name') ?? '';
          final lastName = prefs.getString('last_name') ?? '';
          final username = prefs.getString('username') ?? '';

          SmartDialog.show(
            alignment: Alignment.centerLeft,
            clickMaskDismiss: true,
            backDismiss: true,
            builder:
                (_) => buildCustomDrawer(
                  fullName: '$firstName $lastName',
                  username: username,
                  photoUrl: 'https://i.pravatar.cc/150?img=3',
                  context: context,
                  logout: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginPage()));
                  }

                ),
          );
        },
        icon: Icon(
          Icons.more_horiz,
          color: none ? Blue : Colors.white,
          size: 28,
        ),
      ),
    ],
  );
}
