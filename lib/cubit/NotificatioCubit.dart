import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/helper_dio.dart';
import '../model/NotificationModel.dart';

import '../states/NotificationState.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final DioService _dio = DioService();

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        emit(NotificationFailure("لا يوجد رمز وصول"));
        return;
      }

      _dio.setToken(token);
      final response = await _dio.get('notifications/'); // تأكد من مسار API

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<NotificationModel> notifications =
        data.map((json) => NotificationModel.fromJson(json)).toList();

        emit(NotificationSuccess(notifications));
      } else {
        emit(NotificationFailure("فشل في تحميل الإشعارات"));
      }
    } catch (e) {
      print("❌ Error fetching notifications: $e");
      emit(NotificationFailure("حدث خطأ أثناء تحميل الإشعارات"));
    }
  }
}
