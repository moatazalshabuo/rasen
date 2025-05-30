import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/helper_dio.dart';
import '../model/ProfileModel.dart';
import '../states/ProfileState.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final DioService _dio = DioService();

  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        emit(ProfileFailure("رمز الوصول غير موجود"));
        return;
      }

      _dio.setToken(token);
      final response = await _dio.get('me'); // رابط endpoint

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = UserProfileModel.fromJson(response.data);
        emit(ProfileSuccess(user));
      } else {
        emit(ProfileFailure("فشل في جلب بيانات المستخدم"));
      }
    } catch (e) {
      print("❌ Error fetching profile: $e");
      emit(ProfileFailure("حدث خطأ أثناء تحميل الملف الشخصي"));
    }
  }

  Future<void> updateUserProfile(UserProfileModel updatedData) async {
    emit(ProfileLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        emit(ProfileFailure("رمز الوصول غير متوفر"));
        return;
      }

      _dio.setToken(token);
      final response = await _dio.post('profile/update/', updatedData.toJson());

      if (response.statusCode == 200) {
        final userJson = response.data['user'];
        final user = UserProfileModel.fromJson(userJson);
        emit(ProfileUpdated(response.data['message'], user));
      } else {
        emit(ProfileFailure("فشل في تحديث البيانات"));
      }
    } catch (e) {
      print("❌ خطأ أثناء تحديث الملف الشخصي: $e");
      emit(ProfileFailure("حدث خطأ أثناء تحديث البيانات"));
    }
  }
}
