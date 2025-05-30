import 'package:arean/Doctors/models/DoctorSchdule.dart';
import 'package:arean/Doctors/state/DoctorState.dart';
import 'package:arean/service/helper_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/DoctorModel.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(initState());

  int getArabicWeekdayName(String weekday) {
    switch (weekday) {
      case 'sunday':
        return DateTime.sunday;
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      default:
        return 0;
    }
  }

  String getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return 'sunday';
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      default:
        return '';
    }
  }

  final _dio = DioService();
  DoctorModel? doctorProfile;

  // appiment sections
  DateTime selected_day = DateTime.now();
  String whoFor = 'me';
  String bookingType = 'new';
  String? pairod;
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  Future<List<DoctorModel>> fetchDoctorsByRole(String role) async {
    try {
      final response = await _dio.get(
        'doctors/by-role',
        params: {'role': role},
      );

      List<dynamic> data = response.data;
      return data.map((e) => DoctorModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ Error fetching doctors: $e");
      rethrow;
    }
  }

  Future<void> getDoctor(int id) async {
    emit(LoadingDotorProfileState());
    try {
      final reaponse = await _dio.get('doctor/${id}');
      var data = reaponse.data;

      this.doctorProfile = DoctorModel.fromJson(data);
      emit(SuccessDotorProfileState());
    } catch (e) {
      print("❌ Error fetching doctors: $e");
      emit(FieldDotorProfileState());
      rethrow;
    }
  }

  void selectDay(e) {
    selected_day = e;
    emit(ChangeSelectedDayState());
    // print(selected_day);
  }

  Future<void> createAppointment({required Map<String, dynamic> data}) async {
    data['date'] = DateFormat.yMMMd().format(selected_day);
    data['period'] = pairod;
    data['doctor_id'] = doctorProfile?.id;
    // print('object');

    // return;
    final prefs = await SharedPreferences.getInstance();
    emit(LoadingAppointmentState());
    try {
      _dio.setToken(prefs.getString('access_token')!);
      var response = await _dio.post('create_appointment', data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        emit(SuccessAppointmentState());
      } else {
        emit(
          FailedAppointmentState(message: "خطأ غير متوقع أثناء إضافة الموعد"),
        );
      }
    } catch (error) {
      print(error);
      // if (error) {
      // نتحقق من وجود رسالة خطأ في الرد
      String message = "خطأ أثناء الاتصال بالخادم";
      if (error is Map<String, dynamic>) {
        var errorData = error;

        // الخطأ الرئيسي
        if (errorData.containsKey('error')) {
          message = errorData['error'];
        }

        // التفاصيل الإضافية
        if (errorData.containsKey('details')) {
          var details = errorData['details'];
          if (details is Map<String, dynamic>) {
            details.forEach((key, value) {
              if (value is List && value.isNotEmpty) {
                message += "\n• ${value.first}";
              }
            });
          }
        }
      }

      emit(FailedAppointmentState(message: message));
    }
  }

  void ChangePirod(String value) {
    pairod = value;
    emit(ChangePirodState());
  }

  bool CheckAvilabelty(String pariod) {
    bool check = true;
    String day = getWeekdayName(selected_day.weekday);
    doctorProfile?.schedules.forEach((e) {
      if (day == e.day && pariod == e.period) {
        check = false;
      }
    });
    return check;
  }
  bool PublicCheckAvilabelty(String pariod,int daya,List<DoctorSchedule> sche) {
    bool check = true;
    String day = getWeekdayName(daya);
    sche.forEach((e) {
      if (day == e.day && pariod == e.period) {
        check = false;
      }
    });
    return check;
  }
}
