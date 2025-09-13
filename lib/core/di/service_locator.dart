import 'package:smart_mob/core/api/api_client.dart';
import 'package:smart_mob/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_mob/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_mob/features/home/data/repositories/home_repository_impl.dart';
import 'package:smart_mob/features/home/domain/repositories/home_repository.dart';
import 'package:smart_mob/features/home/data/services/dashboard_service.dart';
import 'package:smart_mob/features/home/data/services/transaction_data_service.dart';
import 'package:smart_mob/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smart_mob/features/profile/domain/repositories/profile_repository.dart';
import 'package:smart_mob/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:smart_mob/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:smart_mob/features/setor_tunai/data/services/beneficiary_account_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal() {
    _init();
  }

  late final ApiClient _apiClient;
  late final AuthRepository _authRepository;
  late final HomeRepository _homeRepository;
  late final DashboardService _dashboardService;
  late final TransactionDataService _transactionDataService;
  late final ProfileRepository _profileRepository;
  late final NotificationsRepository _notificationsRepository;
  late final BeneficiaryAccountService _beneficiaryAccountService;

  void _init() {
    _apiClient = ApiClient.create();
    _authRepository = AuthRepositoryImpl(_apiClient);
    _homeRepository = HomeRepositoryImpl(_apiClient);
    _dashboardService = DashboardService(_apiClient);
    _transactionDataService = TransactionDataService(_apiClient);
    _profileRepository = ProfileRepositoryImpl(_apiClient);
    _notificationsRepository = NotificationsRepositoryImpl(_apiClient);
    _beneficiaryAccountService = BeneficiaryAccountService(_apiClient);
  }

  void init() {
    // Already initialized in constructor
  }

  ApiClient get apiClient => _apiClient;
  AuthRepository get authRepository => _authRepository;
  HomeRepository get homeRepository => _homeRepository;
  DashboardService get dashboardService => _dashboardService;
  TransactionDataService get transactionDataService => _transactionDataService;
  ProfileRepository get profileRepository => _profileRepository;
  NotificationsRepository get notificationsRepository =>
      _notificationsRepository;
  BeneficiaryAccountService get beneficiaryAccountService =>
      _beneficiaryAccountService;
}
