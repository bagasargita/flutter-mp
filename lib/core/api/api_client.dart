import 'package:dio/dio.dart';
import 'package:smart_mob/core/api/interceptors/auth_interceptor.dart';
import 'package:smart_mob/core/api/interceptors/logging_interceptor.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  static ApiClient create() {
    final dio = Dio();
    dio.interceptors.addAll([LoggingInterceptor(), AuthInterceptor()]);
    return ApiClient(dio);
  }

  Future<Response<Map<String, dynamic>>> login({
    required Map<String, dynamic> credentials,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: credentials,
    );
  }

  Future<Response<Map<String, dynamic>>> register({
    required Map<String, dynamic> userData,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: userData,
    );
  }

  Future<Response<Map<String, dynamic>>> logout() async {
    return await _dio.post<Map<String, dynamic>>('/auth/logout');
  }

  Future<Response<Map<String, dynamic>>> getProfile() async {
    return await _dio.get<Map<String, dynamic>>('/user/profile');
  }

  Future<Response<Map<String, dynamic>>> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    return await _dio.put<Map<String, dynamic>>(
      '/user/profile',
      data: profileData,
    );
  }

  Future<Response<List<dynamic>>> getNotifications() async {
    return await _dio.get<List<dynamic>>('/notifications');
  }

  Future<Response<List<dynamic>>> getServices() async {
    return await _dio.get<List<dynamic>>('/services');
  }

  Future<Response<Map<String, dynamic>>> createTransaction({
    required Map<String, dynamic> transactionData,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      '/transactions',
      data: transactionData,
    );
  }
}
