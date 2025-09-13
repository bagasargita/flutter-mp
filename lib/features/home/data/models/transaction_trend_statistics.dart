class TransactionTrendStatistics {
  final int averageDailyAmount;
  final int averageDailyCount;
  final int averageOwnAmount;
  final int averageOtherAmount;
  final HighestDay highestDay;
  final LowestDay lowestDay;

  const TransactionTrendStatistics({
    required this.averageDailyAmount,
    required this.averageDailyCount,
    required this.averageOwnAmount,
    required this.averageOtherAmount,
    required this.highestDay,
    required this.lowestDay,
  });

  factory TransactionTrendStatistics.fromJson(Map<String, dynamic> json) {
    print('TransactionTrendStatistics: Parsing JSON - ${json.keys}');
    print(
      'TransactionTrendStatistics: AverageDailyAmount - ${json['averageDailyAmount']}',
    );
    print(
      'TransactionTrendStatistics: AverageDailyCount - ${json['averageDailyCount']}',
    );
    print(
      'TransactionTrendStatistics: AverageOwnAmount - ${json['averageOwnAmount']}',
    );
    print(
      'TransactionTrendStatistics: AverageOtherAmount - ${json['averageOtherAmount']}',
    );
    print(
      'TransactionTrendStatistics: HighestDay keys - ${json['highestDay']?.keys}',
    );
    print(
      'TransactionTrendStatistics: LowestDay keys - ${json['lowestDay']?.keys}',
    );

    return TransactionTrendStatistics(
      averageDailyAmount: json['averageDailyAmount'] as int,
      averageDailyCount: json['averageDailyCount'] as int,
      averageOwnAmount: json['averageOwnAmount'] as int,
      averageOtherAmount: json['averageOtherAmount'] as int,
      highestDay: HighestDay.fromJson(
        json['highestDay'] as Map<String, dynamic>,
      ),
      lowestDay: LowestDay.fromJson(json['lowestDay'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageDailyAmount': averageDailyAmount,
      'averageDailyCount': averageDailyCount,
      'averageOwnAmount': averageOwnAmount,
      'averageOtherAmount': averageOtherAmount,
      'highestDay': highestDay.toJson(),
      'lowestDay': lowestDay.toJson(),
    };
  }
}

class HighestDay {
  final String date;
  final int amount;
  final int count;
  final int ownAmount;
  final int otherAmount;

  const HighestDay({
    required this.date,
    required this.amount,
    required this.count,
    required this.ownAmount,
    required this.otherAmount,
  });

  factory HighestDay.fromJson(Map<String, dynamic> json) {
    print('HighestDay: Parsing JSON - ${json.keys}');
    print('HighestDay: Date - ${json['date']}');
    print('HighestDay: Amount - ${json['amount']}');
    print('HighestDay: Count - ${json['count']}');
    print('HighestDay: OwnAmount - ${json['ownAmount']}');
    print('HighestDay: OtherAmount - ${json['otherAmount']}');

    return HighestDay(
      date: json['date'] as String,
      amount: json['amount'] as int,
      count: json['count'] as int,
      ownAmount: json['ownAmount'] as int,
      otherAmount: json['otherAmount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'count': count,
      'ownAmount': ownAmount,
      'otherAmount': otherAmount,
    };
  }
}

class LowestDay {
  final String date;
  final int amount;
  final int count;
  final int ownAmount;
  final int otherAmount;

  const LowestDay({
    required this.date,
    required this.amount,
    required this.count,
    required this.ownAmount,
    required this.otherAmount,
  });

  factory LowestDay.fromJson(Map<String, dynamic> json) {
    return LowestDay(
      date: json['date'] as String,
      amount: json['amount'] as int,
      count: json['count'] as int,
      ownAmount: json['ownAmount'] as int,
      otherAmount: json['otherAmount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'count': count,
      'ownAmount': ownAmount,
      'otherAmount': otherAmount,
    };
  }
}
