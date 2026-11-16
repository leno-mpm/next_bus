import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';

class SegmentOption<T> {
  final T value;
  final String label;
  const SegmentOption({required this.value, required this.label});
}

/// Control segmentado genérico (`.seg`/`.seg-opt` del design system):
/// reemplaza el patrón repetido de "fila de botones donde uno está
/// seleccionado" usado por S1 (rol), S3 (filtro de bus), C3 (retraso), C5
/// (estado de la unidad) y C7 (monto de carga).
class SegmentedControl<T> extends StatelessWidget {
  final List<SegmentOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  const SegmentedControl({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral300),
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: _Segment(
                option: options[i],
                selected: options[i].value == value,
                showLeftBorder: i > 0,
                onTap: () => onChanged(options[i].value),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  final SegmentOption<T> option;
  final bool selected;
  final bool showLeftBorder;
  final VoidCallback onTap;

  const _Segment({
    required this.option,
    required this.selected,
    required this.showLeftBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : null,
          border: showLeftBorder
              ? Border(left: BorderSide(color: AppColors.neutral300))
              : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
        alignment: Alignment.center,
        child: Text(
          option.label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 13,
            color: selected ? AppColors.bg : AppColors.text,
          ),
        ),
      ),
    );
  }
}
