import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/services/dashboard_service.dart';
import '../../data/models/dashboard_response.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DashboardService _dashboardService;

  HomeBloc({required DashboardService dashboardService})
    : _dashboardService = dashboardService,
      super(HomeInitial()) {
    on<HomeDataRequested>(_onHomeDataRequested);
    on<HomeRefreshRequested>(_onHomeRefreshRequested);
  }

  void _onHomeDataRequested(
    HomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    print('HomeBloc: Dashboard data requested');
    emit(HomeLoading());
    try {
      final dashboardResponse = await _dashboardService.getDashboard();
      print('HomeBloc: Dashboard data loaded successfully');
      emit(HomeLoaded(dashboardResponse: dashboardResponse));
    } catch (e) {
      print('HomeBloc: Error loading dashboard data: $e');
      emit(HomeFailure(message: e.toString()));
    }
  }

  void _onHomeRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    add(const HomeDataRequested());
  }
}
