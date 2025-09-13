class TransactionItem {
  final String transactionDate;
  final String name;
  final String user;
  final String transactionNumber;
  final int amount;
  final int commission;

  const TransactionItem({
    required this.transactionDate,
    required this.name,
    required this.user,
    required this.transactionNumber,
    required this.amount,
    required this.commission,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      transactionDate: json['transactionDate'] as String,
      name: json['name'] as String,
      user: json['user'] as String,
      transactionNumber: json['transactionNumber'] as String,
      amount: json['amount'] as int,
      commission: json['commission'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionDate': transactionDate,
      'name': name,
      'user': user,
      'transactionNumber': transactionNumber,
      'amount': amount,
      'commission': commission,
    };
  }
}
