import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/utils/date_time_utils.dart';
import 'package:next_bus/core/widgets/big_stat_card.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/segmented_control.dart';
import 'package:next_bus/core/widgets/usage_bar.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/fuel_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/features/driver/viewmodels/fuel_viewmodel.dart';

class FuelView extends StatelessWidget {
  const FuelView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FuelViewModel>(
      create: (ctx) => FuelViewModel(
        busRepository: ctx.read<BusRepository>(),
        driverRepository: ctx.read<DriverRepository>(),
        fuelRepository: ctx.read<FuelRepository>(),
        shiftRepository: ctx.read<ShiftRepository>(),
      )..load(),
      child: const _FuelBody(),
    );
  }
}

class _FuelBody extends StatelessWidget {
  const _FuelBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuelViewModel>();
    final bus = vm.bus;

    return Scaffold(
      appBar: AppBar(title: const Text('Combustible')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bus == null
              ? const EmptyState(
                  icon: Icons.local_gas_station_outlined,
                  title: 'Sin unidad asignada',
                  message: 'No hay una unidad asignada para registrar cargas.',
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text('Bus ${bus.name} · ${bus.plate}',
                        style: AppTextStyles.bodySecondary),
                    const SizedBox(height: 16),
                    BigStatCard(
                      kicker: 'PRESUPUESTO MENSUAL ESPOL',
                      big: '\$${vm.left.round()}',
                      bigSub: 'disponibles de \$${vm.budget.round()}',
                      bottom: UsageBar(
                        pct: bus.fuelUsed / vm.budget,
                        color: Colors.white,
                        trackColor: AppColors.accent700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'La unidad queda bloqueada para asignación hasta el próximo '
                      'mes cuando el presupuesto se agota.',
                      style: AppTextStyles.caption,
                    ),
                    if (vm.blocked)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.redBg,
                            border: Border.all(color: AppColors.red.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.block_rounded,
                                  size: 18, color: AppColors.red),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Presupuesto agotado este mes. La unidad no se '
                                  'asignará hasta recargar o renovar el mes.',
                                  style: AppTextStyles.bodySecondary
                                      .copyWith(color: AppColors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),
                    Text('Registrar carga', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 8),
                    SegmentedControl<double>(
                      options: const [
                        SegmentOption(value: 10, label: '\$10'),
                        SegmentOption(value: 20, label: '\$20'),
                        SegmentOption(value: 30, label: '\$30'),
                        SegmentOption(value: 40, label: '\$40'),
                      ],
                      value: vm.selectedAmount,
                      onChanged: (v) => context.read<FuelViewModel>().setAmount(v),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: vm.isSubmitting || vm.blocked || vm.exceedsBalance
                          ? null
                          : () => context.read<FuelViewModel>().registerLoad(),
                      child: Text(
                        vm.blocked
                            ? 'Sin saldo este mes'
                            : vm.exceedsBalance
                                ? 'Excede el saldo (\$${vm.left.round()})'
                                : 'Registrar carga de \$${vm.selectedAmount.round()}',
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text('Cargas de este mes', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 6),
                    if (vm.loads.isEmpty)
                      const EmptyState(
                        icon: Icons.history_rounded,
                        title: 'Sin cargas',
                        message: 'Todavía no se han registrado cargas este mes.',
                      )
                    else
                      ...vm.loads.map((l) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: AppColors.neutral300)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(DateTimeUtils.dateTime(l.registeredAt),
                                          style: AppTextStyles.body),
                                      Text(l.registeredBy,
                                          style: AppTextStyles.caption),
                                    ],
                                  ),
                                ),
                                Text('\$${l.amount.round()}',
                                    style: AppTextStyles.cardTitle),
                              ],
                            ),
                          )),
                  ],
                ),
    );
  }
}
