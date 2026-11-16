import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/utils/date_time_utils.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/models/incident.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback? onResolve;

  const IncidentCard({super.key, required this.incident, this.onResolve});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(incident.type.label,
                      style: AppTextStyles.cardTitle),
                ),
                StatusBadge(
                  label: incident.severity.label,
                  color: AppColors.forSeverity(incident.severity),
                  background: AppColors.bgForSeverity(incident.severity),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(incident.description, style: AppTextStyles.body),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                _Tag(icon: Icons.directions_bus_rounded, text: incident.busId),
                _Tag(icon: Icons.alt_route_rounded, text: incident.routeId),
                if (incident.stopId != null)
                  _Tag(icon: Icons.pin_drop_rounded, text: incident.stopId!),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  DateTimeUtils.dateTime(incident.reportedAt),
                  style: AppTextStyles.caption,
                ),
                const Spacer(),
                StatusBadge(
                  label: incident.status.label,
                  color: AppColors.forIncidentStatus(incident.status),
                  background: AppColors.bgForIncidentStatus(incident.status),
                ),
              ],
            ),
            if (incident.isOpen && onResolve != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onResolve,
                  child: const Text('Marcar resuelta'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Tag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }
}
