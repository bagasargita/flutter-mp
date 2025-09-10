import 'package:smart_mob/core/api/api_client.dart';
import 'package:smart_mob/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_mob/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_mob/features/home/data/repositories/home_repository_impl.dart';
import 'package:smart_mob/features/home/domain/repositories/home_repository.dart';
import 'package:smart_mob/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smart_mob/features/profile/domain/repositories/profile_repository.dart';
import 'package:smart_mob/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:smart_mob/features/notifications/domain/repositories/notifications_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final ApiClient _apiClient;
  late final AuthRepository _authRepository;
  late final HomeRepository _homeRepository;
  late final ProfileRepository _profileRepository;
  late final NotificationsRepository _notificationsRepository;

  void init() {
    _apiClient = ApiClient.create();
    _authRepository = AuthRepositoryImpl(_apiClient);
    _homeRepository = HomeRepositoryImpl(_apiClient);
    _profileRepository = ProfileRepositoryImpl(_apiClient);
    _notificationsRepository = NotificationsRepositoryImpl(_apiClient);
  }

  ApiClient get apiClient => _apiClient;
  AuthRepository get authRepository => _authRepository;
  HomeRepository get homeRepository => _homeRepository;
  ProfileRepository get profileRepository => _profileRepository;
  NotificationsRepository get notificationsRepository =>
      _notificationsRepository;
}
