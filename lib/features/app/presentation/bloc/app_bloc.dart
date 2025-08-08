import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppSplashFinished>(_onAppSplashFinished);
    on<AppOnboardingCompleted>(_onAppOnboardingCompleted);
    on<AppLoginRequested>(_onAppLoginRequested);
    on<AppLogoutRequested>(_onAppLogoutRequested);
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

  void _onAppLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    emit(state.copyWith(isAuthenticated: false));
  }
}
