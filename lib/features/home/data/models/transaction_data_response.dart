import 'transaction_pagination.dart';

class TransactionDataResponse {
  final String timestamp;
  final int status;
  final String message;
  final TransactionPagination data;

  const TransactionDataResponse({
    required this.timestamp,
    required this.status,
    required this.message,
    required this.data,
  });

  factory TransactionDataResponse.fromJson(Map<String, dynamic> json) {
    return TransactionDataResponse(
      timestamp: json['timestamp'] as String,
      status: json['status'] as int,
      message: json['message'] as String,
      data: TransactionPagination.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}
