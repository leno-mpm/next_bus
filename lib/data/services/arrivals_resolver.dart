import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/mock/mock_etas.dart';
import 'package:next_bus/data/repositories/eta_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/bus_eta.dart';
import 'package:next_bus/models/stop.dart';
import 'package:next_bus/models/transit_route.dart';

/// Un bus candidato a llegar a una parada, ya resuelto con su ETA. Las
/// vistas solo lo pintan; todo el cálculo y filtrado ocurre en
/// [ArrivalsResolver].
class StopArrival {
  final Bus bus;
  final BusEta eta;
  final TransitRoute? route;

  const StopArrival({required this.bus, required this.eta, this.route});

  StopArrival copyWithEta(BusEta newEta) =>
      StopArrival(bus: bus, eta: newEta, route: route);
}

class ArrivalsResult {
  final Stop? stop;
  final List<TransitRoute> routesForStop;
  final List<StopArrival> arrivals;
  final EtaDemoScenario scenario;
  final String scenarioExplanation;

  const ArrivalsResult({
    required this.stop,
    required this.routesForStop,
    required this.arrivals,
    required this.scenario,
    required this.scenarioExplanation,
  });
}

/// Resuelve, para una parada y un escenario de demostración de ETA
/// (sección 9.1), qué buses son llegadas válidas y con qué datos. Lo usan
/// tanto el detalle de parada como la tarjeta "Mi parada" de Inicio, para
/// no duplicar la lógica de filtrado/orden (sección 9.2) en dos ViewModels.
class ArrivalsResolver {
  final StopRepository stopRepository;
  final RouteRepository routeRepository;
  final EtaRepository etaRepository;

  const ArrivalsResolver({
    required this.stopRepository,
    required this.routeRepository,
    required this.etaRepository,
  });

  /// Si la parada coincide con la parada destacada de algún escenario mock,
  /// ese escenario se usa como punto de partida; si no, el primero.
  EtaDemoScenario findScenarioFor(String stopId) {
    final scenarios = buildMockEtaScenarios();
    for (final entry in scenarios.entries) {
      if (entry.value.highlightStopId == stopId) return entry.key;
    }
    return EtaDemoScenario.dosBusesMismoSentido;
  }

  Future<ArrivalsResult> resolve(
    EtaDemoScenario target, {
    String? preferredStopId,
  }) async {
    final data = await etaRepository.getScenarioData(target);
    final stopId = (preferredStopId != null &&
            data.etasByStop.containsKey(preferredStopId))
        ? preferredStopId
        : data.highlightStopId;

    final stop = await stopRepository.getStopById(stopId);
    final routes = await routeRepository.getRoutesForStop(stopId);

    final rawEtas = List<BusEta>.of(data.etasByStop[stopId] ?? []);
    // Regla 9.2: nunca se presenta como llegada normal un bus sin servicio
    // o fuera de ruta, aunque algún dato quedara mal cargado.
    final validEtas = rawEtas.where((eta) {
      final bus = _findBus(data.buses, eta.busId);
      if (bus == null) return false;
      return bus.status != BusStatus.sinServicio &&
          bus.status != BusStatus.fueraDeRuta;
    }).toList()
      ..sort((a, b) => a.etaMinutes.compareTo(b.etaMinutes));

    final arrivals = validEtas.map((eta) {
      final bus = _findBus(data.buses, eta.busId)!;
      final route = routes.where((r) => r.id == bus.routeId).firstOrNull ??
          routes.firstOrNull;
      return StopArrival(bus: bus, eta: eta, route: route);
    }).toList();

    return ArrivalsResult(
      stop: stop,
      routesForStop: routes,
      arrivals: arrivals,
      scenario: target,
      scenarioExplanation: data.explanation,
    );
  }

  Bus? _findBus(List<Bus> buses, String id) {
    for (final bus in buses) {
      if (bus.id == id) return bus;
    }
    return null;
  }
}

/// Simula un "tick" de actualización (sección 9.3): los ETA con GPS
/// actualizado bajan de forma coherente y refrescan su "última
/// actualización"; los de GPS desactualizado se mantienen congelados a
/// propósito, para que se note la diferencia.
List<StopArrival> simulateArrivalsTick(List<StopArrival> arrivals) {
  if (arrivals.isEmpty) return arrivals;
  final updated = arrivals.map((arrival) {
    final eta = arrival.eta;
    if (eta.gpsStatus == GpsStatus.desactualizado) return arrival;
    final newEta = (eta.etaMinutes - 1).clamp(0, 999).toInt();
    final newLower = (eta.etaLowerMinutes - 1).clamp(0, 999).toInt();
    final newUpper = (eta.etaUpperMinutes - 1).clamp(0, 999).toInt();
    return arrival.copyWithEta(eta.copyWith(
      etaMinutes: newEta,
      etaLowerMinutes: newLower,
      etaUpperMinutes: newUpper,
      lastUpdated: DateTime.now(),
    ));
  }).toList()
    ..sort((a, b) => a.eta.etaMinutes.compareTo(b.eta.etaMinutes));
  return updated;
}

extension FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
