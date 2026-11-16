import 'package:flutter/foundation.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/fuel_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/data/repositories/trip_repository.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/driver.dart';
import 'package:next_bus/models/shift.dart';
import 'package:next_bus/models/transit_route.dart';
import 'package:next_bus/models/trip.dart';

/// ViewModel de la pestaña "Inicio" del conductor: antes de iniciar turno
/// muestra C1 (unidad asignada + flota, con la regla de presupuesto de
/// combustible); con el turno abierto pasa a mostrar C2 (vuelta en curso).
class DriverHomeViewModel extends ChangeNotifier {
  final DriverRepository _driverRepository;
  final TripRepository _tripRepository;
  final BusRepository _busRepository;
  final RouteRepository _routeRepository;
  final FuelRepository _fuelRepository;
  final ShiftRepository _shiftRepository;
  final IncidentRepository _incidentRepository;

  DriverHomeViewModel({
    required DriverRepository driverRepository,
    required TripRepository tripRepository,
    required BusRepository busRepository,
    required RouteRepository routeRepository,
    required FuelRepository fuelRepository,
    required ShiftRepository shiftRepository,
    required IncidentRepository incidentRepository,
  })  : _driverRepository = driverRepository,
        _tripRepository = tripRepository,
        _busRepository = busRepository,
        _routeRepository = routeRepository,
        _fuelRepository = fuelRepository,
        _shiftRepository = shiftRepository,
        _incidentRepository = incidentRepository;

  bool isLoading = true;
  bool isUpdating = false;
  String? errorMessage;

  Driver? driver;
  List<Bus> fleet = const [];
  Bus? assignedBus;
  bool wasReassigned = false;
  TransitRoute? assignedRoute;
  Trip? trip;
  Shift? shift;
  int openDelayMinutes = 0;

  double get fuelBudget => _fuelRepository.monthlyBudgetUsd;
  bool get hasAssignableUnit => assignedBus != null;
  bool get shiftOpen => shift != null;

  bool isAssignable(Bus bus) => bus.fuelUsed < fuelBudget;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final loadedDriver = await _driverRepository.getCurrentDriver();
      fleet = await _busRepository.getAllBuses();
      driver = loadedDriver;
      shift = await _shiftRepository.getCurrentShift(loadedDriver.id);

      if (shift != null) {
        // El turno ya fijó qué unidad se conduce hoy — no se recalcula con
        // el presupuesto en vivo, igual que en C1 el día de la asignación.
        assignedBus = fleet.where((b) => b.id == shift!.busId).firstOrNull;
        wasReassigned = shift!.busId != loadedDriver.assignedBusId;
      } else {
        final homeBus = fleet
            .where((b) => b.id == loadedDriver.assignedBusId)
            .firstOrNull;
        if (homeBus != null && isAssignable(homeBus)) {
          assignedBus = homeBus;
          wasReassigned = false;
        } else {
          assignedBus = fleet.where(isAssignable).firstOrNull;
          wasReassigned = assignedBus != null;
        }
      }

      assignedRoute = await _routeRepository.getRouteById(
        loadedDriver.assignedRouteId,
      );
      trip = await _tripRepository.getTripForDriver(loadedDriver.id);

      if (assignedBus != null) {
        final incidents = await _incidentRepository.getAllIncidents();
        openDelayMinutes = incidents
            .where((i) => i.busId == assignedBus!.id && i.isOpen)
            .fold(0, (sum, i) => sum + i.delayMinutes);
      }
    } catch (e) {
      errorMessage = 'No se pudo cargar la información del conductor.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startShift() async {
    if (driver == null || assignedBus == null || shiftOpen) return;
    isUpdating = true;
    notifyListeners();
    shift = await _shiftRepository.startShift(driver!.id, assignedBus!.id);
    isUpdating = false;
    notifyListeners();
  }

  /// Alterna cada vuelta: sin vuelta en curso la inicia, en curso la
  /// termina y suma una vuelta completa al turno.
  Future<void> toggleLap() async {
    if (trip == null || shift == null) return;
    isUpdating = true;
    notifyListeners();
    if (trip!.status == TripStatus.enCurso) {
      trip = await _tripRepository.endTrip(trip!.id);
      await _shiftRepository.completeLap(shift!.id);
      shift = await _shiftRepository.getCurrentShift(driver!.id);
    } else {
      trip = await _tripRepository.startTrip(trip!.id);
    }
    isUpdating = false;
    notifyListeners();
  }

  Future<void> adjustPassengers(int delta) async {
    final bus = assignedBus;
    if (bus == null) return;
    await _busRepository.setPassengerCount(bus.id, bus.passengerCount + delta);
    fleet = await _busRepository.getAllBuses();
    assignedBus = fleet.where((b) => b.id == bus.id).firstOrNull;
    notifyListeners();
  }
}

extension _FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
