import 'package:equatable/equatable.dart';

abstract class TransactionDataEvent extends Equatable {
  const TransactionDataEvent();

  @override
  List<Object?> get props => [];
}

class TransactionDataRequested extends TransactionDataEvent {
  final List<String>? sort;
  final String? transactionDateFrom;
  final String? transactionDateTo;
  final String? transactionNo;

  const TransactionDataRequested({
    this.sort,
    this.transactionDateFrom,
    this.transactionDateTo,
    this.transactionNo,
  });

  @override
  List<Object?> get props => [sort, transactionDateFrom, transactionDateTo, transactionNo];
}

class TransactionDataLoadMore extends TransactionDataEvent {
  final List<String>? sort;
  final String? transactionDateFrom;
  final String? transactionDateTo;
  final String? transactionNo;

  const TransactionDataLoadMore({
    this.sort,
    this.transactionDateFrom,
    this.transactionDateTo,
    this.transactionNo,
  });

  @override
  List<Object?> get props => [sort, transactionDateFrom, transactionDateTo, transactionNo];
}

class TransactionDataRefresh extends TransactionDataEvent {
  final List<String>? sort;
  final String? transactionDateFrom;
  final String? transactionDateTo;
  final String? transactionNo;

  const TransactionDataRefresh({
    this.sort,
    this.transactionDateFrom,
    this.transactionDateTo,
    this.transactionNo,
  });

  @override
  List<Object?> get props => [sort, transactionDateFrom, transactionDateTo, transactionNo];
}

class TransactionDataFilterChanged extends TransactionDataEvent {
  final List<String>? sort;
  final String? transactionDateFrom;
  final String? transactionDateTo;
  final String? transactionNo;

  const TransactionDataFilterChanged({
    this.sort,
    this.transactionDateFrom,
    this.transactionDateTo,
    this.transactionNo,
  });

  @override
  List<Object?> get props => [sort, transactionDateFrom, transactionDateTo, transactionNo];
}
