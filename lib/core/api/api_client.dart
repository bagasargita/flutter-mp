import 'package:dio/dio.dart';
import 'package:merah_putih/core/api/api_config.dart';
import 'package:merah_putih/core/api/api_endpoints.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  static ApiClient create() {
    return ApiClient(ApiConfig.createDio());
  }

  Future<Response<Map<String, dynamic>>> getFaqCategories() async {
    return await _dio.get<Map<String, dynamic>>(ApiEndpoints.faqCategories);
  }

  Future<Response<Map<String, dynamic>>> getFaqByCategory({
    required String kategori,
  }) async {
    return await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.faq,
      queryParameters: {'kategori': kategori},
    );
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

  Future<Response<Map<String, dynamic>>> getBeneficiaryAccounts({
    required String branchId,
  }) async {
    print('ApiClient: getBeneficiaryAccounts called with branchId: $branchId');
    print('ApiClient: Making request to ${ApiEndpoints.beneficiaryAccount}');
    print('ApiClient: Query parameters: {branch_id: $branchId}');

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.beneficiaryAccount,
        queryParameters: {'branch_id': branchId},
      );

      print(
        'ApiClient: getBeneficiaryAccounts response status: ${response.statusCode}',
      );
      print(
        'ApiClient: getBeneficiaryAccounts response data: ${response.data}',
      );

      return response;
    } catch (e) {
      print('ApiClient: getBeneficiaryAccounts error: $e');
      rethrow;
    }
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

  Future<Response<Map<String, dynamic>>> getMachineLocations({
    required double latitude,
    required double longitude,
    String? type,
    String? status,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'latitude': latitude,
      'longitude': longitude,
    };

    if (type != null && type.isNotEmpty) {
      queryParameters['type'] = type;
    }
    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }

    return await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.machineLocations,
      queryParameters: queryParameters,
    );
  }

  Future<Response<Map<String, dynamic>>> getDashboard() async {
    return await _dio.get<Map<String, dynamic>>(ApiEndpoints.dashboard);
  }

  Future<Response<Map<String, dynamic>>> getTransactionData({
    int page = 0,
    int size = 10,
    List<String>? sort,
    String? transactionDateFrom,
    String? transactionDateTo,
    String? transactionNo,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
      'user': 'Own User',
    };

    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }
    if (transactionDateFrom != null) {
      queryParams['transactionDateFrom'] = transactionDateFrom;
    }
    if (transactionDateTo != null) {
      queryParams['transactionDateTo'] = transactionDateTo;
    }
    if (transactionNo != null) {
      queryParams['transactionNo'] = transactionNo;
    }

    print('ApiClient: Making request to ${ApiEndpoints.transactionData}');
    print('ApiClient: Query parameters: $queryParams');

    return await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.transactionData,
      queryParameters: queryParams,
    );
  }

  Future<Response<Map<String, dynamic>>> createSupportTicket({
    required String name,
    required String email,
    required String phoneNumber,
    required String transactionNumber,
    String? machine,
    required String subject,
    required String message,
  }) async {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'transactionNumber': transactionNumber,
      'subject': subject,
      'message': message,
    };

    if (machine != null && machine.isNotEmpty) {
      data['machine'] = machine;
    }

    return await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.supportTickets,
      data: data,
    );
  }

  Future<Response<List<dynamic>>> getTransactions() async {
    return await _dio.get<List<dynamic>>(ApiEndpoints.transactions);
  }
}
