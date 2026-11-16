import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/data/repositories/eta_repository.dart';
import 'package:next_bus/data/repositories/preferences_repository.dart';
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
                if (vm.stop != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${vm.stop!.name} (${vm.stop!.id})',
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
                                color: AppColors.accent900,
                                background: AppColors.accent100,
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 14),
                  _NotifyToggle(stopId: vm.stop!.id),
                  const SizedBox(height: 18),
                ],
                if (vm.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (vm.orderedStopsForPrimaryRoute.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration:
                        BoxDecoration(border: Border.all(color: AppColors.neutral300)),
                    child: RouteSchematicView(
                      orderedStops: vm.orderedStopsForPrimaryRoute,
                      highlightStopId: vm.stop?.id ?? '',
                      buses: vm.arrivals.map((a) => a.bus).toList(),
                      direction: vm.primaryRoute?.direction,
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
                const SizedBox(height: 10),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text('Modo demostración', style: AppTextStyles.caption),
                  subtitle: Text(vm.scenarioExplanation,
                      style: AppTextStyles.caption),
                  children: [
                    ScenarioSelector(
                      scenarios: vm.availableScenarios,
                      selected: vm.scenario,
                      onChanged: (value) => context
                          .read<StopDetailViewModel>()
                          .selectScenario(value),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
    );
  }
}

class _NotifyToggle extends StatefulWidget {
  final String stopId;
  const _NotifyToggle({required this.stopId});

  @override
  State<_NotifyToggle> createState() => _NotifyToggleState();
}

class _NotifyToggleState extends State<_NotifyToggle> {
  bool _value = false;
  late final String _key = 'notify3min:${widget.stopId}';

  @override
  void initState() {
    super.initState();
    context.read<PreferencesRepository>().getToggle(_key).then((value) {
      if (mounted) setState(() => _value = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Avisarme cuando falten 3 min', style: AppTextStyles.cardTitle),
                Text('Notificación local para esta parada',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(
            value: _value,
            onChanged: (value) {
              setState(() => _value = value);
              context.read<PreferencesRepository>().setToggle(_key, value);
            },
          ),
        ],
      ),
    );
  }
}
