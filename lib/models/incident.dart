import 'package:next_bus/core/enums/enums.dart';

class Incident {
  final String id;
  final String busId;
  final String driverId;
  final String routeId;
  final String? stopId;
  final IncidentType type;
  final IncidentSeverity severity;
  final String description;
  final DateTime reportedAt;
  final IncidentStatus status;

  /// Minutos de retraso estimados al reportar (C3). Se suman por bus/
  /// conductor para el aviso de retraso en C2, el resumen de C5 y la
  /// bitácora/avisos (C4/S7).
  final int delayMinutes;

  const Incident({
    required this.id,
    required this.busId,
    required this.driverId,
    required this.routeId,
    this.stopId,
    required this.type,
    required this.severity,
    required this.description,
    required this.reportedAt,
    this.status = IncidentStatus.reportada,
    this.delayMinutes = 0,
  });

  bool get isOpen => status != IncidentStatus.resuelta;

  Incident copyWith({IncidentStatus? status}) {
    return Incident(
      id: id,
      busId: busId,
      driverId: driverId,
      routeId: routeId,
      stopId: stopId,
      type: type,
      severity: severity,
      description: description,
      reportedAt: reportedAt,
      status: status ?? this.status,
      delayMinutes: delayMinutes,
    );
  }
}
