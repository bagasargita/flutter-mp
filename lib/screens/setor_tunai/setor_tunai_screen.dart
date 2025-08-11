import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/widgets/setor_tunai/setor_tunai_services_grid.dart';
import 'package:smart_mob/widgets/setor_tunai/outstanding_transaction_card.dart';

class SetorTunaiScreen extends StatefulWidget {
  const SetorTunaiScreen({super.key});

  @override
  State<SetorTunaiScreen> createState() => _SetorTunaiScreenState();
}

class _SetorTunaiScreenState extends State<SetorTunaiScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'SMARTMobs'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SetorTunaiServicesGrid(),
                      const SizedBox(height: 24),
                      const OutstandingTransactionCard(),
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
