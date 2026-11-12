import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/data/repositories/trip_repository.dart';
import 'package:next_bus/models/stop.dart';
import 'package:next_bus/models/transit_route.dart';
import 'package:next_bus/models/trip.dart';

/// ViewModel de "Mi recorrido" (sección 10.2): ruta, sentido, secuencia de
/// paradas y estado actual del recorrido del conductor.
class MyTripViewModel extends ChangeNotifier {
  final DriverRepository _driverRepository;
  final TripRepository _tripRepository;
  final RouteRepository _routeRepository;
  final StopRepository _stopRepository;

  MyTripViewModel({
    required DriverRepository driverRepository,
    required TripRepository tripRepository,
    required RouteRepository routeRepository,
    required StopRepository stopRepository,
  })  : _driverRepository = driverRepository,
        _tripRepository = tripRepository,
        _routeRepository = routeRepository,
        _stopRepository = stopRepository;

  bool isLoading = true;
  String? errorMessage;

  Trip? trip;
  TransitRoute? route;
  List<Stop> orderedStops = const [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final driver = await _driverRepository.getCurrentDriver();
      final loadedTrip = await _tripRepository.getTripForDriver(driver.id);
      final loadedRoute = await _routeRepository.getRouteById(loadedTrip.routeId);
      final allStops = await _stopRepository.getAllStops();
      final stopsById = {for (final stop in allStops) stop.id: stop};

      trip = loadedTrip;
      route = loadedRoute;
      orderedStops = (loadedRoute?.stopIds ?? const [])
          .where(stopsById.containsKey)
          .map((id) => stopsById[id]!)
          .toList();
    } catch (e) {
      errorMessage = 'No se pudo cargar el recorrido.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
