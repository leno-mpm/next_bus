import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/segmented_control.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/features/user/viewmodels/stops_viewmodel.dart';
import 'package:next_bus/features/user/views/bus_detail_view.dart';
import 'package:next_bus/features/user/views/stop_detail_view.dart';
import 'package:next_bus/features/user/widgets/stop_card.dart';
import 'package:next_bus/models/bus.dart';

class StopsView extends StatelessWidget {
  const StopsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StopsViewModel>(
      create: (ctx) => StopsViewModel(
        stopRepository: ctx.read<StopRepository>(),
        busRepository: ctx.read<BusRepository>(),
        routeRepository: ctx.read<RouteRepository>(),
      )..load(),
      child: const _StopsBody(),
    );
  }
}

class _StopsBody extends StatelessWidget {
  const _StopsBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StopsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Paradas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: SegmentedControl<String?>(
              options: [
                const SegmentOption(value: null, label: 'Todas'),
                for (final bus in vm.buses)
                  SegmentOption(value: bus.id, label: 'Bus ${bus.name}'),
              ],
              value: vm.busFilterId,
              onChanged: (value) =>
                  context.read<StopsViewModel>().setBusFilter(value),
            ),
          ),
          if (vm.busFilterId == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                onChanged: vm.setQuery,
                decoration: const InputDecoration(
                  hintText: 'Buscar por nombre o identificador...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Circuito completo de Bus ${vm.busFilterId} con su posición actual.',
                style: AppTextStyles.caption,
              ),
            ),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.errorMessage != null
                    ? EmptyState(
                        icon: Icons.error_outline_rounded,
                        title: 'Ocurrió un problema',
                        message: vm.errorMessage!,
                      )
                    : vm.rows.isEmpty
                        ? const EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'Sin resultados',
                            message: 'No se encontró ninguna parada.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: vm.rows.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final row = vm.rows[index];
                              if (row.isBusMarker) {
                                return _BusMarkerRow(bus: row.busMarker!);
                              }
                              return StopCard(
                                stop: row.stop!,
                                trailing: row.etaMinutes == null
                                    ? null
                                    : '${row.etaMinutes} min',
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        StopDetailView(stopId: row.stop!.id),
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

class _BusMarkerRow extends StatelessWidget {
  final Bus bus;
  const _BusMarkerRow({required this.bus});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BusDetailView(busId: bus.id)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        color: AppColors.accent900,
        child: Row(
          children: [
            Icon(Icons.directions_bus_rounded, size: 16, color: AppColors.bg),
            const SizedBox(width: 8),
            Text(
              'Bus ${bus.name} va aquí ahora',
              style: AppTextStyles.badge.copyWith(color: AppColors.bg),
            ),
          ],
        ),
      ),
    );
  }
}
