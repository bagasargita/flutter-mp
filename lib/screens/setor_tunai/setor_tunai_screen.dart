import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/widgets/setor_tunai/setor_tunai_services_grid.dart';

class SetorTunaiScreen extends StatefulWidget {
  const SetorTunaiScreen({super.key});

  @override
  State<SetorTunaiScreen> createState() => _SetorTunaiScreenState();
}

class _SetorTunaiScreenState extends State<SetorTunaiScreen> {
  void _onMachineSelected(Map<String, dynamic> machine) {
    print('Machine selected: $machine');
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
