import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';

/// Aviso visual obligatorio de que la información mostrada es simulada
/// (horarios de demostración, ETA simulado, etc.), para no presentarla como
/// si fuera oficial o en tiempo real.
class DemoBanner extends StatelessWidget {
  final String text;

  const DemoBanner({
    super.key,
    this.text = 'Información de demostración — no oficial, no en tiempo real.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.orangeBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
