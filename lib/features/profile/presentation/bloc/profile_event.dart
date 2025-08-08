part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileDataRequested extends ProfileEvent {
  const ProfileDataRequested();
}

class ProfileLogoutRequested extends ProfileEvent {
  const ProfileLogoutRequested();
}
