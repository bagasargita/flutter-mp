import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeDataRequested>(_onHomeDataRequested);
    on<HomeRefreshRequested>(_onHomeRefreshRequested);
  }

  void _onHomeDataRequested(
    HomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final services = [
        {'name': 'Send Money', 'icon': 'assets/images/KirimUang.png'},
        {'name': 'Cash Deposit', 'icon': 'assets/images/SetorTunai.png'},
        {'name': 'PLN Electricity', 'icon': 'assets/images/ListrikPln.png'},
        {'name': 'Grocery Store', 'icon': 'assets/images/WarungGrosir.png'},
        {
          'name': 'Transaction History',
          'icon': 'assets/images/RiwayatTransaksi.png',
        },
        {'name': 'Other Services', 'icon': 'assets/images/IconLainnya.png'},
      ];

      emit(HomeLoaded(services: services));
    } catch (e) {
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
