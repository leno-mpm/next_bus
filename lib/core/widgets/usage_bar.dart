import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';

/// Barra de progreso coloreada por nivel de uso (verde→ámbar→rojo), usada
/// para combustible (C1/C2/C7) y ocupación de pasajeros (S2/S5/C2).
class UsageBar extends StatelessWidget {
  final double pct;
  final String? label;
  final Color? trackColor;
  final Color? color;

  const UsageBar({
    super.key,
    required this.pct,
    this.label,
    this.trackColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = pct.clamp(0.0, 1.0);
    final barColor = color ?? AppColors.forUsageLevel(pct);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: 6,
            backgroundColor: trackColor ?? AppColors.neutral300,
            color: barColor,
          ),
        ),
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(label!, style: AppTextStyles.caption),
          ),
      ],
    );
  }
}
