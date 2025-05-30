import 'package:arean/Appointment/Models/Appointment.dart';
import 'package:arean/Main/states/HomeStates.dart';
import 'package:arean/service/helper_dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homecubit extends Cubit<HomeState> {
  Homecubit() : super(HomeinitState());

  final _dio = DioService();
  List<AppointmentModel> appointments =[];

  Future<void> fetchUserAppointments() async {
    emit(LoadAppoitmentState());

    try {
      final prefs = await SharedPreferences.getInstance();
      _dio.setToken(prefs.getString('access_token')!);

      Map<String, dynamic> params = {};
      params['state'] = '';
      params['limit'] = '1';

      final response = await _dio.get('get_schedule_user/', params: params);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        appointments = data
            .map((json) => AppointmentModel.fromJson(json))
            .toList();

        emit(SuccessAppoitmentState());
      } else {
        emit(FieldAppoitmentState());
      }
    } catch (e) {
      print("❌ Error fetching appointments: $e");
      emit(FieldAppoitmentState());
    }
  }
}