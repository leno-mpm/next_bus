import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/data/repositories/trip_repository.dart';
import 'package:next_bus/features/driver/viewmodels/my_trip_viewmodel.dart';

class MyTripView extends StatelessWidget {
  const MyTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyTripViewModel>(
      create: (ctx) => MyTripViewModel(
        driverRepository: ctx.read<DriverRepository>(),
        tripRepository: ctx.read<TripRepository>(),
        routeRepository: ctx.read<RouteRepository>(),
        stopRepository: ctx.read<StopRepository>(),
      )..load(),
      child: const _MyTripBody(),
    );
  }
}

class _MyTripBody extends StatelessWidget {
  const _MyTripBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyTripViewModel>();
    final trip = vm.trip;
    final route = vm.route;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi recorrido')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null || trip == null || route == null
              ? EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Ocurrió un problema',
                  message: vm.errorMessage ?? 'Sin recorrido asignado.',
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(route.name, style: AppTextStyles.title),
                            const SizedBox(height: 4),
                            Text(route.description,
                                style: AppTextStyles.bodySecondary),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                StatusBadge(
                                  label: 'Sentido ${route.direction.label}',
                                  color: AppColors.navy,
                                  background: const Color(0xFFE3EAF2),
                                  icon: Icons.swap_vert_rounded,
                                ),
                                const SizedBox(width: 8),
                                StatusBadge(
                                  label: trip.status.label,
                                  color: AppColors.green,
                                  background: AppColors.greenBg,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _StatusCard(
                            label: 'Parada actual',
                            value: trip.currentStopId ?? '—',
                            icon: Icons.location_on_rounded,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatusCard(
                            label: 'Próxima parada',
                            value: trip.nextStopId ?? '—',
                            icon: Icons.arrow_forward_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('Secuencia de paradas',
                        style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 10),
                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: vm.orderedStops.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, indent: 56),
                        itemBuilder: (context, index) {
                          final stop = vm.orderedStops[index];
                          final isCurrent = stop.id == trip.currentStopId;
                          final isNext = stop.id == trip.nextStopId;
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  isCurrent ? AppColors.green : AppColors.navy,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            title: Text(stop.name, style: AppTextStyles.body),
                            subtitle: Text(stop.id, style: AppTextStyles.caption),
                            trailing: isCurrent
                                ? const StatusBadge(
                                    label: 'Actual',
                                    color: AppColors.green,
                                    background: AppColors.greenBg,
                                  )
                                : isNext
                                    ? const StatusBadge(
                                        label: 'Próxima',
                                        color: AppColors.navy,
                                        background: Color(0xFFE3EAF2),
                                      )
                                    : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatusCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.navy),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.cardTitle),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
