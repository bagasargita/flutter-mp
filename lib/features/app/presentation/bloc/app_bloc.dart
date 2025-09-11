import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_mob/core/di/service_locator.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppInitialized>(_onAppInitialized);
    on<AppSplashFinished>(_onAppSplashFinished);
    on<AppOnboardingCompleted>(_onAppOnboardingCompleted);
    on<AppLoginRequested>(_onAppLoginRequested);
    on<AppLoginSuccess>(_onAppLoginSuccess);
    on<AppLogoutRequested>(_onAppLogoutRequested);
  }

  void _onAppInitialized(AppInitialized event, Emitter<AppState> emit) async {
    // Check if user is already authenticated
    final authRepository = ServiceLocator().authRepository;
    final result = await authRepository.getCurrentUser();

    result.fold(
      (failure) {
        // No saved user, stay unauthenticated
        emit(state.copyWith(hasSeenOnboarding: true));
      },
      (user) {
        if (user != null) {
          // User is authenticated, restore their state
          emit(
            state.copyWith(
              isAuthenticated: true,
              hasSeenOnboarding: true,
              userRoleMobile: user.roleMobile,
              userEmail: user.email,
              userName: user.name,
              selectedRole: user.roleMobile == 'CUSTOMER' ? 'CUSTOMER' : '',
            ),
          );
        } else {
          // No saved user
          emit(state.copyWith(hasSeenOnboarding: true));
        }
      },
    );
  }

  void _onAppSplashFinished(AppSplashFinished event, Emitter<AppState> emit) {
    emit(state.copyWith(showSplash: false));
  }

  void _onAppOnboardingCompleted(
    AppOnboardingCompleted event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(hasSeenOnboarding: true));
  }

  void _onAppLoginRequested(AppLoginRequested event, Emitter<AppState> emit) {
    emit(state.copyWith(isAuthenticated: true));
  }

  void _onAppLoginSuccess(AppLoginSuccess event, Emitter<AppState> emit) {
    emit(
      state.copyWith(
        isAuthenticated: true,
        userRoleMobile: event.userRoleMobile,
        userEmail: event.userEmail,
        userName: event.userName,
        selectedRole: event.selectedRole,
      ),
    );
  }

  void _onAppLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    emit(
      state.copyWith(
        isAuthenticated: false,
        userRoleMobile: '',
        userEmail: '',
        userName: '',
        selectedRole: '',
      ),
    );
  }
}
