

import 'package:arean/Doctors/state/DoctorState.dart';
import 'package:arean/service/helper_dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/DoctorModel.dart';

class DoctorCubit extends Cubit<DoctorState>{
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
  final _dio = DioService();
  DoctorModel? doctorProfile;
  Future<List<DoctorModel>> fetchDoctorsByRole(String role) async {
    try {
      final response = await _dio.get('doctors/by-role', params: {
        'role': role,
      });

      List<dynamic> data = response.data;
      return data.map((e) => DoctorModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ Error fetching doctors: $e");
      rethrow;
    }
  }

  Future<void> getDoctor(int id) async{
    emit(LoadingDotorProfileState());
    try{
      final reaponse = await _dio.get('doctor/${id}');
      var data = reaponse.data;

      this.doctorProfile= DoctorModel.fromJson(data);
      emit(SuccessDotorProfileState());
    }catch(e){
      print("❌ Error fetching doctors: $e");
      emit(FieldDotorProfileState());
      rethrow;
    }
  }

}