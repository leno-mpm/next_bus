import 'package:next_bus/core/enums/enums.dart';

/// Recorrido operado por un conductor (perfil conductor, secciones 10-10.2).
class Trip {
  final String id;
  final String driverId;
  final String busId;
  final String routeId;
  final Direction direction;
  final TripStatus status;
  final String? currentStopId;
  final String? nextStopId;
  final DateTime? startedAt;
  final DateTime? endedAt;

  const Trip({
    required this.id,
    required this.driverId,
    required this.busId,
    required this.routeId,
    required this.direction,
    required this.status,
    this.currentStopId,
    this.nextStopId,
    this.startedAt,
    this.endedAt,
  });

  Trip copyWith({
    TripStatus? status,
    String? currentStopId,
    String? nextStopId,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return Trip(
      id: id,
      driverId: driverId,
      busId: busId,
      routeId: routeId,
      direction: direction,
      status: status ?? this.status,
      currentStopId: currentStopId ?? this.currentStopId,
      nextStopId: nextStopId ?? this.nextStopId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }
}
