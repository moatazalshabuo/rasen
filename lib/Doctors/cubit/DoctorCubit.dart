

import 'package:arean/Doctors/state/DoctorState.dart';
import 'package:arean/service/helper_dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/DoctorModel.dart';

class DoctorCubit extends Cubit<DoctorState>{
  DoctorCubit() : super(initState());

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