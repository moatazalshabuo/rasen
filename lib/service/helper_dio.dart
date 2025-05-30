import 'package:arean/constant/colors.dart';
import 'package:dio/dio.dart';

class DioService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          '${URL}/api/', // غيرها حسب عنوان الـ API متاعك
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer YOUR_TOKEN', // لو تحتاج توكن حطها هنا
      },
    ),
  );

  // ✅ GET
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, String>? header,
  }) async {
    if(header != null)
    _dio.options.headers.addAll(header!);
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response;
    }on DioException catch (e) {
      if (e.response != null) {
        // print("❌ Backend Error: ${e.response?.data}");
        // رمي الاستجابة كاملة لو فيها بيانات خطأ
        throw e.response!.data;
      }

      // رمي استثناء عام لو مافيش رد
      throw {'error': 'حدث خطأ في الاتصال بالسيرفر'};
    }
  }

  // ✅ POST
  Future<Response> post(
    String endpoint,
    dynamic data, {
    Map<String, String>? header,
  }) async {
    if (header != null) _dio.options.headers.addAll(header);

    try {
      final response = await _dio.post(endpoint, data: data);
      // print(response);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print("❌ Backend Error: ${e.response?.data}");

        // رمي الاستجابة كاملة لو فيها بيانات خطأ
        throw e.response!.data;
      }

      // رمي استثناء عام لو مافيش رد
      throw {'error': '${e}  حدث خطأ في الاتصال بالسيرفر'};
    }
  }

  // ✅ PUT
  Future<Response> put(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ✅ DELETE
  Future<Response> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ✅ لو تحتاج تحديث التوكن لاحقًا
  void setToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }
}
