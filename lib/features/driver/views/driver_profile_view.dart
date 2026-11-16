import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/routes/app_routes.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/utils/date_time_utils.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/preferences_repository.dart';
import 'package:next_bus/features/driver/viewmodels/driver_profile_viewmodel.dart';

class DriverProfileView extends StatelessWidget {
  const DriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverProfileViewModel>(
      create: (ctx) => DriverProfileViewModel(
        driverRepository: ctx.read<DriverRepository>(),
        preferencesRepository: ctx.read<PreferencesRepository>(),
      )..load(),
      child: const _DriverProfileBody(),
    );
  }
}

class _DriverProfileBody extends StatelessWidget {
  const _DriverProfileBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverProfileViewModel>();
    final driver = vm.driver;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del conductor')),
      body: vm.isLoading || driver == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(color: AppColors.accent900),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        color: AppColors.accent700,
                        alignment: Alignment.center,
                        child: Text(
                          _initials(driver.name),
                          style: AppTextStyles.cardTitle
                              .copyWith(color: AppColors.bg, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(driver.name,
                                style: AppTextStyles.sectionTitle
                                    .copyWith(color: AppColors.bg)),
                            Text('Conductor · ID ${driver.employeeCode}',
                                style: AppTextStyles.bodySecondary
                                    .copyWith(color: AppColors.accent200)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _InfoTile(
                            label: 'Unidad',
                            value:
                                '${driver.assignedBusId} · ${driver.assignedRouteId}')),
                    const SizedBox(width: 1),
                    Expanded(
                        child: _InfoTile(
                            label: 'Turno', value: driver.shiftHoursLabel)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: _InfoTile(
                            label: 'Licencia', value: driver.licenseType)),
                    const SizedBox(width: 1),
                    Expanded(
                      child: _InfoTile(
                        label: 'Vence',
                        value: DateTimeUtils.dateShort(driver.licenseExpiry),
                        valueColor: AppColors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration:
                      BoxDecoration(border: Border.all(color: AppColors.neutral300)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Licencia de conducir ${driver.licenseId}',
                            style: AppTextStyles.body),
                      ),
                      const StatusBadge(
                        label: 'Renovar pronto',
                        color: AppColors.orange,
                        background: AppColors.orangeBg,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text('Preferencias', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 4),
                _PreferenceRow(
                  title: 'Sonido de alertas',
                  subtitle: 'Al llegar a cada parada',
                  value: vm.soundEnabled,
                  onChanged: (v) =>
                      context.read<DriverProfileViewModel>().setSoundEnabled(v),
                ),
                _PreferenceRow(
                  title: 'Texto grande en ruta',
                  subtitle: 'Más legible mientras conduces',
                  value: vm.bigTextEnabled,
                  onChanged: (v) => context
                      .read<DriverProfileViewModel>()
                      .setBigTextEnabled(v),
                ),
                const SizedBox(height: 22),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.profileSelection,
                    (route) => false,
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Cerrar sesión'),
                ),
              ],
            ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoTile({required this.label, required this.value, this.valueColor});

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
          Text(value,
              style: AppTextStyles.cardTitle.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
