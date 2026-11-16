import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/usage_bar.dart';

/// Fila de bus reutilizable: tile con id, estado/ocupación y un valor a la
/// derecha (ETA u otro dato). Usada por S2 (buses en servicio), S4
/// (llegadas por bus) y S5 (próximas paradas de otros buses).
class BusRow extends StatelessWidget {
  final String busId;
  final Color tileColor;
  final String statusText;
  final double? occupancyPct;
  final String trailingBig;
  final String? trailingSmall;
  final VoidCallback? onTap;

  const BusRow({
    super.key,
    required this.busId,
    required this.tileColor,
    required this.statusText,
    required this.trailingBig,
    this.occupancyPct,
    this.trailingSmall,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.neutral300)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              color: tileColor,
              child: Text(
                busId,
                style: AppTextStyles.cardTitle
                    .copyWith(color: AppColors.bg, fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(statusText, style: AppTextStyles.cardTitle),
                  if (occupancyPct != null) ...[
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 96,
                      child: UsageBar(pct: occupancyPct!),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(trailingBig, style: AppTextStyles.etaValue.copyWith(fontSize: 20)),
                if (trailingSmall != null)
                  Text(trailingSmall!, style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
