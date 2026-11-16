import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/core/widgets/big_stat_card.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/core/widgets/usage_bar.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/fuel_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/data/repositories/trip_repository.dart';
import 'package:next_bus/features/driver/viewmodels/driver_home_viewmodel.dart';
import 'package:next_bus/features/driver/views/end_shift_view.dart';
import 'package:next_bus/features/driver/views/fuel_view.dart';
import 'package:next_bus/features/driver/views/incident_history_view.dart';
import 'package:next_bus/features/driver/views/my_trip_view.dart';
import 'package:next_bus/features/driver/views/report_incident_view.dart';
import 'package:next_bus/models/bus.dart';

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
        fuelRepository: ctx.read<FuelRepository>(),
        shiftRepository: ctx.read<ShiftRepository>(),
        incidentRepository: ctx.read<IncidentRepository>(),
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

    return Scaffold(
      appBar: AppBar(title: Text(vm.shiftOpen ? 'En ruta' : 'Inicio de turno')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
              ? EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Ocurrió un problema',
                  message: vm.errorMessage!,
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: vm.shiftOpen ? _onRoute(context, vm) : _start(context, vm),
                ),
    );
  }

  List<Widget> _start(BuildContext context, DriverHomeViewModel vm) {
    final bus = vm.assignedBus;
    return [
      Text('Buen día, ${vm.driver?.name ?? ''}', style: AppTextStyles.bodySecondary),
      Text('Tu unidad de hoy', style: AppTextStyles.title),
      const SizedBox(height: 16),
      if (vm.wasReassigned && bus != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent100,
              border: Border.all(color: AppColors.accent),
            ),
            child: Row(
              children: [
                const Icon(Icons.swap_horiz_rounded, color: AppColors.accent800),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tu unidad habitual se quedó sin presupuesto de combustible. '
                    'Hoy conduces el Bus ${bus.name}.',
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      if (bus != null)
        BigStatCard(
          kicker: bus.plate,
          title: 'Bus ${bus.name}',
          big: '\$${(vm.fuelBudget - bus.fuelUsed).clamp(0, vm.fuelBudget).round()}',
          bigSub: 'saldo disponible de \$${vm.fuelBudget.round()} · '
              'capacidad ${bus.capacity}',
          bottom: UsageBar(
            pct: bus.fuelUsed / vm.fuelBudget,
            color: Colors.white,
            trackColor: AppColors.accent700,
          ),
        )
      else
        const EmptyState(
          icon: Icons.block_rounded,
          title: 'Sin unidad disponible',
          message: 'Ninguna unidad tiene presupuesto de combustible hoy.',
        ),
      const SizedBox(height: 22),
      Text('Flota', style: AppTextStyles.sectionTitle),
      const SizedBox(height: 4),
      ...vm.fleet.map((f) => _FleetRow(bus: f, vm: vm)),
      const SizedBox(height: 22),
      ElevatedButton(
        onPressed: vm.hasAssignableUnit && !vm.isUpdating
            ? () => context.read<DriverHomeViewModel>().startShift()
            : null,
        child: Text(vm.hasAssignableUnit ? 'Iniciar turno' : 'Sin unidad disponible'),
      ),
      const SizedBox(height: 8),
      Text(
        'Cada vuelta se inicia por separado desde "En ruta".',
        style: AppTextStyles.caption,
      ),
    ];
  }

  List<Widget> _onRoute(BuildContext context, DriverHomeViewModel vm) {
    final bus = vm.assignedBus;
    final trip = vm.trip;
    final enCurso = trip?.status == TripStatus.enCurso;
    final canEnd = trip != null && trip.status != TripStatus.enCurso;

    return [
      if (bus != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bus.plate, style: AppTextStyles.bodySecondary),
                Text('Bus ${bus.name}', style: AppTextStyles.title),
              ],
            ),
            StatusBadge(
              label: trip?.status.label ?? '—',
              color: AppColors.forBusStatus(bus.status),
              background: AppColors.bgForBusStatus(bus.status),
            ),
          ],
        ),
      const SizedBox(height: 16),
      InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MyTripView()),
        ),
        child: BigStatCard(
          kicker: enCurso ? 'PRÓXIMA PARADA · VER SECUENCIA' : 'VUELTAS COMPLETADAS',
          title: enCurso ? (trip?.nextStopId ?? '—') : null,
          big: enCurso ? '—' : '${vm.shift?.lapsCompleted ?? 0}',
          bigSub: enCurso ? null : 'Vuelta ${(vm.shift?.lapsCompleted ?? 0) + 1} lista para iniciar',
        ),
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: vm.isUpdating
                  ? null
                  : () => context.read<DriverHomeViewModel>().toggleLap(),
              child: Text(enCurso ? 'Finalizar vuelta' : 'Iniciar vuelta'),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ReportIncidentView()),
            ),
            child: const Text('+ Eventualidad'),
          ),
        ],
      ),
      if (canEnd)
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EndShiftView()),
              ),
              child: const Text('Terminar turno'),
            ),
          ),
        ),
      const SizedBox(height: 22),
      Text('Pasajeros a bordo', style: AppTextStyles.sectionTitle),
      const SizedBox(height: 8),
      if (bus != null) _PassengersCard(bus: bus),
      const SizedBox(height: 18),
      InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FuelView()),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300)),
          child: Row(
            children: [
              const Icon(Icons.local_gas_station_outlined, color: AppColors.accent800),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  bus == null
                      ? 'Combustible'
                      : 'Combustible · \$${bus.fuelUsed.round()} usados de '
                          '\$${vm.fuelBudget.round()}',
                  style: AppTextStyles.body,
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.neutral600),
            ],
          ),
        ),
      ),
      if (vm.openDelayMinutes > 0)
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.orangeBg,
              border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Retraso acumulado de ${vm.openDelayMinutes} min por eventualidades abiertas.',
                    style: AppTextStyles.bodySecondary.copyWith(color: AppColors.orange),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const IncidentHistoryView()),
                  ),
                  child: const Text('Ver bitácora'),
                ),
              ],
            ),
          ),
        ),
    ];
  }
}

class _FleetRow extends StatelessWidget {
  final Bus bus;
  final DriverHomeViewModel vm;
  const _FleetRow({required this.bus, required this.vm});

  @override
  Widget build(BuildContext context) {
    final isMine = bus.id == vm.assignedBus?.id;
    final assignable = vm.isAssignable(bus);
    final chip = isMine
        ? ('Tu unidad', AppColors.accent900, AppColors.bg)
        : !assignable
            ? ('Sin combustible', AppColors.redBg, AppColors.red)
            : ('Disponible', AppColors.greenBg, AppColors.green);

    return Opacity(
      opacity: assignable ? 1 : 0.55,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.neutral300)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              color: isMine ? AppColors.accent900 : AppColors.neutral400,
              alignment: Alignment.center,
              child: Text(bus.name, style: AppTextStyles.cardTitle.copyWith(
                  color: AppColors.bg, fontSize: 13)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bus.plate, style: AppTextStyles.cardTitle),
                  SizedBox(
                    width: 120,
                    child: UsageBar(
                      pct: bus.fuelUsed / vm.fuelBudget,
                      label: '\$${bus.fuelUsed.round()}/\$${vm.fuelBudget.round()}',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              color: chip.$2,
              child: Text(chip.$1,
                  style: AppTextStyles.badge.copyWith(color: chip.$3)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassengersCard extends StatelessWidget {
  final Bus bus;
  const _PassengersCard({required this.bus});

  @override
  Widget build(BuildContext context) {
    final pct = bus.passengerCount / bus.capacity;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${bus.passengerCount} / ${bus.capacity}',
                  style: AppTextStyles.etaValue.copyWith(fontSize: 32)),
              Text(
                pct >= 0.85 ? 'Lleno' : pct >= 0.5 ? 'Moderado' : 'Libre',
                style: AppTextStyles.cardTitle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          UsageBar(pct: pct),
          const SizedBox(height: 4),
          Text('Todos bajan en Garita Salida.', style: AppTextStyles.caption),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final delta in [-5, -1, 1, 5])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: OutlinedButton(
                      onPressed: () =>
                          context.read<DriverHomeViewModel>().adjustPassengers(delta),
                      child: Text(delta > 0 ? '+$delta' : '$delta'),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
