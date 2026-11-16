import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/fuel_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/driver.dart';
import 'package:next_bus/models/fuel_load.dart';

/// ViewModel de C7 (Combustible): saldo del presupuesto mensual de la
/// unidad asignada y el registro de nuevas cargas — el lado de escritura
/// de la regla de presupuesto que gatea la asignación en C1.
class FuelViewModel extends ChangeNotifier {
  final BusRepository _busRepository;
  final DriverRepository _driverRepository;
  final FuelRepository _fuelRepository;
  final ShiftRepository _shiftRepository;

  FuelViewModel({
    required BusRepository busRepository,
    required DriverRepository driverRepository,
    required FuelRepository fuelRepository,
    required ShiftRepository shiftRepository,
  })  : _busRepository = busRepository,
        _driverRepository = driverRepository,
        _fuelRepository = fuelRepository,
        _shiftRepository = shiftRepository;

  bool isLoading = true;
  bool isSubmitting = false;
  Driver? driver;
  Bus? bus;
  List<FuelLoad> loads = const [];
  double selectedAmount = 10;

  double get budget => _fuelRepository.monthlyBudgetUsd;
  double get left => bus == null ? 0 : (budget - bus!.fuelUsed).clamp(0, budget);
  bool get blocked => bus != null && bus!.fuelUsed >= budget;
  bool get exceedsBalance => selectedAmount > left;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    driver = await _driverRepository.getCurrentDriver();
    final shift = await _shiftRepository.getCurrentShift(driver!.id);
    bus = await _busRepository.getBusById(shift?.busId ?? driver!.assignedBusId);
    if (bus != null) {
      loads = await _fuelRepository.loadsForBus(bus!.id);
    }
    isLoading = false;
    notifyListeners();
  }

  void setAmount(double amount) {
    selectedAmount = amount;
    notifyListeners();
  }

  Future<void> registerLoad() async {
    if (bus == null) return;
    isSubmitting = true;
    notifyListeners();
    await _fuelRepository.registerLoad(
      bus!.id,
      selectedAmount,
      driver?.name ?? 'Conductor',
    );
    bus = await _busRepository.getBusById(bus!.id);
    loads = await _fuelRepository.loadsForBus(bus!.id);
    isSubmitting = false;
    notifyListeners();
  }
}
