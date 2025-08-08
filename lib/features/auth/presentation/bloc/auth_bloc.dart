import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_mob/features/auth/domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful login
      final user = User(
        id: '1',
        name: 'John Doe',
        email: event.email,
        phoneNumber: event.phone,
        memberStatus: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthUnauthenticated());
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    // Check if user is already authenticated
    // For now, we'll emit unauthenticated
    emit(AuthUnauthenticated());
  }
}
