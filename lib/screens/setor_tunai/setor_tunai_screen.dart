import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/widgets/setor_tunai/setor_tunai_services_grid.dart';
import 'package:smart_mob/widgets/setor_tunai/outstanding_transaction_card.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_machine_details_screen.dart';

class SetorTunaiScreen extends StatefulWidget {
  const SetorTunaiScreen({super.key});

  @override
  State<SetorTunaiScreen> createState() => _SetorTunaiScreenState();
}

class _SetorTunaiScreenState extends State<SetorTunaiScreen> {
  // State to track multiple outstanding transactions
  List<Map<String, dynamic>> _outstandingTransactions = [];

  void _onMachineSelected(Map<String, dynamic> machine) {
    setState(() {
      // Add new machine to outstanding transactions
      _outstandingTransactions.add(machine);
    });
  }

  void _clearOutstandingTransaction(int index) {
    setState(() {
      _outstandingTransactions.removeAt(index);
    });
  }

  void _clearAllOutstandingTransactions() {
    setState(() {
      _outstandingTransactions.clear();
    });
  }

  void _navigateToMachineDetails(Map<String, dynamic> machine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetorTunaiMachineDetailsScreen(
          machineName: machine['name'] ?? '',
          maxAmount: machine['maxAmount'] ?? '',
          distance: machine['distance'] ?? '',
          address: machine['address'] ?? '',
          isFromOutstanding: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'Setor Tunai', showBack: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SetorTunaiServicesGrid(
                        onMachineSelected: _onMachineSelected,
                      ),
                      const SizedBox(height: 24),
                      if (_outstandingTransactions.isNotEmpty)
                        Column(
                          children: _outstandingTransactions
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final machine = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        index <
                                            _outstandingTransactions.length - 1
                                        ? 16
                                        : 0,
                                  ),
                                  child: OutstandingTransactionCard(
                                    machine: machine,
                                    onClear: () =>
                                        _clearOutstandingTransaction(index),
                                    onStartDeposit: () =>
                                        _navigateToMachineDetails(machine),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
