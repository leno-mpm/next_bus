import 'package:next_bus/models/driver.dart';

/// Conductor de demostración. La app no implementa autenticación real
/// (sección 5), por lo que el conductor "actual" es siempre este registro.
final Driver mockCurrentDriver = const Driver(
  id: 'DRV01',
  name: 'Carlos Mendoza',
  licenseId: 'LIC-00451',
  assignedBusId: 'BUS01',
  assignedRouteId: 'R1-SALIDA',
);
