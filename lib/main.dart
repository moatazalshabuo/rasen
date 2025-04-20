import 'package:arean/Doctors/cubit/DoctorCubit.dart';
import 'package:arean/auth/cubit/LoginCubit.dart';
import 'package:arean/auth/cubit/Registercubit.dart';
import 'package:arean/Doctors/secreens/DoctorProfile.dart';
import 'package:arean/screens/Home.dart';
import 'package:arean/auth/secrees/Login.dart';
import 'package:arean/auth/secrees/Register.dart';
import 'package:arean/Doctors/secreens/infoDoctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  LoginCubit lc = LoginCubit();
  bool sucess = await lc.refreshAccessToken();
  Widget body = sucess ? HomePage():LoginPage();
  //
  // if (prefs.getString('access_token') != null) {
  //   body = HomePage(); // ✅ إذا فيه توكن → يروح للصفحة الرئيسية
  // } else {
  //   body = LoginPage(); // ❌ إذا مافيش توكن → يروح يسجل دخول
  // }
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
        BlocProvider<LoginCubit>(create: (BuildContext context) => LoginCubit()),
        BlocProvider<DoctorCubit>(create: (BuildContext context) => DoctorCubit())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
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
