import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/segmented_control.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/features/driver/viewmodels/end_shift_viewmodel.dart';

class EndShiftView extends StatelessWidget {
  const EndShiftView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EndShiftViewModel>(
      create: (ctx) => EndShiftViewModel(
        driverRepository: ctx.read<DriverRepository>(),
        shiftRepository: ctx.read<ShiftRepository>(),
        incidentRepository: ctx.read<IncidentRepository>(),
      )..load(),
      child: const _EndShiftBody(),
    );
  }
}

class _EndShiftBody extends StatelessWidget {
  const _EndShiftBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EndShiftViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vm.closed) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fin de turno')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.task_alt_rounded, color: AppColors.green, size: 56),
                const SizedBox(height: 16),
                Text('Turno cerrado', style: AppTextStyles.title),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final shift = vm.shift;
    final elapsed = vm.elapsed;
    final elapsedLabel = '${elapsed.inHours}h ${elapsed.inMinutes % 60}min';

    return Scaffold(
      appBar: AppBar(title: const Text('Fin de turno')),
      body: shift == null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No hay un turno abierto para cerrar.',
                style: AppTextStyles.body,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Bus ${shift.busId} · ${vm.driver?.name ?? ''}',
                    style: AppTextStyles.bodySecondary),
                Text('Fin de turno', style: AppTextStyles.title),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                        child: _SummaryTile(
                            label: 'Vueltas completas',
                            value: '${shift.lapsCompleted}')),
                    const SizedBox(width: 1),
                    Expanded(
                        child:
                            _SummaryTile(label: 'Tiempo de turno', value: elapsedLabel)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: _SummaryTile(
                            label: 'Eventualidades',
                            value: '${vm.myIncidents.length}')),
                    const SizedBox(width: 1),
                    Expanded(
                        child: _SummaryTile(
                            label: 'Retraso acumulado',
                            value: '${vm.totalDelayMinutes} min')),
                  ],
                ),
                const SizedBox(height: 22),
                Text('Estado de la unidad al cerrar',
                    style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                SegmentedControl<String>(
                  options: const [
                    SegmentOption(value: 'Sin novedad', label: 'Sin novedad'),
                    SegmentOption(value: 'Con observación', label: 'Con observ.'),
                    SegmentOption(value: 'Requiere taller', label: 'Requiere taller'),
                  ],
                  value: vm.unitCondition,
                  onChanged: (v) => context.read<EndShiftViewModel>().setUnitCondition(v),
                ),
                if (vm.openCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.orangeBg,
                        border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '${vm.openCount} eventualidad(es) abiertas se pasarán al '
                        'siguiente turno.',
                        style: AppTextStyles.bodySecondary.copyWith(color: AppColors.orange),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: vm.isClosing
                      ? null
                      : () => context.read<EndShiftViewModel>().closeShift(),
                  child: const Text('Cerrar turno'),
                ),
              ],
            ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.etaValue.copyWith(fontSize: 24)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
