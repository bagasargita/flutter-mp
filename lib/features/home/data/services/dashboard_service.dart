import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/dashboard_response.dart';

class DashboardService {
  final ApiClient _apiClient;

  DashboardService(this._apiClient);

  Future<DashboardResponse> getDashboard() async {
    try {
      print('DashboardService: Fetching dashboard data...');
      final response = await _apiClient.getDashboard();
      print(
        'DashboardService: Response received - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 && response.data != null) {
        print('DashboardService: Parsing dashboard data...');
        final dashboardResponse = DashboardResponse.fromJson(response.data!);
        print('DashboardService: Dashboard data parsed successfully');
        return dashboardResponse;
      } else {
        throw Exception(
          'Failed to load dashboard data: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DashboardService: DioException - ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('DashboardService: Unexpected error - $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
