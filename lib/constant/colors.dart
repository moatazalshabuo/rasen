import 'package:flutter/material.dart';

import '../Main/screans/Home.dart';
import '../screens/NotifcationsPage.dart';
import '../screens/SettingsPage.dart';
final Orange = Color.fromRGBO(224, 105, 77, 1);
final Blue =  Color.fromRGBO(59, 99, 124, 1);

final URL1 = "http://192.168.100.3:8000";
final URL = 'https://dev.desert-technology.com.ly';

void selected (index,context) {
  if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SettingsPage()));
  if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Notifcationspage()));
}