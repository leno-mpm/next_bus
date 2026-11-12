import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/features/driver/viewmodels/incident_history_viewmodel.dart';
import 'package:next_bus/features/driver/widgets/incident_card.dart';

class IncidentHistoryView extends StatelessWidget {
  const IncidentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IncidentHistoryViewModel>(
      create: (ctx) => IncidentHistoryViewModel(
        incidentRepository: ctx.read<IncidentRepository>(),
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
      appBar: AppBar(title: const Text('Historial de incidencias')),
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
                : vm.incidents.isEmpty
                    ? const EmptyState(
                        icon: Icons.fact_check_outlined,
                        title: 'Sin incidencias',
                        message: 'Todavía no se han registrado incidencias.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: vm.incidents.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            IncidentCard(incident: vm.incidents[index]),
                      ),
      ),
    );
  }
}
