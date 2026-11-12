import 'package:next_bus/data/mock/mock_schedules.dart';
import 'package:next_bus/models/schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getAllSchedules();
  Future<Schedule?> getScheduleByRouteGroup(String routeGroupId);
}

class MockScheduleRepository implements ScheduleRepository {
  @override
  Future<List<Schedule>> getAllSchedules() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(mockSchedules);
  }

  @override
  Future<Schedule?> getScheduleByRouteGroup(String routeGroupId) async {
    final schedules = await getAllSchedules();
    for (final schedule in schedules) {
      if (schedule.routeId == routeGroupId) return schedule;
    }
    return null;
  }
}
