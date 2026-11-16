import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/features/driver/viewmodels/incident_history_viewmodel.dart';
import 'package:next_bus/features/driver/views/report_incident_view.dart';
import 'package:next_bus/features/driver/widgets/incident_card.dart';

class IncidentHistoryView extends StatelessWidget {
  const IncidentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IncidentHistoryViewModel>(
      create: (ctx) => IncidentHistoryViewModel(
        incidentRepository: ctx.read<IncidentRepository>(),
        driverRepository: ctx.read<DriverRepository>(),
        shiftRepository: ctx.read<ShiftRepository>(),
      )..load(),
      child: const _IncidentHistoryBody(),
    );
  }
}

class _IncidentHistoryBody extends StatelessWidget {
  const _IncidentHistoryBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IncidentHistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ReportIncidentView()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<IncidentHistoryViewModel>().load(),
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null
                ? EmptyState(
                    icon: Icons.error_outline_rounded,
                    title: 'Ocurrió un problema',
                    message: vm.errorMessage!,
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: _StatTile(
                                  label: 'Abiertas', value: '${vm.openCount}')),
                          const SizedBox(width: 1),
                          Expanded(
                              child: _StatTile(
                                  label: 'Resueltas',
                                  value: '${vm.resolvedCount}')),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (vm.incidents.isEmpty)
                        const EmptyState(
                          icon: Icons.fact_check_outlined,
                          title: 'Sin eventualidades',
                          message:
                              'Todavía no se han registrado eventualidades hoy.',
                        )
                      else
                        ...vm.incidents.map((incident) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: IncidentCard(
                                incident: incident,
                                onResolve: () => context
                                    .read<IncidentHistoryViewModel>()
                                    .resolve(incident.id),
                              ),
                            )),
                    ],
                  ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.etaValue.copyWith(fontSize: 26)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
