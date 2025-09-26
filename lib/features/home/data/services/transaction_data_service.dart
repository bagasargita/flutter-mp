import '../models/transaction_data_response.dart';
import '../../../../core/api/api_client.dart';
import 'package:dio/dio.dart';

class TransactionDataService {
  final ApiClient _apiClient;

  TransactionDataService(this._apiClient);

  Future<TransactionDataResponse> getTransactionData({
    int page = 0,
    int size = 10,
    List<String>? sort,
    String? transactionDateFrom,
    String? transactionDateTo,
    String? transactionNo,
  }) async {
    try {
      print('TransactionDataService: Fetching transaction data...');
      print('TransactionDataService: Page: $page, Size: $size');
      print('TransactionDataService: Sort: $sort');
      print(
        'TransactionDataService: TransactionDateFrom: $transactionDateFrom',
      );
      print('TransactionDataService: TransactionDateTo: $transactionDateTo');
      print('TransactionDataService: TransactionNo: $transactionNo');

      // Try alternative endpoints if transaction-data fails
      Response<Map<String, dynamic>>? response;
      try {
        response = await _apiClient.getTransactionData(
          page: page,
          size: size,
          sort: sort,
          transactionDateFrom: transactionDateFrom,
          transactionDateTo: transactionDateTo,
          transactionNo: transactionNo,
        );
      } catch (e) {
        print(
          'TransactionDataService: transaction-data failed, trying transactions/history...',
        );
        // Try transactions/history endpoint as fallback
        try {
          final historyResponse = await _apiClient.getTransactionHistory();
          // Convert List response to Map response format
          response = Response<Map<String, dynamic>>(
            data: {'transactions': historyResponse.data},
            statusCode: historyResponse.statusCode,
            statusMessage: historyResponse.statusMessage,
            requestOptions: historyResponse.requestOptions,
            headers: historyResponse.headers,
            isRedirect: historyResponse.isRedirect,
            redirects: historyResponse.redirects,
            extra: historyResponse.extra,
          );
        } catch (e2) {
          print(
            'TransactionDataService: transactions/history also failed, trying transactions...',
          );
          // Try basic transactions endpoint
          final transactionsResponse = await _apiClient.getTransactions();
          // Convert List response to Map response format
          response = Response<Map<String, dynamic>>(
            data: {'transactions': transactionsResponse.data},
            statusCode: transactionsResponse.statusCode,
            statusMessage: transactionsResponse.statusMessage,
            requestOptions: transactionsResponse.requestOptions,
            headers: transactionsResponse.headers,
            isRedirect: transactionsResponse.isRedirect,
            redirects: transactionsResponse.redirects,
            extra: transactionsResponse.extra,
          );
        }
      }

      print(
        'TransactionDataService: Response received - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 && response.data != null) {
        print('TransactionDataService: Parsing transaction data...');
        // Handle different response formats
        TransactionDataResponse transactionDataResponse;
        if (response.data!.containsKey('data') &&
            response.data!['data'] is Map) {
          // Standard paginated response
          transactionDataResponse = TransactionDataResponse.fromJson(
            response.data!,
          );
        } else {
          // Convert simple list to paginated format
          final transactions =
              response.data!['transactions'] as List<dynamic>? ?? [];
          final mockPagination = {
            'content': transactions,
            'page': page,
            'size': size,
            'totalElements': transactions.length,
            'totalPages': 1,
            'first': true,
            'last': true,
            'empty': transactions.isEmpty,
          };
          final mockResponse = {
            'timestamp': DateTime.now().toIso8601String(),
            'status': 200,
            'message': 'Transaction data loaded successfully',
            'data': mockPagination,
          };
          transactionDataResponse = TransactionDataResponse.fromJson(
            mockResponse,
          );
        }
        print('TransactionDataService: Transaction data parsed successfully');
        print(
          'TransactionDataService: Total elements: ${transactionDataResponse.data.totalElements}',
        );
        print(
          'TransactionDataService: Current page: ${transactionDataResponse.data.page}',
        );
        return transactionDataResponse;
      } else {
        throw Exception(
          'Failed to load transaction data: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('TransactionDataService: DioException - ${e.message}');
      print('TransactionDataService: DioException Type: ${e.type}');
      print(
        'TransactionDataService: DioException Response: ${e.response?.data}',
      );
      print(
        'TransactionDataService: DioException Status Code: ${e.response?.statusCode}',
      );
      print(
        'TransactionDataService: DioException Request URL: ${e.requestOptions.uri}',
      );
      print(
        'TransactionDataService: DioException Request Params: ${e.requestOptions.queryParameters}',
      );

      // If it's a 500 error, the server endpoint is not available
      if (e.response?.statusCode == 500) {
        print('TransactionDataService: Server returned 500, no data available');
        throw Exception(
          'Server error: Transaction data endpoint not available',
        );
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('TransactionDataService: Unexpected error - $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
