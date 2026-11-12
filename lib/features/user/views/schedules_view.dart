import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/core/widgets/demo_banner.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/schedule_repository.dart';
import 'package:next_bus/features/user/viewmodels/schedules_viewmodel.dart';
import 'package:next_bus/features/user/widgets/schedule_card.dart';

class SchedulesView extends StatelessWidget {
  const SchedulesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SchedulesViewModel>(
      create: (ctx) => SchedulesViewModel(
        scheduleRepository: ctx.read<ScheduleRepository>(),
        routeRepository: ctx.read<RouteRepository>(),
      )..load(),
      child: const _SchedulesBody(),
    );
  }
}

class _SchedulesBody extends StatelessWidget {
  const _SchedulesBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SchedulesViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Horarios')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
              ? EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Ocurrió un problema',
                  message: vm.errorMessage!,
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const DemoBanner(
                      text: 'Horarios de demostración — no son horarios '
                          'oficiales del servicio.',
                    ),
                    const SizedBox(height: 14),
                    ...vm.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ScheduleCard(item: item),
                        )),
                  ],
                ),
    );
  }
}
