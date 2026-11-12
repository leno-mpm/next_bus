import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/core/utils/date_time_utils.dart';
import 'package:next_bus/core/utils/ordinal_label.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/features/user/viewmodels/stop_detail_viewmodel.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/stop.dart';

class BusEtaCard extends StatelessWidget {
  final StopArrival arrival;
  final int index;
  final Stop? nextStopInfo;

  const BusEtaCard({
    super.key,
    required this.arrival,
    required this.index,
    this.nextStopInfo,
  });

  @override
  Widget build(BuildContext context) {
    final bus = arrival.bus;
    final eta = arrival.eta;
    final ordinal = ordinalBusLabel(index);
    final isStale = eta.gpsStatus == GpsStatus.desactualizado;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                    ordinal.toUpperCase(),
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
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${eta.etaMinutes}', style: AppTextStyles.etaValue),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 4),
                  child: Text('min', style: AppTextStyles.bodySecondary),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Rango: ${eta.etaLowerMinutes}–${eta.etaUpperMinutes} min',
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.directions_bus_rounded,
              text:
                  '${bus.id} · ${arrival.route?.name ?? 'Ruta no asignada'}',
            ),
            if (bus.direction != null)
              _InfoRow(
                icon: Icons.swap_vert_rounded,
                text: 'Sentido ${bus.direction!.label}',
              ),
            _InfoRow(
              icon: Icons.my_location_rounded,
              text: _locationText(bus),
            ),
            if (bus.nextStopId != null)
              _InfoRow(
                icon: Icons.arrow_forward_rounded,
                text:
                    'Próxima parada: ${nextStopInfo?.name ?? bus.nextStopId}',
              ),
            const SizedBox(height: 8),
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

  String _locationText(Bus bus) {
    if (bus.status == BusStatus.enParada && bus.currentStopId != null) {
      return 'Detenido en ${bus.currentStopId}';
    }
    if (bus.currentSegmentFromStopId != null &&
        bus.currentSegmentToStopId != null) {
      return 'Entre ${bus.currentSegmentFromStopId} y ${bus.currentSegmentToStopId}';
    }
    if (bus.currentStopId != null) return 'En ${bus.currentStopId}';
    return 'Ubicación no disponible';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: AppTextStyles.bodySecondary)),
        ],
      ),
    );
  }
}
