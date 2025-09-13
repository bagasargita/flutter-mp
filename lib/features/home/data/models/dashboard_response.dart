import 'dashboard_data.dart';
import 'dashboard_card.dart';
import 'transaction_trend.dart';

class DashboardResponse {
  final String timestamp;
  final int status;
  final String message;
  final DashboardData data;

  const DashboardResponse({
    required this.timestamp,
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('DashboardResponse: Parsing JSON - ${json.keys}');
      print('DashboardResponse: Data keys - ${json['data']?.keys}');

      final data = json['data'];
      if (data == null) {
        throw Exception('Data field is null in API response');
      }
      if (data is! Map<String, dynamic>) {
        throw Exception('Data field is not a Map: ${data.runtimeType}');
      }

      print('DashboardResponse: Dashboard value - ${data['dashboard']}');
      print(
        'DashboardResponse: Dashboard type - ${data['dashboard'].runtimeType}',
      );

      final dashboard = data['dashboard'];
      if (dashboard == null) {
        throw Exception('Dashboard field is null in API response data');
      }
      if (dashboard is! Map<String, dynamic>) {
        throw Exception(
          'Dashboard field is not a Map: ${dashboard.runtimeType}',
        );
      }

      print('DashboardResponse: Dashboard keys - ${dashboard.keys}');

      print(
        'DashboardResponse: TransactionTrend value - ${data['transactionTrend']}',
      );
      print(
        'DashboardResponse: TransactionTrend type - ${data['transactionTrend'].runtimeType}',
      );

      final transactionTrend = data['transactionTrend'];
      if (transactionTrend == null) {
        throw Exception('TransactionTrend field is null in API response data');
      }
      if (transactionTrend is! Map<String, dynamic>) {
        throw Exception(
          'TransactionTrend field is not a Map: ${transactionTrend.runtimeType}',
        );
      }

      print(
        'DashboardResponse: TransactionTrend keys - ${transactionTrend.keys}',
      );

      print('DashboardResponse: Dashboard cards value - ${dashboard['cards']}');
      print(
        'DashboardResponse: Dashboard cards type - ${dashboard['cards'].runtimeType}',
      );
      print(
        'DashboardResponse: Dashboard lastUpdated - ${dashboard['lastUpdated']}',
      );

      // Create DashboardData with the correct structure
      final cards = dashboard['cards'];
      if (cards == null) {
        throw Exception('Cards field is null in dashboard data');
      }
      if (cards is! List<dynamic>) {
        throw Exception('Cards field is not a List: ${cards.runtimeType}');
      }

      final dashboardData = DashboardData(
        cards: cards
            .map((item) => DashboardCard.fromJson(item as Map<String, dynamic>))
            .toList(),
        lastUpdated: dashboard['lastUpdated'] as String,
        transactionTrend: TransactionTrend.fromJson(transactionTrend),
      );

      return DashboardResponse(
        timestamp: json['timestamp'] as String,
        status: json['status'] as int,
        message: json['message'] as String,
        data: dashboardData,
      );
    } catch (e) {
      print('DashboardResponse: Error during parsing - $e');
      print('DashboardResponse: Error type - ${e.runtimeType}');
      print('DashboardResponse: Stack trace - ${StackTrace.current}');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}
