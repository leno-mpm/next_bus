import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/models/stop.dart';
import 'package:next_bus/models/transit_route.dart';

class RouteDetailViewModel extends ChangeNotifier {
  final String routeId;
  final RouteRepository _routeRepository;
  final StopRepository _stopRepository;

  RouteDetailViewModel({
    required this.routeId,
    required RouteRepository routeRepository,
    required StopRepository stopRepository,
  })  : _routeRepository = routeRepository,
        _stopRepository = stopRepository;

  bool isLoading = true;
  String? errorMessage;
  TransitRoute? route;
  List<Stop> orderedStops = const [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final loadedRoute = await _routeRepository.getRouteById(routeId);
      if (loadedRoute == null) {
        errorMessage = 'Ruta no encontrada.';
        return;
      }
      final allStops = await _stopRepository.getAllStops();
      final stopsById = {for (final stop in allStops) stop.id: stop};
      route = loadedRoute;
      orderedStops = loadedRoute.stopIds
          .where(stopsById.containsKey)
          .map((id) => stopsById[id]!)
          .toList();
    } catch (e) {
      errorMessage = 'No se pudo cargar el detalle de la ruta.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
