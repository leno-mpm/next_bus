import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/enums/enums.dart';

/// Selector visible de escenarios de demostración de ETA (sección 9.1).
/// Cambiar de escenario llama al ViewModel; este widget no contiene lógica.
class ScenarioSelector extends StatelessWidget {
  final List<EtaDemoScenario> scenarios;
  final EtaDemoScenario selected;
  final ValueChanged<EtaDemoScenario> onChanged;

  const ScenarioSelector({
    super.key,
    required this.scenarios,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EtaDemoScenario>(
          value: selected,
          isExpanded: true,
          icon: const Icon(Icons.expand_more_rounded,
              color: AppColors.textSecondary),
          style: AppTextStyles.body,
          items: scenarios
              .map((scenario) => DropdownMenuItem(
                    value: scenario,
                    child: Text(
                      scenario.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
