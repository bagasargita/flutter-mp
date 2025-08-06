import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_mob/features/home/domain/usecases/get_services_usecase.dart';

class HomeState {
  final bool isLoading;
  final List<Map<String, dynamic>> services;
  final String? error;

  const HomeState({
    this.isLoading = false,
    this.services = const [],
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? services,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      services: services ?? this.services,
      error: error,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final GetServicesUseCase _getServicesUseCase;

  HomeNotifier({required GetServicesUseCase getServicesUseCase})
    : _getServicesUseCase = getServicesUseCase,
      super(const HomeState());

  Future<void> getServices() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getServicesUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (services) {
        state = state.copyWith(isLoading: false, services: services);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
