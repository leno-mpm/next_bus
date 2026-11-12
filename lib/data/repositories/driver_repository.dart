import 'package:next_bus/data/mock/mock_drivers.dart';
import 'package:next_bus/models/driver.dart';

abstract class DriverRepository {
  Future<Driver> getCurrentDriver();
}

/// No hay autenticación real (sección 5): siempre devuelve el conductor
/// de demostración.
class MockDriverRepository implements DriverRepository {
  @override
  Future<Driver> getCurrentDriver() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return mockCurrentDriver;
  }
}
