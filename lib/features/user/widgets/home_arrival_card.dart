import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/core/utils/date_time_utils.dart';
import 'package:next_bus/core/utils/ordinal_label.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/data/services/arrivals_resolver.dart';
import 'package:next_bus/features/user/viewmodels/home_viewmodel.dart';

/// Tarjeta de una página del carrusel "Mi parada": el bus, su ETA grande y
/// el tramo de paradas que le faltan hasta la parada elegida por el
/// usuario, cada una con su tiempo estimado.
class HomeArrivalCard extends StatelessWidget {
  final StopArrival arrival;
  final int index;
  final List<RemainingStop> remainingStops;

  const HomeArrivalCard({
    super.key,
    required this.arrival,
    required this.index,
    required this.remainingStops,
  });

  @override
  Widget build(BuildContext context) {
    final bus = arrival.bus;
    final eta = arrival.eta;
    final isStale = eta.gpsStatus == GpsStatus.desactualizado;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ordinalBusLabel(index).toUpperCase(),
                    style: AppTextStyles.badge.copyWith(color: Colors.white),
                  ),
                ),
                const Spacer(),
                StatusBadge(
                  label: bus.status.label,
                  color: AppColors.forBusStatus(bus.status),
                  background: AppColors.bgForBusStatus(bus.status),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${eta.etaMinutes}', style: AppTextStyles.etaValue),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 4),
                  child: Text('min', style: AppTextStyles.bodySecondary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${bus.id} · ${arrival.route?.name ?? 'Ruta no asignada'}'
                    '${bus.direction != null ? ' · ${bus.direction!.label}' : ''}',
                    style: AppTextStyles.bodySecondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Text('Paradas que faltan', style: AppTextStyles.caption),
            const SizedBox(height: 6),
            Expanded(
              child: remainingStops.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin información de recorrido para este bus.',
                        style: AppTextStyles.bodySecondary,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: remainingStops.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, i) {
                        final item = remainingStops[i];
                        return _RemainingStopRow(item: item);
                      },
                    ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                StatusBadge(
                  label: eta.confidence.label,
                  color: AppColors.forConfidence(eta.confidence),
                  background: AppColors.greyBg,
                  icon: Icons.verified_rounded,
                ),
                const SizedBox(width: 8),
                StatusBadge(
                  label: eta.gpsStatus.label,
                  color: isStale ? AppColors.orange : AppColors.green,
                  background: isStale ? AppColors.orangeBg : AppColors.greenBg,
                  icon: Icons.satellite_alt_rounded,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Última actualización: ${DateTimeUtils.relativeToNow(eta.lastUpdated)}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _RemainingStopRow extends StatelessWidget {
  final RemainingStop item;

  const _RemainingStopRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.isTarget ? AppColors.navy : AppColors.border,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            item.isTarget ? '${item.stop.name} (tu parada)' : item.stop.name,
            style: item.isTarget
                ? AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)
                : AppTextStyles.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: item.isTarget ? const Color(0xFFE3EAF2) : AppColors.greyBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'en ${item.etaMinutes} min',
            style: AppTextStyles.caption.copyWith(
              color: item.isTarget ? AppColors.navy : AppColors.textSecondary,
              fontWeight: item.isTarget ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
