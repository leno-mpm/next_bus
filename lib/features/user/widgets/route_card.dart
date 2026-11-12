import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/models/transit_route.dart';

class RouteCard extends StatelessWidget {
  final TransitRoute route;
  final VoidCallback onTap;

  const RouteCard({super.key, required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = route.status.label == 'Activa';
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(route.name, style: AppTextStyles.cardTitle),
                  ),
                  StatusBadge(
                    label: route.status.label,
                    color: isActive ? AppColors.green : AppColors.grey,
                    background: isActive ? AppColors.greenBg : AppColors.greyBg,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(route.description, style: AppTextStyles.bodySecondary),
              const SizedBox(height: 10),
              Row(
                children: [
                  StatusBadge(
                    label: route.direction.label,
                    color: AppColors.navy,
                    background: const Color(0xFFE3EAF2),
                    icon: Icons.swap_vert_rounded,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.pin_drop_rounded,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${route.stopCount} paradas',
                      style: AppTextStyles.bodySecondary),
                  const Spacer(),
                  Text(route.id, style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
