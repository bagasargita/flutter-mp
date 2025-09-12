import 'package:dio/dio.dart';
import 'package:smart_mob/core/api/api_config.dart';
import 'package:smart_mob/core/api/api_endpoints.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  static ApiClient create() {
    return ApiClient(ApiConfig.createDio());
  }

  Future<Response<Map<String, dynamic>>> login({
    required String identifier,
    required String password,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'identifier': identifier, 'password': password},
    );
  }

  Future<Response<Map<String, dynamic>>> register({
    required Map<String, dynamic> userData,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: userData,
    );
  }

  Future<Response<Map<String, dynamic>>> logout() async {
    return await _dio.post<Map<String, dynamic>>(ApiEndpoints.logout);
  }

  Future<Response<Map<String, dynamic>>> forgotPassword({
    required String email,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  Future<Response<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
  }

  Future<Response<Map<String, dynamic>>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.resetPassword,
      data: {'email': email, 'otp': otp, 'newPassword': newPassword},
    );
  }

  Future<Response<Map<String, dynamic>>> getProfile() async {
    return await _dio.get<Map<String, dynamic>>(ApiEndpoints.profile);
  }

  Future<Response<Map<String, dynamic>>> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    return await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.updateProfile,
      data: profileData,
    );
  }

  Future<Response<List<dynamic>>> getNotifications() async {
    return await _dio.get<List<dynamic>>(ApiEndpoints.notifications);
  }

  Future<Response<List<dynamic>>> getServices() async {
    return await _dio.get<List<dynamic>>(ApiEndpoints.services);
  }

  Future<Response<Map<String, dynamic>>> createTransaction({
    required Map<String, dynamic> transactionData,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.transactions,
      data: transactionData,
    );
  }

  Future<Response<List<dynamic>>> getTransactionHistory() async {
    return await _dio.get<List<dynamic>>(ApiEndpoints.transactionHistory);
  }

  Future<Response<Map<String, dynamic>>> getServiceCategories() async {
    return await _dio.get<Map<String, dynamic>>(ApiEndpoints.serviceCategories);
  }

  Future<Response<Map<String, dynamic>>> markNotificationAsRead({
    required String notificationId,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.markAsRead,
      data: {'notification_id': notificationId},
    );
  }

  Future<Response<Map<String, dynamic>>> createQr({
    required Map<String, dynamic> payload,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.createQr,
      data: payload,
    );
  }

  Future<Response<Map<String, dynamic>>> getDepositTransactions({
    required int page,
    required int size,
    required List<String> sort,
    required DateTime fromDate,
    required DateTime toDate,
    String? search,
    String? tipeTransaksi,
    String? statusTransaksi,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'size': size,
      'sort': sort,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
    };

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }
    if (tipeTransaksi != null && tipeTransaksi.isNotEmpty) {
      queryParameters['tipeTransaksi'] = tipeTransaksi;
    }
    if (statusTransaksi != null && statusTransaksi.isNotEmpty) {
      queryParameters['statusTransaksi'] = statusTransaksi;
    }

    return await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.depositTransactions,
      queryParameters: queryParameters,
    );
  }
}
