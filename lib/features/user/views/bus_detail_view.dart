import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/big_stat_card.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/segmented_control.dart';
import 'package:next_bus/core/widgets/usage_bar.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/features/user/viewmodels/bus_detail_viewmodel.dart';

class BusDetailView extends StatelessWidget {
  final String busId;
  const BusDetailView({super.key, required this.busId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BusDetailViewModel>(
      create: (ctx) => BusDetailViewModel(
        initialBusId: busId,
        busRepository: ctx.read<BusRepository>(),
        routeRepository: ctx.read<RouteRepository>(),
        stopRepository: ctx.read<StopRepository>(),
        driverRepository: ctx.read<DriverRepository>(),
        incidentRepository: ctx.read<IncidentRepository>(),
      )..load(),
      child: const _BusDetailBody(),
    );
  }
}

class _BusDetailBody extends StatelessWidget {
  const _BusDetailBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BusDetailViewModel>();
    final bus = vm.selectedBus;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de bus')),
      body: vm.errorMessage != null
          ? EmptyState(
              icon: Icons.error_outline_rounded,
              title: 'Ocurrió un problema',
              message: vm.errorMessage!,
            )
          : vm.isLoading && vm.buses.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SegmentedControl<String>(
                      options: [
                        for (final b in vm.buses)
                          SegmentOption(value: b.id, label: 'Bus ${b.name}'),
                      ],
                      value: vm.selectedBusId,
                      onChanged: (id) =>
                          context.read<BusDetailViewModel>().selectBus(id),
                    ),
                    const SizedBox(height: 18),
                    if (bus != null) ...[
                      if (vm.openDelayMinutes > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.orangeBg,
                              border: Border.all(
                                  color: AppColors.orange.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    size: 18, color: AppColors.orange),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Retraso acumulado de ${vm.openDelayMinutes} min '
                                    'por eventualidades abiertas.',
                                    style: AppTextStyles.bodySecondary
                                        .copyWith(color: AppColors.orange),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      BigStatCard(
                        kicker: bus.plate,
                        title: 'Bus ${bus.name}',
                        tagText: bus.status.label,
                        tagBg: AppColors.bgForBusStatus(bus.status),
                        tagFg: AppColors.forBusStatus(bus.status),
                        big: '${bus.passengerCount}',
                        bigSub: 'pasajeros de ${bus.capacity}',
                        bottom: UsageBar(
                          pct: bus.passengerCount / bus.capacity,
                          color: Colors.white,
                          trackColor: AppColors.accent700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _InfoGrid(
                        driverName: vm.driver?.name,
                        plate: bus.plate,
                      ),
                      const SizedBox(height: 18),
                      Text('Próximas paradas', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 8),
                      if (vm.upcomingStops.isEmpty)
                        const EmptyState(
                          icon: Icons.pin_drop_outlined,
                          title: 'Sin ruta asignada',
                          message: 'Esta unidad no tiene paradas próximas.',
                        )
                      else
                        ...vm.upcomingStops.map((u) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${u.stop.id} · ${u.stop.name}',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.body,
                                    ),
                                  ),
                                  Text('${u.etaMinutes} min',
                                      style: AppTextStyles.cardTitle),
                                ],
                              ),
                            )),
                    ],
                  ],
                ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final String? driverName;
  final String plate;
  const _InfoGrid({required this.driverName, required this.plate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _InfoTile(label: 'Conductor', value: driverName ?? '—')),
        const SizedBox(width: 1),
        Expanded(child: _InfoTile(label: 'Placa', value: plate)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.cardTitle),
        ],
      ),
    );
  }
}
