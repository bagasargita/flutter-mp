part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppSplashFinished extends AppEvent {
  const AppSplashFinished();
}

class AppOnboardingCompleted extends AppEvent {
  const AppOnboardingCompleted();
}

class AppLoginRequested extends AppEvent {
  const AppLoginRequested();
}

class AppLoginSuccess extends AppEvent {
  final String userRoleMobile;
  final String userEmail;
  final String userName;
  final String selectedRole;

  const AppLoginSuccess({
    required this.userRoleMobile,
    required this.userEmail,
    required this.userName,
    required this.selectedRole,
  });

  @override
  List<Object> get props => [userRoleMobile, userEmail, userName, selectedRole];
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class AppInitialized extends AppEvent {
  const AppInitialized();
}
