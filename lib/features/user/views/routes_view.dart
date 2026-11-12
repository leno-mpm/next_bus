import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/features/user/viewmodels/routes_viewmodel.dart';
import 'package:next_bus/features/user/views/route_detail_view.dart';
import 'package:next_bus/features/user/widgets/route_card.dart';

class RoutesView extends StatelessWidget {
  const RoutesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoutesViewModel>(
      create: (ctx) => RoutesViewModel(
        routeRepository: ctx.read<RouteRepository>(),
      )..load(),
      child: const _RoutesBody(),
    );
  }
}

class _RoutesBody extends StatelessWidget {
  const _RoutesBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RoutesViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Rutas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todas',
                  selected: vm.directionFilter == null,
                  onTap: () => vm.setDirectionFilter(null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: Direction.salida.label,
                  selected: vm.directionFilter == Direction.salida,
                  onTap: () => vm.setDirectionFilter(Direction.salida),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: Direction.entrada.label,
                  selected: vm.directionFilter == Direction.entrada,
                  onTap: () => vm.setDirectionFilter(Direction.entrada),
                ),
              ],
            ),
          ),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.errorMessage != null
                    ? EmptyState(
                        icon: Icons.error_outline_rounded,
                        title: 'Ocurrió un problema',
                        message: vm.errorMessage!,
                      )
                    : vm.routes.isEmpty
                        ? const EmptyState(
                            icon: Icons.alt_route_rounded,
                            title: 'Sin rutas',
                            message: 'No hay rutas para este filtro.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: vm.routes.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final route = vm.routes[index];
                              return RouteCard(
                                route: route,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RouteDetailView(routeId: route.id),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.navy,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: AppColors.surface,
      side: BorderSide(color: selected ? AppColors.navy : AppColors.border),
    );
  }
}
