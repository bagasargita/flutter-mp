class ApiEndpoints {
  static const String baseUrl = 'https://api.smartmob.com/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

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
}
