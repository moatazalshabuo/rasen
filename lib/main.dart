import 'package:arean/Appointment/cubit/AppoitmentCubit.dart';
import 'package:arean/Doctors/cubit/DoctorCubit.dart';
import 'package:arean/Layout.dart';
import 'package:arean/Main/Cubit/HomeCubit.dart';
import 'package:arean/auth/cubit/LoginCubit.dart';
import 'package:arean/auth/cubit/Registercubit.dart';
import 'package:arean/Doctors/secreens/DoctorProfile.dart';
import 'package:arean/Main/screans/Home.dart';
import 'package:arean/auth/secrees/Login.dart';
import 'package:arean/auth/secrees/Register.dart';
import 'package:arean/Doctors/secreens/infoDoctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/NotificatioCubit.dart';
import 'cubit/ProfilCubit.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  LoginCubit lc = LoginCubit();
  bool sucess = await lc.refreshAccessToken();
  Widget body = sucess ? Layout():LoginPage();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // إخفاء الشريط
  // await initializeDateFormatting('ar', '');
  // await initializeDateFormatting('ar'); // أو 'en' أو أي لغة تستخدمها
  runApp(MyApp(body: body));
}

class MyApp extends StatelessWidget {
  Widget body;
  MyApp({required this.body});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (BuildContext context) => AuthCubit()),
        BlocProvider<Homecubit>(create: (BuildContext context) => Homecubit()),
        BlocProvider<LoginCubit>(create: (BuildContext context) => LoginCubit()),
        BlocProvider<DoctorCubit>(create: (BuildContext context) => DoctorCubit()),
        BlocProvider<NotificationCubit>(create:(BuildContext context) =>NotificationCubit()),
        BlocProvider<ProfileCubit>(create:(BuildContext context) =>ProfileCubit()),
        BlocProvider<AppointmentCubit>(create: (BuildContext context) => AppointmentCubit())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          fontFamily: 'Cairo',
        ),
        home: body,
      ),
    );
  }
}
