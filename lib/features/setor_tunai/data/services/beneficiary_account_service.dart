import 'package:dio/dio.dart';
import 'package:merah_putih/core/api/api_client.dart';

class BeneficiaryAccountService {
  final ApiClient _apiClient;

  BeneficiaryAccountService(this._apiClient);

  Future<Response<Map<String, dynamic>>> getBeneficiaryAccounts({
    required String branchId,
  }) async {
    return await _apiClient.getBeneficiaryAccounts(branchId: branchId);
  }
}
