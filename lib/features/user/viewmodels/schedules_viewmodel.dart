import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/schedule_repository.dart';
import 'package:next_bus/models/schedule.dart';

class RouteSchedule {
  final Schedule schedule;
  final String routeName;

  const RouteSchedule({required this.schedule, required this.routeName});
}

class SchedulesViewModel extends ChangeNotifier {
  final ScheduleRepository _scheduleRepository;
  final RouteRepository _routeRepository;

  SchedulesViewModel({
    required ScheduleRepository scheduleRepository,
    required RouteRepository routeRepository,
  })  : _scheduleRepository = scheduleRepository,
        _routeRepository = routeRepository;

  bool isLoading = true;
  String? errorMessage;
  List<RouteSchedule> items = const [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final schedules = await _scheduleRepository.getAllSchedules();
      final routes = await _routeRepository.getAllRoutes();
      final nameByGroupId = <String, String>{};
      for (final route in routes) {
        nameByGroupId.putIfAbsent(route.groupId, () => route.name);
      }
      items = schedules
          .map((schedule) => RouteSchedule(
                schedule: schedule,
                routeName: nameByGroupId[schedule.routeId] ?? schedule.routeId,
              ))
          .toList();
    } catch (e) {
      errorMessage = 'No se pudieron cargar los horarios.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
