import 'package:next_bus/data/mock/mock_routes.dart';
import 'package:next_bus/models/transit_route.dart';

abstract class RouteRepository {
  Future<List<TransitRoute>> getAllRoutes();
  Future<TransitRoute?> getRouteById(String id);
  Future<List<TransitRoute>> getRoutesForStop(String stopId);
}

class MockRouteRepository implements RouteRepository {
  @override
  Future<List<TransitRoute>> getAllRoutes() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(mockRoutes);
  }

  @override
  Future<TransitRoute?> getRouteById(String id) async {
    final routes = await getAllRoutes();
    for (final route in routes) {
      if (route.id == id) return route;
    }
    return null;
  }

  @override
  Future<List<TransitRoute>> getRoutesForStop(String stopId) async {
    final routes = await getAllRoutes();
    return routes.where((route) => route.stopIds.contains(stopId)).toList();
  }
}
