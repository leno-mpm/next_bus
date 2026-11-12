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
  });

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
    );
  }
}
