import 'package:equatable/equatable.dart';
import '../../data/models/transaction_item.dart';

abstract class TransactionDataState extends Equatable {
  const TransactionDataState();

  @override
  List<Object?> get props => [];
}

class TransactionDataInitial extends TransactionDataState {}

class TransactionDataLoading extends TransactionDataState {}

class TransactionDataLoaded extends TransactionDataState {
  final List<TransactionItem> transactions;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final int totalElements;
  final bool isLoadingMore;

  const TransactionDataLoaded({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.totalElements,
    this.isLoadingMore = false,
  });

  TransactionDataLoaded copyWith({
    List<TransactionItem>? transactions,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    int? totalElements,
    bool? isLoadingMore,
  }) {
    return TransactionDataLoaded(
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      totalElements: totalElements ?? this.totalElements,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        currentPage,
        totalPages,
        hasMore,
        totalElements,
        isLoadingMore,
      ];
}

class TransactionDataFailure extends TransactionDataState {
  final String message;

  const TransactionDataFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
