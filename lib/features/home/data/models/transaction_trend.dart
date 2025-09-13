import 'transaction_trend_data.dart';
import 'transaction_trend_statistics.dart';

class TransactionTrend {
  final String title;
  final String description;
  final String period;
  final List<TransactionTrendData> data;
  final TransactionTrendStatistics statistics;
  final String lastUpdated;

  const TransactionTrend({
    required this.title,
    required this.description,
    required this.period,
    required this.data,
    required this.statistics,
    required this.lastUpdated,
  });

  factory TransactionTrend.fromJson(Map<String, dynamic> json) {
    try {
      print('TransactionTrend: Parsing JSON - ${json.keys}');
      print('TransactionTrend: Title - ${json['title']}');
      print('TransactionTrend: Description - ${json['description']}');
      print('TransactionTrend: Period - ${json['period']}');
      print('TransactionTrend: Data value - ${json['data']}');
      print('TransactionTrend: Data type - ${json['data'].runtimeType}');
      print('TransactionTrend: Statistics value - ${json['statistics']}');
      print(
        'TransactionTrend: Statistics type - ${json['statistics'].runtimeType}',
      );
      print('TransactionTrend: LastUpdated - ${json['lastUpdated']}');

      final data = json['data'];
      if (data == null) {
        throw Exception('Data field is null in TransactionTrend');
      }
      if (data is! List<dynamic>) {
        throw Exception('Data field is not a List: ${data.runtimeType}');
      }

      final statistics = json['statistics'];
      if (statistics == null) {
        throw Exception('Statistics field is null in TransactionTrend');
      }
      if (statistics is! Map<String, dynamic>) {
        throw Exception(
          'Statistics field is not a Map: ${statistics.runtimeType}',
        );
      }

      return TransactionTrend(
        title: json['title'] as String,
        description: json['description'] as String,
        period: json['period'] as String,
        data: data
            .map(
              (item) =>
                  TransactionTrendData.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
        statistics: TransactionTrendStatistics.fromJson(statistics),
        lastUpdated: json['lastUpdated'] as String,
      );
    } catch (e) {
      print('TransactionTrend: Error during parsing - $e');
      print('TransactionTrend: Error type - ${e.runtimeType}');
      print('TransactionTrend: Stack trace - ${StackTrace.current}');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'period': period,
      'data': data.map((item) => item.toJson()).toList(),
      'statistics': statistics.toJson(),
      'lastUpdated': lastUpdated,
    };
  }
}
