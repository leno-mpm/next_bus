import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';

/// Tarjeta de "número grande" sobre fondo de acento oscuro: usada por S2/S4
/// (próxima llegada), C1/C7 (saldo de combustible) y C2 (próxima parada /
/// vuelta). Centraliza el patrón kicker + chip + número grande + sub-label.
class BigStatCard extends StatelessWidget {
  final String kicker;
  final String? tagText;
  final Color? tagBg;
  final Color? tagFg;
  final String? title;
  final String big;
  final String? bigSub;
  final Widget? bottom;

  const BigStatCard({
    super.key,
    required this.kicker,
    required this.big,
    this.tagText,
    this.tagBg,
    this.tagFg,
    this.title,
    this.bigSub,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(color: AppColors.accent900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kicker,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent300,
                  letterSpacing: 1.2,
                ),
              ),
              if (tagText != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagBg ?? AppColors.accent700,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tagText!,
                    style: AppTextStyles.badge
                        .copyWith(color: tagFg ?? AppColors.bg),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (title != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: AppTextStyles.cardTitle
                            .copyWith(color: AppColors.bg, fontSize: 16),
                      ),
                      if (bigSub != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            bigSub!,
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.accent200),
                          ),
                        ),
                    ],
                  ),
                ),
              Text(
                big,
                style: AppTextStyles.etaValue.copyWith(
                  color: AppColors.bg,
                  fontSize: title != null ? 44 : 56,
                  height: 0.85,
                ),
              ),
            ],
          ),
          if (title == null && bigSub != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                bigSub!,
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.accent200),
              ),
            ),
          if (bottom != null) ...[
            const SizedBox(height: 12),
            bottom!,
          ],
        ],
      ),
    );
  }
}
