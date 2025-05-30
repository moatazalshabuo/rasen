import 'package:arean/auth/state/Loginstate.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arean/service/helper_dio.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final _dio = DioService();

  Future<void> loginUser(String phone, String password) async {
    emit(LoginLoading());

    try {
      final response = await _dio.post('token', {
        'username': phone,
        'password': password,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.data['access']);
      await prefs.setString('refresh_token', response.data['refresh']);

      // إعداد الهيدر للتوكن
      _dio.setToken(response.data['access']);

      // بعد تسجيل الدخول، جيب بيانات المستخدم
      final userData = await _fetchUserData();

      emit(LoginSuccess(user: userData));
    } catch (e) {

      emit(LoginError(message: "فشل تسجيل الدخول" + e.toString()));
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');


    if (token == null) throw Exception("توكن مفقود");

    _dio.setToken(token);

    final response = await _dio.get('me');
    print(response);
    final user = response.data;

    await prefs.setString('user_id', user['id'].toString());
    await prefs.setString('first_name', user['first_name']);
    await prefs.setString('last_name', user['last_name']);
    await prefs.setString('username', user['username']);

    return user;
  }


  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    emit(LoginInitial());
  }

  Future<bool> refreshAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refresh = prefs.getString('refresh_token');

      if (refresh == null) return false;

      final response = await _dio.post('token/refresh', {
        'refresh': refresh,
      });
      print(response);
      final newAccess = response.data['access'];

      await prefs.setString('access_token', newAccess);

      _dio.setToken(newAccess);

      print("✅ تم تجديد التوكن");
      return true;
    } catch (e) {
      print("❌ فشل في تجديد التوكن: $e");
      await logout(); // لو فشل نمسح كل شيء
      return false;
    }
  }
}
