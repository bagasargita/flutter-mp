import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/transaction_data_event.dart';
import '../bloc/transaction_data_state.dart';
import '../../data/services/transaction_data_service.dart';

class TransactionDataBloc extends Bloc<TransactionDataEvent, TransactionDataState> {
  final TransactionDataService _transactionDataService;

  TransactionDataBloc({required TransactionDataService transactionDataService})
      : _transactionDataService = transactionDataService,
        super(TransactionDataInitial()) {
    on<TransactionDataRequested>(_onTransactionDataRequested);
    on<TransactionDataLoadMore>(_onTransactionDataLoadMore);
    on<TransactionDataRefresh>(_onTransactionDataRefresh);
    on<TransactionDataFilterChanged>(_onTransactionDataFilterChanged);
  }

  void _onTransactionDataRequested(
    TransactionDataRequested event,
    Emitter<TransactionDataState> emit,
  ) async {
    print('TransactionDataBloc: Transaction data requested');
    emit(TransactionDataLoading());
    try {
      final transactionDataResponse = await _transactionDataService.getTransactionData(
        page: 0,
        size: 10,
        sort: event.sort,
        transactionDateFrom: event.transactionDateFrom,
        transactionDateTo: event.transactionDateTo,
        transactionNo: event.transactionNo,
      );
      print('TransactionDataBloc: Transaction data loaded successfully');
      emit(TransactionDataLoaded(
        transactions: transactionDataResponse.data.content,
        currentPage: transactionDataResponse.data.page,
        totalPages: transactionDataResponse.data.totalPages,
        hasMore: !transactionDataResponse.data.last,
        totalElements: transactionDataResponse.data.totalElements,
      ));
    } catch (e) {
      print('TransactionDataBloc: Error loading transaction data: $e');
      emit(TransactionDataFailure(message: e.toString()));
    }
  }

  void _onTransactionDataLoadMore(
    TransactionDataLoadMore event,
    Emitter<TransactionDataState> emit,
  ) async {
    if (state is! TransactionDataLoaded) return;
    
    final currentState = state as TransactionDataLoaded;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    print('TransactionDataBloc: Loading more transaction data...');
    emit(currentState.copyWith(isLoadingMore: true));
    
    try {
      final transactionDataResponse = await _transactionDataService.getTransactionData(
        page: currentState.currentPage + 1,
        size: 10,
        sort: event.sort,
        transactionDateFrom: event.transactionDateFrom,
        transactionDateTo: event.transactionDateTo,
        transactionNo: event.transactionNo,
      );
      
      print('TransactionDataBloc: More transaction data loaded successfully');
      final newTransactions = [
        ...currentState.transactions,
        ...transactionDataResponse.data.content,
      ];
      
      emit(TransactionDataLoaded(
        transactions: newTransactions,
        currentPage: transactionDataResponse.data.page,
        totalPages: transactionDataResponse.data.totalPages,
        hasMore: !transactionDataResponse.data.last,
        totalElements: transactionDataResponse.data.totalElements,
        isLoadingMore: false,
      ));
    } catch (e) {
      print('TransactionDataBloc: Error loading more transaction data: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  void _onTransactionDataRefresh(
    TransactionDataRefresh event,
    Emitter<TransactionDataState> emit,
  ) async {
    print('TransactionDataBloc: Refreshing transaction data...');
    add(TransactionDataRequested(
      sort: event.sort,
      transactionDateFrom: event.transactionDateFrom,
      transactionDateTo: event.transactionDateTo,
      transactionNo: event.transactionNo,
    ));
  }

  void _onTransactionDataFilterChanged(
    TransactionDataFilterChanged event,
    Emitter<TransactionDataState> emit,
  ) async {
    print('TransactionDataBloc: Filter changed, refreshing data...');
    add(TransactionDataRequested(
      sort: event.sort,
      transactionDateFrom: event.transactionDateFrom,
      transactionDateTo: event.transactionDateTo,
      transactionNo: event.transactionNo,
    ));
  }
}
