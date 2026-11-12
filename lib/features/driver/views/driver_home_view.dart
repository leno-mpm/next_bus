import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/trip_repository.dart';
import 'package:next_bus/features/driver/viewmodels/driver_home_viewmodel.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverHomeViewModel>(
      create: (ctx) => DriverHomeViewModel(
        driverRepository: ctx.read<DriverRepository>(),
        tripRepository: ctx.read<TripRepository>(),
        busRepository: ctx.read<BusRepository>(),
        routeRepository: ctx.read<RouteRepository>(),
      )..load(),
      child: const _DriverHomeBody(),
    );
  }
}

class _DriverHomeBody extends StatelessWidget {
  const _DriverHomeBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverHomeViewModel>();
    final trip = vm.trip;

    return Scaffold(
      appBar: AppBar(title: const Text('Panel del conductor')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null || trip == null
              ? EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Ocurrió un problema',
                  message: vm.errorMessage ?? 'Sin recorrido asignado.',
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vm.driver?.name ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Licencia ${vm.driver?.licenseId ?? ''}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(Icons.directions_bus_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                vm.assignedBus?.name ?? '—',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.alt_route_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${vm.assignedRoute?.name ?? '—'} · Sentido '
                                  '${vm.assignedRoute?.direction.label ?? ''}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Estado del recorrido',
                                    style: AppTextStyles.sectionTitle),
                                const Spacer(),
                                StatusBadge(
                                  label: trip.status.label,
                                  color: _statusColor(trip.status),
                                  background: _statusBg(trip.status),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _InfoLine(
                              label: 'Parada actual',
                              value: trip.currentStopId ?? '—',
                            ),
                            _InfoLine(
                              label: 'Próxima parada',
                              value: trip.nextStopId ?? '—',
                            ),
                            if (trip.startedAt != null)
                              _InfoLine(
                                label: 'Inicio',
                                value: _time(trip.startedAt!),
                              ),
                            if (trip.endedAt != null)
                              _InfoLine(
                                label: 'Fin',
                                value: _time(trip.endedAt!),
                              ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: trip.status ==
                                                TripStatus.noIniciado &&
                                            !vm.isUpdatingTrip
                                        ? () => context
                                            .read<DriverHomeViewModel>()
                                            .startTrip()
                                        : null,
                                    icon: const Icon(Icons.play_arrow_rounded),
                                    label: const Text('Iniciar recorrido'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: trip.status ==
                                                TripStatus.enCurso &&
                                            !vm.isUpdatingTrip
                                        ? () => context
                                            .read<DriverHomeViewModel>()
                                            .endTrip()
                                        : null,
                                    icon: const Icon(Icons.stop_rounded),
                                    label: const Text('Finalizar recorrido'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  String _time(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Color _statusColor(TripStatus status) => switch (status) {
        TripStatus.noIniciado => AppColors.grey,
        TripStatus.enCurso => AppColors.green,
        TripStatus.finalizado => AppColors.navy,
      };

  Color _statusBg(TripStatus status) => switch (status) {
        TripStatus.noIniciado => AppColors.greyBg,
        TripStatus.enCurso => AppColors.greenBg,
        TripStatus.finalizado => const Color(0xFFE3EAF2),
      };
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySecondary),
          Text(value, style: AppTextStyles.cardTitle),
        ],
      ),
    );
  }
}
