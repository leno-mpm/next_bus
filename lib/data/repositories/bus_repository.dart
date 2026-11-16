import 'package:next_bus/data/mock/mock_buses.dart';
import 'package:next_bus/models/bus.dart';

abstract class BusRepository {
  Future<List<Bus>> getAllBuses();
  Future<Bus?> getBusById(String id);

  /// Suma (o resta) `delta` dólares al combustible consumido por la unidad
  /// este mes. Usado por `FuelRepository.registerLoad` (C7).
  Future<void> adjustFuelUsed(String busId, double delta);

  /// Ajusta el conteo de pasajeros a bordo (C2, botones +/-).
  Future<void> setPassengerCount(String busId, int count);
}

/// Mantiene la flota en memoria durante la sesión: a diferencia de la
/// versión original (solo lectura), combustible y ocupación cambian en
/// vivo por acciones del conductor (sección 11-12, mismo patrón que
/// `MockIncidentRepository`).
class MockBusRepository implements BusRepository {
  final List<Bus> _buses = List.of(mockBuses);

  @override
  Future<List<Bus>> getAllBuses() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_buses);
  }

  @override
  Future<Bus?> getBusById(String id) async {
    final buses = await getAllBuses();
    for (final bus in buses) {
      if (bus.id == id) return bus;
    }
    return null;
  }

  @override
  Future<void> adjustFuelUsed(String busId, double delta) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final index = _buses.indexWhere((bus) => bus.id == busId);
    if (index != -1) {
      final current = _buses[index];
      final updated = current.fuelUsed + delta;
      _buses[index] = current.copyWith(fuelUsed: updated < 0 ? 0 : updated);
    }
  }

  @override
  Future<void> setPassengerCount(String busId, int count) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final index = _buses.indexWhere((bus) => bus.id == busId);
    if (index != -1) {
      final current = _buses[index];
      final clamped =
          count < 0 ? 0 : (count > current.capacity ? current.capacity : count);
      _buses[index] = current.copyWith(passengerCount: clamped);
    }
  }
}
