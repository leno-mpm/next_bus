import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/trip_repository.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/driver.dart';
import 'package:next_bus/models/transit_route.dart';
import 'package:next_bus/models/trip.dart';

/// ViewModel de Inicio del conductor (sección 10.1): resume la asignación
/// del conductor y permite iniciar/finalizar el recorrido.
class DriverHomeViewModel extends ChangeNotifier {
  final DriverRepository _driverRepository;
  final TripRepository _tripRepository;
  final BusRepository _busRepository;
  final RouteRepository _routeRepository;

  DriverHomeViewModel({
    required DriverRepository driverRepository,
    required TripRepository tripRepository,
    required BusRepository busRepository,
    required RouteRepository routeRepository,
  })  : _driverRepository = driverRepository,
        _tripRepository = tripRepository,
        _busRepository = busRepository,
        _routeRepository = routeRepository;

  bool isLoading = true;
  bool isUpdatingTrip = false;
  String? errorMessage;

  Driver? driver;
  Bus? assignedBus;
  TransitRoute? assignedRoute;
  Trip? trip;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final loadedDriver = await _driverRepository.getCurrentDriver();
      final loadedTrip = await _tripRepository.getTripForDriver(loadedDriver.id);
      final bus = await _busRepository.getBusById(loadedDriver.assignedBusId);
      final route =
          await _routeRepository.getRouteById(loadedDriver.assignedRouteId);

      driver = loadedDriver;
      trip = loadedTrip;
      assignedBus = bus;
      assignedRoute = route;
    } catch (e) {
      errorMessage = 'No se pudo cargar la información del conductor.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startTrip() async {
    if (trip == null) return;
    isUpdatingTrip = true;
    notifyListeners();
    trip = await _tripRepository.startTrip(trip!.id);
    isUpdatingTrip = false;
    notifyListeners();
  }

  Future<void> endTrip() async {
    if (trip == null) return;
    isUpdatingTrip = true;
    notifyListeners();
    trip = await _tripRepository.endTrip(trip!.id);
    isUpdatingTrip = false;
    notifyListeners();
  }
}
