import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/repositories/eta_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/data/services/arrivals_resolver.dart';
import 'package:next_bus/models/stop.dart';
import 'package:next_bus/models/transit_route.dart';

export 'package:next_bus/data/services/arrivals_resolver.dart' show StopArrival;

/// ViewModel de "Seguimiento de buses y ETA" por parada (sección 9), el
/// núcleo funcional de la app. Administra el escenario de demostración
/// activo, calcula las llegadas válidas para la parada y simula su
/// actualización periódica.
class StopDetailViewModel extends ChangeNotifier {
  final String initialStopId;
  final StopRepository _stopRepository;
  late final ArrivalsResolver _resolver;

  StopDetailViewModel({
    required this.initialStopId,
    required StopRepository stopRepository,
    required RouteRepository routeRepository,
    required EtaRepository etaRepository,
  }) : _stopRepository = stopRepository {
    _resolver = ArrivalsResolver(
      stopRepository: stopRepository,
      routeRepository: routeRepository,
      etaRepository: etaRepository,
    );
  }

  bool isLoading = true;
  String? errorMessage;

  Stop? stop;
  List<TransitRoute> routesForStop = const [];
  List<StopArrival> arrivals = const [];
  late EtaDemoScenario scenario;
  String scenarioExplanation = '';
  Timer? _simTimer;
  Map<String, Stop> _stopsById = const {};

  /// Ruta de referencia para el esquema del recorrido: la del bus más
  /// próximo, o la primera que pase por la parada si no hay llegadas.
  TransitRoute? get primaryRoute =>
      arrivals.firstOrNull?.route ?? routesForStop.firstOrNull;

  List<Stop> get orderedStopsForPrimaryRoute {
    final route = primaryRoute;
    if (route == null) return const [];
    return route.stopIds
        .where(_stopsById.containsKey)
        .map((id) => _stopsById[id]!)
        .toList();
  }

  List<EtaDemoScenario> get availableScenarios =>
      _resolver.etaRepository.getAvailableScenarios();

  Future<void> load() async {
    scenario = _resolver.findScenarioFor(initialStopId);
    await _loadScenario(scenario, preferredStopId: initialStopId);
    _startSimulatedUpdates();
  }

  Future<void> selectScenario(EtaDemoScenario newScenario) async {
    if (newScenario == scenario) return;
    scenario = newScenario;
    await _loadScenario(newScenario);
  }

  Future<void> _loadScenario(EtaDemoScenario target,
      {String? preferredStopId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result =
          await _resolver.resolve(target, preferredStopId: preferredStopId);
      if (_stopsById.isEmpty) {
        final allStops = await _stopRepository.getAllStops();
        _stopsById = {for (final s in allStops) s.id: s};
      }

      stop = result.stop;
      routesForStop = result.routesForStop;
      arrivals = result.arrivals;
      scenarioExplanation = result.scenarioExplanation;
    } catch (e) {
      errorMessage = 'No se pudo cargar la información de la parada.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
