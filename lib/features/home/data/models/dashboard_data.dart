import 'dashboard_card.dart';
import 'transaction_trend.dart';

class DashboardData {
  final List<DashboardCard> cards;
  final String lastUpdated;
  final TransactionTrend? transactionTrend;

  const DashboardData({
    required this.cards,
    required this.lastUpdated,
    this.transactionTrend,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawCards = (json['cards'] as List<dynamic>? ?? []);
    return DashboardData(
      cards: rawCards
          .map((item) => DashboardCard.fromJson(item as Map<String, dynamic>))
          .toList(),
      lastUpdated: (json['lastUpdated'] as String? ?? ''),
      transactionTrend: json['transactionTrend'] is Map<String, dynamic>
          ? TransactionTrend.fromJson(
              json['transactionTrend'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cards': cards.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated,
      if (transactionTrend != null)
        'transactionTrend': transactionTrend!.toJson(),
    };
  }
}
