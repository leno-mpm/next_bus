/// Horario de demostración (sección 7.4). No representa un horario oficial.
class Schedule {
  final String id;
  final String routeId;
  final String serviceStartTime;
  final String serviceEndTime;
  final List<String> departureTimes;
  final List<String> operatingDays;
  final int frequencyMinutes;
  final bool isDemo;

  const Schedule({
    required this.id,
    required this.routeId,
    required this.serviceStartTime,
    required this.serviceEndTime,
    required this.departureTimes,
    required this.operatingDays,
    required this.frequencyMinutes,
    this.isDemo = true,
  });
}
