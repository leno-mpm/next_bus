import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/features/user/viewmodels/schedules_viewmodel.dart';

class ScheduleCard extends StatelessWidget {
  final RouteSchedule item;

  const ScheduleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final schedule = item.schedule;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.routeName, style: AppTextStyles.cardTitle),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule_rounded,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Servicio: ${schedule.serviceStartTime} – ${schedule.serviceEndTime}',
                  style: AppTextStyles.body,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.repeat_rounded,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Frecuencia aprox.: cada ${schedule.frequencyMinutes} min',
                    style: AppTextStyles.body),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(schedule.operatingDays.join(', '),
                      style: AppTextStyles.body),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Salidas de referencia:', style: AppTextStyles.caption),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: schedule.departureTimes
                  .map((time) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.greyBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(time, style: AppTextStyles.caption),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
