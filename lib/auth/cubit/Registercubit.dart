import 'package:arean/auth/state/Registerstate.dart';
import 'package:arean/service/helper_dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(initState());

  final _dio = DioService();

  Future<void> create_user({required Map<String, String> data}) async {
    print(data);
    emit(LoadingState());
    try {
      var response = await _dio.post('register', data);
      print(response);
      if(response.statusCode == 201 || response.statusCode == 200){
        emit(SuccessState());
      }else{
        // print(response.data);
        emit(FieldState(message: "خطأ غير متوقع"));
      }
    } catch (error) {

        // نمرر الرسالة إلى الحالة
        String message = error.toString(); // أول خطأ من الباكند
        emit(FieldState(message: message));

    }
  }
}
