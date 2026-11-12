import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/mock/mock_trips.dart';
import 'package:next_bus/models/trip.dart';

abstract class TripRepository {
  Future<Trip> getTripForDriver(String driverId);
  Future<Trip> startTrip(String tripId);
  Future<Trip> endTrip(String tripId);
}

/// Mantiene el recorrido del conductor en memoria durante la sesión
/// (sección 10). No hay GPS real: el avance de parada es informativo.
class MockTripRepository implements TripRepository {
  Trip _trip = mockInitialTrip;

  @override
  Future<Trip> getTripForDriver(String driverId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _trip;
  }

  @override
  Future<Trip> startTrip(String tripId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _trip = _trip.copyWith(
      status: TripStatus.enCurso,
      startedAt: DateTime.now(),
    );
    return _trip;
  }

  @override
  Future<Trip> endTrip(String tripId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _trip = _trip.copyWith(
      status: TripStatus.finalizado,
      endedAt: DateTime.now(),
    );
    return _trip;
  }
}
