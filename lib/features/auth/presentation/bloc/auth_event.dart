part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String identifier;
  final String password;

  const AuthLoginRequested({required this.identifier, required this.password});

  @override
  List<Object> get props => [identifier, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthUpdateProfile extends AuthEvent {
  final User user;

  const AuthUpdateProfile(this.user);

  @override
  List<Object> get props => [user];
}