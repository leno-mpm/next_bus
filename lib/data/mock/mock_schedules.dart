import 'package:next_bus/models/schedule.dart';

/// Horarios de DEMOSTRACIÓN (sección 7.4) — no son horarios oficiales.
final List<Schedule> mockSchedules = [
  const Schedule(
    id: 'SCH-R1',
    routeId: 'R1',
    serviceStartTime: '06:30',
    serviceEndTime: '20:00',
    departureTimes: [
      '06:30', '06:45', '07:00', '07:15', '07:30', '07:45', '08:00',
      '12:00', '12:15', '12:30', '17:00', '17:15', '17:30', '19:45',
    ],
    operatingDays: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'],
    frequencyMinutes: 15,
  ),
  const Schedule(
    id: 'SCH-R2',
    routeId: 'R2',
    serviceStartTime: '07:00',
    serviceEndTime: '18:30',
    departureTimes: ['07:00', '07:20', '07:40', '13:00', '13:20', '18:10'],
    operatingDays: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'],
    frequencyMinutes: 20,
  ),
];
