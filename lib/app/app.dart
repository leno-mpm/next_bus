import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/routes/app_routes.dart';
import 'package:next_bus/app/theme/app_theme.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/eta_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/schedule_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/data/repositories/trip_repository.dart';
import 'package:next_bus/features/driver/shell/driver_shell.dart';
import 'package:next_bus/features/profile_selection/views/profile_selection_view.dart';
import 'package:next_bus/features/user/shell/user_shell.dart';

/// Punto único de inyección de dependencias. Las vistas y ViewModels solo
/// conocen los contratos (`XRepository`); para conectar un backend real en
/// el futuro basta reemplazar las implementaciones `Mock...` aquí.
class NextBusApp extends StatelessWidget {
  const NextBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StopRepository>(create: (_) => MockStopRepository()),
        Provider<RouteRepository>(create: (_) => MockRouteRepository()),
        Provider<BusRepository>(create: (_) => MockBusRepository()),
        Provider<ScheduleRepository>(create: (_) => MockScheduleRepository()),
        Provider<EtaRepository>(create: (_) => MockEtaRepository()),
        Provider<IncidentRepository>(create: (_) => MockIncidentRepository()),
        Provider<DriverRepository>(create: (_) => MockDriverRepository()),
        Provider<TripRepository>(create: (_) => MockTripRepository()),
      ],
      child: MaterialApp(
        title: 'NextBus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.profileSelection,
        routes: {
          AppRoutes.profileSelection: (_) => const ProfileSelectionView(),
          AppRoutes.user: (_) => const UserShell(),
          AppRoutes.driver: (_) => const DriverShell(),
        },
      ),
    );
  }
}
