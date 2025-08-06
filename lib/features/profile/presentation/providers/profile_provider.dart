import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_mob/features/auth/domain/entities/user.dart';
import 'package:smart_mob/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:smart_mob/features/profile/domain/usecases/update_profile_usecase.dart';

class ProfileState {
  final bool isLoading;
  final User? user;
  final String? error;

  const ProfileState({this.isLoading = false, this.user, this.error});

  ProfileState copyWith({bool? isLoading, User? user, String? error}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileNotifier({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       super(const ProfileState());

  Future<void> getProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getProfileUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
      },
    );
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _updateProfileUseCase(profileData);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
