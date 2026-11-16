import 'package:next_bus/models/fuel_load.dart';

/// Historial de cargas de combustible del mes en curso (C7).
final List<FuelLoad> mockFuelLoads = [
  FuelLoad(
    id: 'FL01',
    busId: 'BUS01',
    amount: 20,
    registeredBy: 'Carlos Mendoza',
    registeredAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
  FuelLoad(
    id: 'FL02',
    busId: 'BUS01',
    amount: 22,
    registeredBy: 'Carlos Mendoza',
    registeredAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  FuelLoad(
    id: 'FL03',
    busId: 'BUS02',
    amount: 40,
    registeredBy: 'Daniela Soto',
    registeredAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  FuelLoad(
    id: 'FL04',
    busId: 'BUS02',
    amount: 36,
    registeredBy: 'Daniela Soto',
    registeredAt: DateTime.now().subtract(const Duration(hours: 20)),
  ),
  FuelLoad(
    id: 'FL05',
    busId: 'BUS03',
    amount: 100,
    registeredBy: 'Jorge Lema',
    registeredAt: DateTime.now().subtract(const Duration(days: 9)),
  ),
];
