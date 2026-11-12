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

/// Un tramo restante hasta "mi parada": una parada intermedia (o la parada
/// destino) con su tiempo estimado desde ahora.
class RemainingStop {
  final Stop stop;
  final int etaMinutes;
  final bool isTarget;

  const RemainingStop({
    required this.stop,
    required this.etaMinutes,
    required this.isTarget,
  });
}

/// ViewModel de Inicio (sección 7.1), reenfocado en "mi parada": el usuario
/// elige una parada y ve, en tarjetas deslizables, los buses que se
/// aproximan junto con las paradas que faltan y su tiempo estimado.
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
  Map<String, List<RemainingStop>> remainingStopsByBusId = const {};

  Timer? _simTimer;

  int get busesEnMarchaCount =>
      buses.where((bus) => bus.status == BusStatus.enRuta).length;

  /// Alto de tarjeta del carrusel de Inicio: se ajusta al bus con más
  /// paradas pendientes para no dejar espacio vacío en los casos simples,
  /// pero con un tope para que la página siga siendo manejable.
  double get carouselCardHeight {
    final maxRemaining = remainingStopsByBusId.values
        .fold(0, (m, l) => l.length > m ? l.length : m);
    return (220 + maxRemaining * 34).clamp(260, 420).toDouble();
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
    _rebuildRemainingStops();
  }

  /// Reparte el ETA de cada bus entre las paradas que le faltan hasta "mi
  /// parada", de forma proporcional: es una simulación para mostrar el
  /// avance del recorrido, no una predicción por tramo real.
  void _rebuildRemainingStops() {
    final result = <String, List<RemainingStop>>{};
    for (final arrival in arrivals) {
      final route = arrival.route;
      if (route == null) continue;
      final stopIds = route.stopIds;
      final targetIndex = stopIds.indexOf(selectedStopId);
      if (targetIndex == -1) continue;

      var startIndex = targetIndex;
      final nextStopId = arrival.bus.nextStopId;
      final currentStopId = arrival.bus.currentStopId;
      if (nextStopId != null && stopIds.contains(nextStopId)) {
        startIndex = stopIds.indexOf(nextStopId);
      } else if (currentStopId != null && stopIds.contains(currentStopId)) {
        startIndex = (stopIds.indexOf(currentStopId) + 1)
            .clamp(0, stopIds.length - 1);
      }
      if (startIndex > targetIndex) startIndex = targetIndex;

      final remainingIds = stopIds.sublist(startIndex, targetIndex + 1);
      final count = remainingIds.length;
      final totalEta = arrival.eta.etaMinutes;

      final stops = <RemainingStop>[];
      for (var i = 0; i < count; i++) {
        final stop = _stopsById[remainingIds[i]];
        if (stop == null) continue;
        final isTarget = i == count - 1;
        final etaForStop =
            isTarget ? totalEta : ((totalEta * (i + 1)) / count).round();
        stops.add(RemainingStop(
          stop: stop,
          etaMinutes: etaForStop,
          isTarget: isTarget,
        ));
      }
      result[arrival.bus.id] = stops;
    }
    remainingStopsByBusId = result;
  }

  void _startSimulatedUpdates() {
    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      arrivals = simulateArrivalsTick(arrivals);
      _rebuildRemainingStops();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }
}
