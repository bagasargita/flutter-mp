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

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}
