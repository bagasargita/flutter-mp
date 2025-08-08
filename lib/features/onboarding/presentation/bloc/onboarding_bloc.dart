import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<OnboardingStarted>(_onOnboardingStarted);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<OnboardingSkipped>(_onOnboardingSkipped);
    on<OnboardingPageChanged>(_onOnboardingPageChanged);
  }

  void _onOnboardingStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingInProgress(currentPage: 0));
  }

  void _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingFinished());
  }

  void _onOnboardingSkipped(
    OnboardingSkipped event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingFinished());
  }

  void _onOnboardingPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      emit(OnboardingInProgress(currentPage: event.pageIndex));
    }
  }
}
