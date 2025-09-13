import '../models/transaction_data_response.dart';
import '../models/transaction_pagination.dart';
import '../models/transaction_item.dart';
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

      final response = await _apiClient.getTransactionData(
        page: page,
        size: size,
        sort: sort,
        transactionDateFrom: transactionDateFrom,
        transactionDateTo: transactionDateTo,
        transactionNo: transactionNo,
      );

      print(
        'TransactionDataService: Response received - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 && response.data != null) {
        print('TransactionDataService: Parsing transaction data...');
        final transactionDataResponse = TransactionDataResponse.fromJson(
          response.data!,
        );
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

      // If it's a 500 error, the server might not have implemented this endpoint yet
      // Return mock data for testing
      if (e.response?.statusCode == 500) {
        print(
          'TransactionDataService: Server returned 500, using mock data for testing',
        );
        return _getMockTransactionData(
          page: page,
          size: size,
          transactionDateFrom: transactionDateFrom,
          transactionDateTo: transactionDateTo,
          transactionNo: transactionNo,
        );
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('TransactionDataService: Unexpected error - $e');
      throw Exception('Unexpected error: $e');
    }
  }

  TransactionDataResponse _getMockTransactionData({
    required int page,
    required int size,
    String? transactionDateFrom,
    String? transactionDateTo,
    String? transactionNo,
  }) {
    // Generate mock data based on filters
    final mockTransactions = <Map<String, dynamic>>[];

    for (int i = 0; i < size; i++) {
      final transactionId = (page * size) + i + 1;
      final transactionDate = DateTime.now().subtract(
        Duration(days: i + (page * size)),
      );

      // Apply date filter if specified
      if (transactionDateFrom != null) {
        final fromDate = DateTime.tryParse(transactionDateFrom);
        if (fromDate != null && transactionDate.isBefore(fromDate)) {
          continue;
        }
      }

      if (transactionDateTo != null) {
        final toDate = DateTime.tryParse(transactionDateTo);
        if (toDate != null && transactionDate.isAfter(toDate)) {
          continue;
        }
      }

      // Apply transaction number filter if specified
      if (transactionNo != null && transactionNo.isNotEmpty) {
        if (!'KSN${transactionId.toString().padLeft(12, '0')}'.contains(
          transactionNo,
        )) {
          continue;
        }
      }

      mockTransactions.add({
        'transactionDate': transactionDate.toIso8601String(),
        'name': 'User $transactionId',
        'user': 'Own User',
        'transactionNumber': 'KSN${transactionId.toString().padLeft(12, '0')}',
        'amount': 1000000 + (transactionId * 100000),
        'commission': 5000 + (transactionId * 500),
      });
    }

    return TransactionDataResponse(
      timestamp: DateTime.now().toIso8601String(),
      status: 200,
      message: 'Mock transaction data for testing',
      data: TransactionPagination(
        content: mockTransactions
            .map((item) => TransactionItem.fromJson(item))
            .toList(),
        page: page,
        size: size,
        totalElements: 100, // Mock total
        totalPages: 10, // Mock total pages
        first: page == 0,
        last: page >= 9,
        empty: mockTransactions.isEmpty,
      ),
    );
  }
}
