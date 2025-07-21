import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState {
  final bool isAuthenticated;
  final bool hasSeenOnboarding;
  final bool showSplash;

  AppState({
    this.isAuthenticated = false,
    this.hasSeenOnboarding = false,
    this.showSplash = true,
  });

  AppState copyWith({
    bool? isAuthenticated,
    bool? hasSeenOnboarding,
    bool? showSplash,
  }) {
    return AppState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      showSplash: showSplash ?? this.showSplash,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void finishSplash() => state = state.copyWith(showSplash: false);
  void completeOnboarding() => state = state.copyWith(hasSeenOnboarding: true);
  void login() => state = state.copyWith(isAuthenticated: true);
  void logout() => state = state.copyWith(isAuthenticated: false);
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(),
);
