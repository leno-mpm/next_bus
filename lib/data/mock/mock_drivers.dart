import 'package:next_bus/models/driver.dart';

/// Conductor de demostración. La app no implementa autenticación real
/// (sección 5), por lo que el conductor "actual" es siempre este registro.
final Driver mockCurrentDriver = Driver(
  id: 'DRV01',
  name: 'Carlos Mendoza',
  licenseId: 'LIC-00451',
  assignedBusId: 'BUS01',
  assignedRouteId: 'R1-SALIDA',
  employeeCode: 'CND-0412',
  licenseType: 'Tipo C',
  licenseExpiry: DateTime(2027, 3, 1),
  shiftHoursLabel: '06:00 – 14:00',
);
