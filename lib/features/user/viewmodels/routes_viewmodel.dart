import 'package:flutter/foundation.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/models/transit_route.dart';

class RoutesViewModel extends ChangeNotifier {
  final RouteRepository _routeRepository;

  RoutesViewModel({required RouteRepository routeRepository})
      : _routeRepository = routeRepository;

  bool isLoading = true;
  String? errorMessage;
  List<TransitRoute> _routes = const [];
  Direction? directionFilter;

  List<TransitRoute> get routes {
    if (directionFilter == null) return _routes;
    return _routes.where((r) => r.direction == directionFilter).toList();
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _routes = await _routeRepository.getAllRoutes();
    } catch (e) {
      errorMessage = 'No se pudieron cargar las rutas.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setDirectionFilter(Direction? direction) {
    directionFilter = direction;
    notifyListeners();
  }
}
