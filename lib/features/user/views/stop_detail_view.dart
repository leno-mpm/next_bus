import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/demo_banner.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/data/repositories/eta_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/features/user/viewmodels/stop_detail_viewmodel.dart';
import 'package:next_bus/features/user/widgets/bus_eta_card.dart';
import 'package:next_bus/features/user/widgets/route_schematic_view.dart';
import 'package:next_bus/features/user/widgets/scenario_selector.dart';

class StopDetailView extends StatelessWidget {
  final String stopId;

  const StopDetailView({super.key, required this.stopId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StopDetailViewModel>(
      create: (ctx) => StopDetailViewModel(
        initialStopId: stopId,
        stopRepository: ctx.read<StopRepository>(),
        routeRepository: ctx.read<RouteRepository>(),
        etaRepository: ctx.read<EtaRepository>(),
      )..load(),
      child: const _StopDetailBody(),
    );
  }
}

class _StopDetailBody extends StatelessWidget {
  const _StopDetailBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StopDetailViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(vm.stop?.name ?? 'Parada')),
      body: vm.errorMessage != null
          ? EmptyState(
              icon: Icons.error_outline_rounded,
              title: 'Ocurrió un problema',
              message: vm.errorMessage!,
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const DemoBanner(
                  text:
                      'Escenario simulado: ETA, estados y posiciones son de '
                      'demostración, no datos reales de GPS.',
                ),
                const SizedBox(height: 14),
                Text('Escenario de demostración',
                    style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                ScenarioSelector(
                  scenarios: vm.availableScenarios,
                  selected: vm.scenario,
                  onChanged: (value) =>
                      context.read<StopDetailViewModel>().selectScenario(value),
                ),
                const SizedBox(height: 6),
                Text(vm.scenarioExplanation,
                    style: AppTextStyles.bodySecondary),
                const SizedBox(height: 18),
                if (vm.stop != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Consultando parada: ${vm.stop!.name} (${vm.stop!.id})',
                          style: AppTextStyles.cardTitle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (vm.routesForStop.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: vm.routesForStop
                          .map((r) => StatusBadge(
                                label: '${r.name} · ${r.direction.label}',
                                color: AppColors.navy,
                                background: const Color(0xFFE3EAF2),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 18),
                ],
                if (vm.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (vm.orderedStopsForPrimaryRoute.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: RouteSchematicView(
                        orderedStops: vm.orderedStopsForPrimaryRoute,
                        highlightStopId: vm.stop?.id ?? '',
                        buses: vm.arrivals.map((a) => a.bus).toList(),
                        direction: vm.primaryRoute?.direction,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
                Text('Próximas llegadas', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 10),
                if (!vm.isLoading && vm.arrivals.isEmpty)
                  const EmptyState(
                    icon: Icons.directions_bus_rounded,
                    title: 'Ningún bus disponible',
                    message:
                        'No hay unidades en camino hacia esta parada en el '
                        'escenario seleccionado.',
                  )
                else
                  ...vm.arrivals.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: BusEtaCard(
                            arrival: entry.value,
                            index: entry.key,
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}
