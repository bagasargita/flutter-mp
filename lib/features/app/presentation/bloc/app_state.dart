part of 'app_bloc.dart';

class AppState extends Equatable {
  final bool isAuthenticated;
  final bool hasSeenOnboarding;
  final bool showSplash;

  const AppState({
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

  @override
  List<Object> get props => [isAuthenticated, hasSeenOnboarding, showSplash];
}
