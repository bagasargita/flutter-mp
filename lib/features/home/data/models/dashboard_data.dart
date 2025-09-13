import 'dashboard_card.dart';
import 'transaction_trend.dart';

class DashboardData {
  final List<DashboardCard> cards;
  final String lastUpdated;
  final TransactionTrend transactionTrend;

  const DashboardData({
    required this.cards,
    required this.lastUpdated,
    required this.transactionTrend,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      cards: (json['cards'] as List<dynamic>)
          .map((item) => DashboardCard.fromJson(item as Map<String, dynamic>))
          .toList(),
      lastUpdated: json['lastUpdated'] as String,
      transactionTrend: TransactionTrend.fromJson(
        json['transactionTrend'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cards': cards.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated,
      'transactionTrend': transactionTrend.toJson(),
    };
  }
}
