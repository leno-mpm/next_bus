import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/eta_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/data/services/arrivals_resolver.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/stop.dart';
import 'package:next_bus/models/transit_route.dart';

/// ViewModel de Inicio (S2): mapa esquemático en vivo + la parada
/// seleccionada con sus llegadas. El mapa usa la flota "en reposo" de
/// `BusRepository` (posición estable); las llegadas a la parada
/// seleccionada siguen viniendo del motor de escenarios de ETA existente
/// (sección 9), sin tocar esa simulación.
class HomeViewModel extends ChangeNotifier {
  final BusRepository _busRepository;
  final StopRepository _stopRepository;
  late final ArrivalsResolver _resolver;

  HomeViewModel({
    required BusRepository busRepository,
    required StopRepository stopRepository,
    required RouteRepository routeRepository,
    required EtaRepository etaRepository,
  })  : _busRepository = busRepository,
        _stopRepository = stopRepository {
    _resolver = ArrivalsResolver(
      stopRepository: stopRepository,
      routeRepository: routeRepository,
      etaRepository: etaRepository,
    );
  }

  bool isLoading = true;
  String? errorMessage;

  List<Bus> buses = const [];
  List<Stop> allStops = const [];
  Map<String, Stop> _stopsById = const {};

  String selectedStopId = 'FIEC';
  Stop? selectedStop;
  List<StopArrival> arrivals = const [];
  List<TransitRoute> routesForStop = const [];

  Timer? _simTimer;

  int get busesEnMarchaCount =>
      buses.where((bus) => bus.status == BusStatus.enRuta).length;

  /// Ruta de referencia para el mapa: la de la llegada más próxima o, si no
  /// hay llegadas, la primera ruta de la flota en reposo.
  TransitRoute? get primaryRoute => _primaryRoute;
  TransitRoute? _primaryRoute;

  List<Stop> get orderedStopsForMap {
    final route = _primaryRoute;
    if (route == null) return const [];
    return route.stopIds
        .where(_stopsById.containsKey)
        .map((id) => _stopsById[id]!)
        .toList();
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      buses = await _busRepository.getAllBuses();
      allStops = await _stopRepository.getAllStops();
      _stopsById = {for (final s in allStops) s.id: s};
      await _loadArrivalsForSelectedStop();
      _startSimulatedUpdates();
    } catch (e) {
      errorMessage = 'No se pudo cargar la información de inicio.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectStop(String stopId) async {
    if (stopId == selectedStopId) return;
    selectedStopId = stopId;
    isLoading = true;
    notifyListeners();
    await _loadArrivalsForSelectedStop();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadArrivalsForSelectedStop() async {
    final scenario = _resolver.findScenarioFor(selectedStopId);
    final result = await _resolver.resolve(
      scenario,
      preferredStopId: selectedStopId,
    );
    selectedStop = result.stop;
    arrivals = result.arrivals;
    routesForStop = result.routesForStop;
    _primaryRoute =
        arrivals.firstOrNull?.route ?? routesForStop.firstOrNull ?? _primaryRoute;
  }

  void _startSimulatedUpdates() {
    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      arrivals = simulateArrivalsTick(arrivals);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }
}
