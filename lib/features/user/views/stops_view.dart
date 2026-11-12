import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/features/user/viewmodels/stops_viewmodel.dart';
import 'package:next_bus/features/user/views/stop_detail_view.dart';
import 'package:next_bus/features/user/widgets/stop_card.dart';

class StopsView extends StatelessWidget {
  const StopsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StopsViewModel>(
      create: (ctx) => StopsViewModel(
        stopRepository: ctx.read<StopRepository>(),
      )..load(),
      child: const _StopsBody(),
    );
  }
}

class _StopsBody extends StatelessWidget {
  const _StopsBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StopsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Paradas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: vm.setQuery,
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre o identificador...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
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
                    : vm.stops.isEmpty
                        ? const EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'Sin resultados',
                            message: 'No se encontró ninguna parada.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: vm.stops.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final stop = vm.stops[index];
                              return StopCard(
                                stop: stop,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        StopDetailView(stopId: stop.id),
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
