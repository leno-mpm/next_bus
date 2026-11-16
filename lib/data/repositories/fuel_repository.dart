import 'package:next_bus/data/mock/mock_fuel_loads.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/models/fuel_load.dart';

abstract class FuelRepository {
  /// Presupuesto mensual por unidad, en dólares (C7's "Presupuesto mensual
  /// ESPOL"). Una unidad con `fuelUsed >= monthlyBudgetUsd` no se asigna
  /// (C1).
  double get monthlyBudgetUsd;

  Future<List<FuelLoad>> loadsForBus(String busId);

  /// Registra una carga y suma su monto a `Bus.fuelUsed` (vía
  /// `BusRepository`) — este es el lado de escritura de la regla de
  /// presupuesto compartida entre C7, C1 y C2.
  Future<void> registerLoad(String busId, double amount, String registeredBy);
}

class MockFuelRepository implements FuelRepository {
  MockFuelRepository(this._busRepository);

  final BusRepository _busRepository;
  final List<FuelLoad> _loads = List.of(mockFuelLoads);

  @override
  double get monthlyBudgetUsd => 100;

  @override
  Future<List<FuelLoad>> loadsForBus(String busId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final filtered = _loads.where((load) => load.busId == busId).toList()
      ..sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
    return List.unmodifiable(filtered);
  }

  @override
  Future<void> registerLoad(
    String busId,
    double amount,
    String registeredBy,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _loads.add(FuelLoad(
      id: 'FL${_loads.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      busId: busId,
      amount: amount,
      registeredBy: registeredBy,
      registeredAt: DateTime.now(),
    ));
    await _busRepository.adjustFuelUsed(busId, amount);
  }
}
