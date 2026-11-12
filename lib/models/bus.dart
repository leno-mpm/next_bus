import 'package:next_bus/core/enums/enums.dart';

class Bus {
  final String id;
  final String name;
  final String plate;
  final BusStatus status;
  final String? routeId;
  final Direction? direction;
  final String? currentSegmentFromStopId;
  final String? currentSegmentToStopId;
  final String? currentStopId;
  final String? nextStopId;

  const Bus({
    required this.id,
    required this.name,
    required this.plate,
    required this.status,
    this.routeId,
    this.direction,
    this.currentSegmentFromStopId,
    this.currentSegmentToStopId,
    this.currentStopId,
    this.nextStopId,
  });

  Bus copyWith({
    BusStatus? status,
    String? routeId,
    Direction? direction,
    String? currentSegmentFromStopId,
    String? currentSegmentToStopId,
    String? currentStopId,
    String? nextStopId,
  }) {
    return Bus(
      id: id,
      name: name,
      plate: plate,
      status: status ?? this.status,
      routeId: routeId ?? this.routeId,
      direction: direction ?? this.direction,
      currentSegmentFromStopId:
          currentSegmentFromStopId ?? this.currentSegmentFromStopId,
      currentSegmentToStopId:
          currentSegmentToStopId ?? this.currentSegmentToStopId,
      currentStopId: currentStopId ?? this.currentStopId,
      nextStopId: nextStopId ?? this.nextStopId,
    );
  }
}
