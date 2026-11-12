import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/empty_state.dart';
import 'package:next_bus/core/widgets/section_header.dart';
import 'package:next_bus/core/widgets/status_badge.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/eta_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/features/user/viewmodels/home_viewmodel.dart';
import 'package:next_bus/features/user/widgets/home_arrival_card.dart';
import 'package:next_bus/features/user/widgets/my_stop_picker.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (ctx) => HomeViewModel(
        busRepository: ctx.read<BusRepository>(),
        stopRepository: ctx.read<StopRepository>(),
        routeRepository: ctx.read<RouteRepository>(),
        etaRepository: ctx.read<EtaRepository>(),
      )..load(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('NextBus')),
      body: RefreshIndicator(
        onRefresh: () => context.read<HomeViewModel>().load(),
        child: vm.isLoading && vm.allStops.isEmpty
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
                      _WelcomeCard(vm: vm),
                      const SizedBox(height: 16),
                      MyStopPicker(
                        selectedStop: vm.selectedStop,
                        onTap: () => _openStopPicker(context, vm),
                      ),
                      const SizedBox(height: 16),
                      const SectionHeader(title: 'Buses en camino'),
                      const SizedBox(height: 10),
                      _ArrivalsCarousel(
                        vm: vm,
                        pageController: _pageController,
                        currentPage: _currentPage,
                        onPageChanged: (page) =>
                            setState(() => _currentPage = page),
                      ),
                      const SizedBox(height: 20),
                      const SectionHeader(title: 'Resumen de buses activos'),
                      const SizedBox(height: 10),
                      ...vm.buses.map((bus) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(
                                  Icons.directions_bus_rounded,
                                  color: AppColors.navy),
                              title:
                                  Text(bus.name, style: AppTextStyles.cardTitle),
                              subtitle: Text(
                                bus.routeId ?? 'Sin ruta asignada',
                                style: AppTextStyles.bodySecondary,
                              ),
                              trailing: StatusBadge(
                                label: bus.status.label,
                                color: AppColors.forBusStatus(bus.status),
                                background:
                                    AppColors.bgForBusStatus(bus.status),
                              ),
                            ),
                          )),
                    ],
                  ),
      ),
    );
  }

  Future<void> _openStopPicker(BuildContext context, HomeViewModel vm) async {
    setState(() => _currentPage = 0);
    _pageController.jumpTo(0);
    await showStopPickerSheet(
      context: context,
      stops: vm.allStops,
      selectedStopId: vm.selectedStopId,
      onSelected: (stopId) =>
          context.read<HomeViewModel>().selectStop(stopId),
    );
  }
}

class _ArrivalsCarousel extends StatelessWidget {
  final HomeViewModel vm;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _ArrivalsCarousel({
    required this.vm,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (vm.arrivals.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: EmptyState(
            icon: Icons.directions_bus_rounded,
            title: 'Sin llegadas por ahora',
            message: 'No hay buses en camino hacia esta parada.',
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: vm.carouselCardHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: vm.arrivals.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final arrival = vm.arrivals[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == vm.arrivals.length - 1 ? 0 : 6,
                  left: index == 0 ? 0 : 6,
                ),
                child: HomeArrivalCard(
                  arrival: arrival,
                  index: index,
                  remainingStops:
                      vm.remainingStopsByBusId[arrival.bus.id] ?? const [],
                ),
              );
            },
          ),
        ),
        if (vm.arrivals.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(vm.arrivals.length, (i) {
              final isActive = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.navy : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final HomeViewModel vm;

  const _WelcomeCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bienvenido', style: AppTextStyles.title.copyWith(
                  color: Colors.white,
                )),
                const SizedBox(height: 4),
                const Text(
                  'NextBus · Transporte interno',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${vm.busesEnMarchaCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'buses en marcha',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
