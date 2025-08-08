import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileDataRequested>(_onProfileDataRequested);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
  }

  void _onProfileDataRequested(
    ProfileDataRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock profile data
      final profileData = {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+6281234567890',
        'avatar': 'assets/images/profile_avatar.png',
        'balance': 'Rp 1,250,000',
        'memberSince': 'January 2024',
      };

      emit(ProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(ProfileFailure(message: e.toString()));
    }
  }

  void _onProfileLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileLogout());
  }
}
