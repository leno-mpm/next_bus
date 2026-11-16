import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/core/utils/date_time_utils.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/features/user/viewmodels/notices_viewmodel.dart';
import 'package:next_bus/models/incident.dart';

class NoticesView extends StatelessWidget {
  const NoticesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoticesViewModel>(
      create: (ctx) => NoticesViewModel(
        incidentRepository: ctx.read<IncidentRepository>(),
      )..load(),
      child: const _NoticesBody(),
    );
  }
}

class _NoticesBody extends StatelessWidget {
  const _NoticesBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoticesViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Avisos')),
      body: RefreshIndicator(
        onRefresh: () => context.read<NoticesViewModel>().load(),
        child: vm.isLoading && vm.feed.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null
                ? EmptyState(
                    icon: Icons.error_outline_rounded,
                    title: 'Ocurrió un problema',
                    message: vm.errorMessage!,
                  )
                : vm.feed.isEmpty
                    ? const EmptyState(
                        icon: Icons.notifications_off_outlined,
                        title: 'Sin avisos',
                        message:
                            'No hay retrasos, desvíos ni cambios reportados.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: vm.feed.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) =>
                            _NoticeRow(incident: vm.feed[index]),
                      ),
      ),
    );
  }
}

class _NoticeRow extends StatelessWidget {
  final Incident incident;
  const _NoticeRow({required this.incident});

  @override
  Widget build(BuildContext context) {
    final body = incident.stopId != null
        ? 'Cerca de ${incident.stopId}'
            '${incident.delayMinutes > 0 ? ' · +${incident.delayMinutes} min' : ''}.'
            ' ${incident.description}'
        : incident.description;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgForIncidentStatus(incident.status),
            ),
            alignment: Alignment.center,
            child: Icon(_iconFor(incident.type),
                size: 16, color: AppColors.forIncidentStatus(incident.status)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(incident.type.label,
                          style: AppTextStyles.cardTitle),
                    ),
                    Text(DateTimeUtils.relativeToNow(incident.reportedAt),
                        style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 3),
                Text(body, style: AppTextStyles.bodySecondary),
                const SizedBox(height: 6),
                StatusBadge(
                  label: incident.isOpen ? 'Abierta' : 'Resuelta',
                  color: AppColors.forIncidentStatus(incident.status),
                  background: AppColors.bgForIncidentStatus(incident.status),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(IncidentType type) => switch (type) {
        IncidentType.fallaMecanica => Icons.build_circle_outlined,
        IncidentType.accidente => Icons.warning_amber_rounded,
        IncidentType.retraso => Icons.schedule_rounded,
        IncidentType.congestionVehicular => Icons.traffic_rounded,
        IncidentType.problemasParada => Icons.pin_drop_outlined,
        IncidentType.problemasPasajeros => Icons.groups_outlined,
        IncidentType.desvioRuta => Icons.alt_route_rounded,
        IncidentType.clima => Icons.cloud_outlined,
        IncidentType.otro => Icons.info_outline_rounded,
      };
}
