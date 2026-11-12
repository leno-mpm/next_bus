import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/models/stop.dart';

/// Tarjeta tocable que muestra la parada elegida por el usuario y abre el
/// selector al tocarla. No contiene lógica: solo refleja lo que el
/// ViewModel indique y notifica el toque.
class MyStopPicker extends StatelessWidget {
  final Stop? selectedStop;
  final VoidCallback onTap;

  const MyStopPicker({
    super.key,
    required this.selectedStop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EAF2),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.pin_drop_rounded, color: AppColors.navy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mi parada', style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Text(
                      selectedStop?.name ?? 'Selecciona una parada',
                      style: AppTextStyles.cardTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.unfold_more_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hoja inferior para elegir "mi parada" entre el catálogo de 13 paradas.
Future<void> showStopPickerSheet({
  required BuildContext context,
  required List<Stop> stops,
  required String selectedStopId,
  required ValueChanged<String> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Elige tu parada', style: AppTextStyles.title),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                  itemCount: stops.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final stop = stops[index];
                    final isSelected = stop.id == selectedStopId;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      selected: isSelected,
                      selectedTileColor: const Color(0xFFE3EAF2),
                      leading: Icon(
                        Icons.pin_drop_rounded,
                        color: isSelected
                            ? AppColors.navy
                            : AppColors.textSecondary,
                      ),
                      title: Text(stop.name, style: AppTextStyles.body),
                      subtitle: Text(stop.id, style: AppTextStyles.caption),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.navy)
                          : null,
                      onTap: () {
                        onSelected(stop.id);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
