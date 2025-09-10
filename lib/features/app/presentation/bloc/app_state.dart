part of 'app_bloc.dart';

class AppState extends Equatable {
  final bool isAuthenticated;
  final bool hasSeenOnboarding;
  final bool showSplash;
  final String userRoleMobile;
  final String userEmail;
  final String userName;
  final String selectedRole;
  const AppState({
    this.isAuthenticated = false,
    this.hasSeenOnboarding = false,
    this.showSplash = true,
    this.userRoleMobile = '',
    this.userEmail = '',
    this.userName = '',
    this.selectedRole = '',
  });

  AppState copyWith({
    bool? isAuthenticated,
    bool? hasSeenOnboarding,
    bool? showSplash,
    String? userRoleMobile,
    String? userEmail,
    String? userName,
    String? selectedRole,
  }) {
    return AppState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      showSplash: showSplash ?? this.showSplash,
      userRoleMobile: userRoleMobile ?? this.userRoleMobile,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }

  @override
  List<Object> get props => [
    isAuthenticated,
    hasSeenOnboarding,
    showSplash,
    userRoleMobile,
    userEmail,
    userName,
    selectedRole,
  ];
}
