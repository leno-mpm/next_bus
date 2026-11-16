import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/big_stat_card.dart';
import 'package:next_bus/core/widgets/bus_row.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/eta_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/data/services/arrivals_resolver.dart';
import 'package:next_bus/features/user/viewmodels/home_viewmodel.dart';
import 'package:next_bus/features/user/views/bus_detail_view.dart';
import 'package:next_bus/features/user/widgets/route_map_view.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/transit_route.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (ctx) => HomeViewModel(
        busRepository: ctx.read<BusRepository>(),
        stopRepository: ctx.read<StopRepository>(),
        routeRepository: ctx.read<RouteRepository>(),
        etaRepository: ctx.read<EtaRepository>(),
      )..load(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      body: SafeArea(
        child: vm.isLoading && vm.allStops.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null
                ? EmptyState(
                    icon: Icons.error_outline_rounded,
                    title: 'Ocurrió un problema',
                    message: vm.errorMessage!,
                  )
                : RefreshIndicator(
                    onRefresh: () => context.read<HomeViewModel>().load(),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _Header(vm: vm),
                        const SizedBox(height: 16),
                        RouteMapView(
                          orderedStops: vm.orderedStopsForMap,
                          highlightStopId: vm.selectedStopId,
                          buses: _mapBuses(vm.buses),
                          onStopTap: (id) =>
                              context.read<HomeViewModel>().selectStop(id),
                          onBusTap: (busId) => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BusDetailView(busId: busId),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const _Legend(),
                        const SizedBox(height: 18),
                        _SelectedStopCard(vm: vm),
                        const SizedBox(height: 22),
                        Text('Buses en servicio',
                            style: AppTextStyles.sectionTitle),
                        const SizedBox(height: 4),
                        ...vm.buses.map(
                          (bus) => _BusServiceRow(bus: bus, vm: vm),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  List<MapBusPosition> _mapBuses(List<Bus> buses) {
    return buses
        .where((b) =>
            b.currentSegmentFromStopId != null &&
            b.currentSegmentToStopId != null)
        .map((b) => MapBusPosition(
              bus: b,
              fromStopId: b.currentSegmentFromStopId!,
              toStopId: b.currentSegmentToStopId!,
            ))
        .toList();
  }
}

class _Header extends StatelessWidget {
  final HomeViewModel vm;
  const _Header({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola', style: AppTextStyles.bodySecondary),
            Text('Tu bus, en vivo', style: AppTextStyles.title),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accent100,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 6),
              Text('${vm.busesEnMarchaCount} activos',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.accent800)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    Widget dot(Color c, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: c),
            ),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.caption),
          ],
        );
    return Wrap(
      spacing: 14,
      runSpacing: 4,
      children: [
        dot(AppColors.green, 'A tiempo'),
        dot(AppColors.orange, 'Con retraso'),
        dot(AppColors.neutral500, 'Detenido'),
      ],
    );
  }
}

class _SelectedStopCard extends StatelessWidget {
  final HomeViewModel vm;
  const _SelectedStopCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final best = vm.arrivals.isEmpty ? null : vm.arrivals.first;
    final TransitRoute? route = best?.route;
    return BigStatCard(
      kicker: 'TU PARADA · ${vm.selectedStop?.id ?? '—'}',
      title: vm.selectedStop?.name ?? 'Selecciona una parada',
      bigSub: best == null
          ? 'Sin buses en camino'
          : '${best.bus.name} · ${route?.name ?? 'Ruta'}',
      big: best == null ? '—' : '${best.eta.etaMinutes}',
      tagText: best == null ? null : 'min',
    );
  }
}

class _BusServiceRow extends StatelessWidget {
  final Bus bus;
  final HomeViewModel vm;
  const _BusServiceRow({required this.bus, required this.vm});

  @override
  Widget build(BuildContext context) {
    final arrival = vm.arrivals.where((a) => a.bus.id == bus.id).firstOrNull;
    return BusRow(
      busId: bus.name.replaceAll(RegExp(r'[^0-9]'), ''),
      tileColor: AppColors.forBusStatus(bus.status),
      statusText: bus.status.label,
      occupancyPct: bus.passengerCount / bus.capacity,
      trailingBig: arrival == null ? '—' : '${arrival.eta.etaMinutes}',
      trailingSmall: arrival == null ? null : 'a ${vm.selectedStop?.id ?? ''}',
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BusDetailView(busId: bus.id)),
      ),
    );
  }
}
