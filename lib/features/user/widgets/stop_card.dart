import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/models/stop.dart';

class StopCard extends StatelessWidget {
  final Stop stop;
  final VoidCallback onTap;
  final String? trailing;

  const StopCard({
    super.key,
    required this.stop,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300)),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              color: AppColors.accent100,
              alignment: Alignment.center,
              child: const Icon(Icons.pin_drop_rounded, color: AppColors.accent800),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stop.name, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(
                    '${stop.id} · ${stop.description}',
                    style: AppTextStyles.bodySecondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null)
              Text(trailing!, style: AppTextStyles.cardTitle)
            else
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.neutral600),
          ],
        ),
      ),
    );
  }
}
