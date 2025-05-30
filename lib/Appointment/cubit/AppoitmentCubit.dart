import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../Models/Appointment.dart';
import '../state/AppointmentState.dart';
import '../../service/helper_dio.dart'; // تأكد من المسار الصحيح

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());

  final DioService _dio = DioService();
  List<AppointmentModel> _allAppointments = [];
  AppointmentModel? activeAppointment;

  Future<void> fetchAppointments({String? state = '', int? limit}) async {
    emit(AppointmentLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      _dio.setToken(prefs.getString('access_token')!);

      Map<String, dynamic> params = {};
      if (state != null && state.isNotEmpty) params['state'] = state;
      if (limit != null) params['limit'] = limit.toString();

      final response = await _dio.get('get_schedule_user/', params: params);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        _allAppointments = data.map((json) => AppointmentModel.fromJson(json)).toList();
        emit(AppointmentSuccess(_allAppointments));
      } else {
        emit(AppointmentFailure("فشل في تحميل البيانات"));
      }
    } catch (e) {
      print("❌ Error fetching appointments: $e");
      emit(AppointmentFailure("خطأ أثناء الاتصال بالخادم"));
    }
  }
  Future<void> fetchAppointment({required int id}) async {
    emit(AppointmentLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      _dio.setToken(prefs.getString('access_token')!);



      final response = await _dio.get('get_schedule/${id}/');

      if (response.statusCode == 200) {
        var data = response.data;
        activeAppointment =  AppointmentModel.fromJson(data);
        if(activeAppointment != null)
        emit(oneAppointmentSuccess());
      } else {
        emit(AppointmentFailure("فشل في تحميل البيانات"));
      }
    } catch (e) {
      print("❌ Error fetching appointments: $e");
      emit(AppointmentFailure("خطأ أثناء الاتصال بالخادم"));
    }
  }
  void filterByState(String? label) {
    if (label == null || label == 'الكل') {
      emit(AppointmentSuccess(_allAppointments));
    } else {
      final filtered = _allAppointments
          .where((a) => a.states == _mapStateLabelToValue(label))
          .toList();
      emit(AppointmentSuccess(filtered));
    }
  }

  String _mapStateLabelToValue(String label) {
    switch (label) {
      case 'تمت الموافقة':
        return 'active';
      case 'في انتظار الدفع':
        return 'whit_paid';
      case 'مرفوضة':
        return 'rejected';
      default:
        return '';
    }
  }

  void filterByStateLabel(String label) {
    if (label == 'all') {
      emit(AppointmentSuccess(_allAppointments));
    } else {
      final filtered = _allAppointments
          .where((a) => a.states == label)
          .toList();
      emit(AppointmentSuccess(filtered));
    }
  }

  // ✅ تعديل الحجز
  Future<void> updateAppointment(int appointmentId, Map<String, dynamic> data) async {
    emit(UpdateAppointmentLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      _dio.setToken(prefs.getString('access_token')!);

      final response = await _dio.put('update_appointment/$appointmentId/', data);

      if (response.statusCode == 200) {
        emit(UpdateAppointmentSuccess("تم تعديل الحجز بنجاح ✅"));
        fetchAppointments(); // إعادة تحميل القائمة بعد التعديل
      } else {
        emit(UpdateAppointmentFailure("فشل في تعديل الحجز"));
      }
    } catch (e) {
      print("❌ Error updating appointment: $e");
      emit(UpdateAppointmentFailure("حدث خطأ أثناء التعديل"));
    }
  }

}
