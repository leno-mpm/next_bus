import 'package:next_bus/data/mock/mock_drivers.dart';
import 'package:next_bus/models/driver.dart';

abstract class DriverRepository {
  Future<Driver> getCurrentDriver();

  /// Conductor asignado a una unidad, si la hay (S5, "Conductor"). Con un
  /// solo conductor de demostración, solo resuelve para su propia unidad.
  Future<Driver?> getDriverForBus(String busId);
}

/// No hay autenticación real (sección 5): siempre devuelve el conductor
/// de demostración.
class MockDriverRepository implements DriverRepository {
  @override
  Future<Driver> getCurrentDriver() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return mockCurrentDriver;
  }

  @override
  Future<Driver?> getDriverForBus(String busId) async {
    final driver = await getCurrentDriver();
    return driver.assignedBusId == busId ? driver : null;
  }
}
