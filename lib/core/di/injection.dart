import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_mob/core/api/api_client.dart';
import 'package:smart_mob/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_mob/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_mob/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_mob/features/auth/domain/usecases/register_usecase.dart';
import 'package:smart_mob/features/home/data/repositories/home_repository_impl.dart';
import 'package:smart_mob/features/home/domain/repositories/home_repository.dart';
import 'package:smart_mob/features/home/domain/usecases/get_services_usecase.dart';
import 'package:smart_mob/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:smart_mob/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:smart_mob/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:smart_mob/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smart_mob/features/profile/domain/repositories/profile_repository.dart';
import 'package:smart_mob/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:smart_mob/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:smart_mob/features/auth/presentation/providers/auth_provider.dart';
import 'package:smart_mob/features/home/presentation/providers/home_provider.dart';
import 'package:smart_mob/features/profile/presentation/providers/profile_provider.dart';
import 'package:smart_mob/features/notifications/presentation/providers/notifications_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.create();
});

// Auth Feature
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepositoryImpl(apiClient);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

// Home Feature
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeRepositoryImpl(apiClient);
});

final getServicesUseCaseProvider = Provider<GetServicesUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetServicesUseCase(repository);
});

// Profile Feature
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRepositoryImpl(apiClient);
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repository);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateProfileUseCase(repository);
});

// Notifications Feature
final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationsRepositoryImpl(apiClient);
});

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((
  ref,
) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return GetNotificationsUseCase(repository);
});

// Auth Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final registerUseCase = ref.watch(registerUseCaseProvider);
  return AuthNotifier(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
  );
});

// Home Provider
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  final getServicesUseCase = ref.watch(getServicesUseCaseProvider);
  return HomeNotifier(getServicesUseCase: getServicesUseCase);
});

// Profile Provider
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      final getProfileUseCase = ref.watch(getProfileUseCaseProvider);
      final updateProfileUseCase = ref.watch(updateProfileUseCaseProvider);
      return ProfileNotifier(
        getProfileUseCase: getProfileUseCase,
        updateProfileUseCase: updateProfileUseCase,
      );
    });

// Notifications Provider
final notificationsNotifierProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
      final getNotificationsUseCase = ref.watch(
        getNotificationsUseCaseProvider,
      );
      return NotificationsNotifier(
        getNotificationsUseCase: getNotificationsUseCase,
      );
    });
