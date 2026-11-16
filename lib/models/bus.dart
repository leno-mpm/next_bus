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

  /// Capacidad de pasajeros sentados/de pie.
  final int capacity;

  /// Pasajeros a bordo en este momento (C2 los ajusta manualmente).
  final int passengerCount;

  /// Dólares de combustible consumidos este mes (C7 los incrementa). Se
  /// compara contra `FuelRepository.monthlyBudgetUsd` para decidir si la
  /// unidad puede asignarse (C1).
  final double fuelUsed;

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
    this.capacity = 50,
    this.passengerCount = 0,
    this.fuelUsed = 0,
  });

  Bus copyWith({
    BusStatus? status,
    String? routeId,
    Direction? direction,
    String? currentSegmentFromStopId,
    String? currentSegmentToStopId,
    String? currentStopId,
    String? nextStopId,
    int? capacity,
    int? passengerCount,
    double? fuelUsed,
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
      capacity: capacity ?? this.capacity,
      passengerCount: passengerCount ?? this.passengerCount,
      fuelUsed: fuelUsed ?? this.fuelUsed,
    );
  }
}
