class ApiEndpoints {
  static const String host = 'http://103.23.199.26:8085';
  static const String baseUrl = 'http://103.23.199.26:8085/mobile/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String createQr = '/create-qr';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';

  // Notifications endpoints
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/mark-read';

  // Services endpoints
  static const String services = '/services';
  static const String serviceCategories = '/services/categories';

  // Transactions endpoints
  static const String transactions = '/transactions';
  static const String transactionHistory = '/transactions/history';
  static const String depositTransactions = '/deposit-transaction';
  // Machine/location endpoints
  static const String machineLocations = '/machine-location';

  // Dashboard endpoints
  static const String dashboard = '/home/dashboard';
  static const String transactionData = '/transaction-data';

  // Beneficiary account endpoints
  static const String beneficiaryAccount =
      'http://103.23.199.26:8085/mobile/beneficiary-account';
}
