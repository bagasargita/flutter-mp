import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:merah_putih/features/auth/domain/entities/user.dart';
import 'package:merah_putih/features/auth/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthUpdateProfile>(_onAuthUpdateProfile);
  }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.login(
      identifier: event.identifier,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('AuthBloc: Clearing all user data and state...');

    try {
      // Clear saved user data
      final result = await _authRepository.clearUser();
      result.fold(
        (failure) =>
            print('AuthBloc: Failed to clear user data: ${failure.message}'),
        (_) => print('AuthBloc: User data cleared successfully'),
      );

      // Emit unauthenticated state
      emit(AuthUnauthenticated());
      print('AuthBloc: State cleared and set to unauthenticated');
    } catch (e) {
      print('AuthBloc: Error during logout: $e');
      // Still emit unauthenticated even if there's an error
      emit(AuthUnauthenticated());
    }
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Check if user is already authenticated
    final result = await _authRepository.getCurrentUser();

    result.fold((failure) => emit(AuthUnauthenticated()), (user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  void _onAuthUpdateProfile(
    AuthUpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    // Update the user data in the current state
    final result = await _authRepository.saveUser(event.user);
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (_) => emit(AuthAuthenticated(user: event.user)),
    );
  }
}
