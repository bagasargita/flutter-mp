part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingInProgress extends OnboardingState {
  final int currentPage;

  const OnboardingInProgress({required this.currentPage});

  @override
  List<Object> get props => [currentPage];
}

class OnboardingFinished extends OnboardingState {
  const OnboardingFinished();
}
