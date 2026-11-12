import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/models/trip.dart';

/// Recorrido inicial (no iniciado) asignado al conductor de demostración.
final Trip mockInitialTrip = const Trip(
  id: 'TRIP01',
  driverId: 'DRV01',
  busId: 'BUS01',
  routeId: 'R1-SALIDA',
  direction: Direction.salida,
  status: TripStatus.noIniciado,
  currentStopId: 'GARE',
  nextStopId: 'FCV',
);
