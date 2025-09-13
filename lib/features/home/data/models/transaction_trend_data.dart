class TransactionTrendData {
  final String date;
  final int amount;
  final int count;
  final int ownAmount;
  final int otherAmount;
  final String dayOfWeek;

  const TransactionTrendData({
    required this.date,
    required this.amount,
    required this.count,
    required this.ownAmount,
    required this.otherAmount,
    required this.dayOfWeek,
  });

  factory TransactionTrendData.fromJson(Map<String, dynamic> json) {
    return TransactionTrendData(
      date: json['date'] as String,
      amount: json['amount'] as int,
      count: json['count'] as int,
      ownAmount: json['ownAmount'] as int,
      otherAmount: json['otherAmount'] as int,
      dayOfWeek: json['dayOfWeek'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'count': count,
      'ownAmount': ownAmount,
      'otherAmount': otherAmount,
      'dayOfWeek': dayOfWeek,
    };
  }
}
