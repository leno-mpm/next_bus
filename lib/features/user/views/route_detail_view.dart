import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/features/user/viewmodels/route_detail_viewmodel.dart';
import 'package:next_bus/features/user/views/stop_detail_view.dart';

class RouteDetailView extends StatelessWidget {
  final String routeId;

  const RouteDetailView({super.key, required this.routeId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RouteDetailViewModel>(
      create: (ctx) => RouteDetailViewModel(
        routeId: routeId,
        routeRepository: ctx.read<RouteRepository>(),
        stopRepository: ctx.read<StopRepository>(),
      )..load(),
      child: const _RouteDetailBody(),
    );
  }
}

class _RouteDetailBody extends StatelessWidget {
  const _RouteDetailBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RouteDetailViewModel>();
    final route = vm.route;

    return Scaffold(
      appBar: AppBar(title: Text(route?.name ?? 'Detalle de ruta')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null || route == null
              ? EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Ocurrió un problema',
                  message: vm.errorMessage ?? 'Ruta no encontrada.',
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(route.name,
                                      style: AppTextStyles.title),
                                ),
                                StatusBadge(
                                  label: route.status.label,
                                  color: AppColors.green,
                                  background: AppColors.greenBg,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(route.id, style: AppTextStyles.caption),
                            const SizedBox(height: 10),
                            Text(route.description, style: AppTextStyles.body),
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
                                  label: '${route.stopCount} paradas',
                                  color: AppColors.textSecondary,
                                  background: AppColors.greyBg,
                                  icon: Icons.pin_drop_rounded,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Secuencia de paradas (provisional)',
                        style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 4),
                    Text(
                      'El orden mostrado es de demostración; se reemplazará '
                      'por el recorrido oficial cuando esté disponible.',
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 12),
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
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.navy,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            title: Text(stop.name,
                                style: AppTextStyles.body),
                            subtitle: Text(stop.id,
                                style: AppTextStyles.caption),
                            trailing: const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textSecondary),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    StopDetailView(stopId: stop.id),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
