import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/core/widgets/segmented_control.dart';
import 'package:next_bus/features/driver/viewmodels/report_incident_viewmodel.dart';

class ReportIncidentView extends StatelessWidget {
  const ReportIncidentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportIncidentViewModel>(
      create: (ctx) => ReportIncidentViewModel(
        driverRepository: ctx.read<DriverRepository>(),
        incidentRepository: ctx.read<IncidentRepository>(),
        stopRepository: ctx.read<StopRepository>(),
        shiftRepository: ctx.read<ShiftRepository>(),
      )..load(),
      child: const _ReportIncidentBody(),
    );
  }
}

class _ReportIncidentBody extends StatefulWidget {
  const _ReportIncidentBody();

  @override
  State<_ReportIncidentBody> createState() => _ReportIncidentBodyState();
}

class _ReportIncidentBodyState extends State<_ReportIncidentBody> {
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportIncidentViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.submitted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registrar incidencia')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.green, size: 56),
                const SizedBox(height: 16),
                Text('Incidencia registrada', style: AppTextStyles.title),
                const SizedBox(height: 8),
                Text(
                  'Tu reporte fue guardado y ya aparece en el historial.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySecondary,
                ),
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

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar incidencia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Tipo de incidencia', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: IncidentType.values
                .map((type) => ChoiceChip(
                      label: Text(type.label),
                      selected: vm.type == type,
                      onSelected: (_) => vm.setType(type),
                      selectedColor: AppColors.navy,
                      labelStyle: TextStyle(
                        color: vm.type == type ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: vm.type == type ? AppColors.navy : AppColors.border,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Text('Gravedad', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: IncidentSeverity.values
                .map((severity) => ChoiceChip(
                      label: Text(severity.label),
                      selected: vm.severity == severity,
                      onSelected: (_) => vm.setSeverity(severity),
                      selectedColor: AppColors.forSeverity(severity),
                      labelStyle: TextStyle(
                        color: vm.severity == severity
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: vm.severity == severity
                            ? AppColors.forSeverity(severity)
                            : AppColors.border,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Text('Retraso estimado', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          SegmentedControl<int>(
            options: const [
              SegmentOption(value: 0, label: 'No'),
              SegmentOption(value: 3, label: '+3'),
              SegmentOption(value: 5, label: '+5'),
              SegmentOption(value: 10, label: '+10'),
              SegmentOption(value: 15, label: '+15'),
            ],
            value: vm.delayMinutes,
            onChanged: vm.setDelayMinutes,
          ),
          const SizedBox(height: 20),
          Text('Descripción', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            onChanged: vm.setDescription,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe qué ocurrió...',
              errorText: vm.descriptionError,
            ),
          ),
          const SizedBox(height: 20),
          Text('Parada relacionada (opcional)',
              style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          DropdownButtonFormField<String?>(
            initialValue: vm.stopId,
            isExpanded: true,
            decoration: const InputDecoration(hintText: 'Selecciona una parada'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Ninguna'),
              ),
              ...vm.stops.map((stop) => DropdownMenuItem<String?>(
                    value: stop.id,
                    child: Text(
                      '${stop.id} · ${stop.name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
            onChanged: vm.setStopId,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Datos asociados', style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  Text('Bus: ${vm.busId}', style: AppTextStyles.body),
                  Text('Ruta: ${vm.routeId}', style: AppTextStyles.body),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: vm.isSubmitting
                ? null
                : () => context.read<ReportIncidentViewModel>().submit(),
            icon: const Icon(Icons.send_rounded),
            label: Text(vm.isSubmitting ? 'Guardando...' : 'Registrar incidencia'),
          ),
        ],
      ),
    );
  }
}
