import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/data/services/eta_estimator.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/driver.dart';
import 'package:next_bus/models/incident.dart';
import 'package:next_bus/models/stop.dart';

/// Próxima parada estimada para el bus seleccionado, con una ETA
/// aproximada por distancia de tramos (no hay un motor por-tramo; sección
/// 9 solo resuelve ETA por parada vía escenario).
class UpcomingStop {
  final Stop stop;
  final int etaMinutes;
  const UpcomingStop({required this.stop, required this.etaMinutes});
}

/// ViewModel de S5 (detalle de bus): pestañas entre unidades, ocupación,
/// conductor, aviso de retraso (de `IncidentRepository`, la misma lista que
/// escribe C3) y próximas paradas de la unidad seleccionada.
class BusDetailViewModel extends ChangeNotifier {
  final BusRepository _busRepository;
  final RouteRepository _routeRepository;
  final StopRepository _stopRepository;
  final DriverRepository _driverRepository;
  final IncidentRepository _incidentRepository;

  BusDetailViewModel({
    required String initialBusId,
    required BusRepository busRepository,
    required RouteRepository routeRepository,
    required StopRepository stopRepository,
    required DriverRepository driverRepository,
    required IncidentRepository incidentRepository,
  })  : selectedBusId = initialBusId,
        _busRepository = busRepository,
        _routeRepository = routeRepository,
        _stopRepository = stopRepository,
        _driverRepository = driverRepository,
        _incidentRepository = incidentRepository;

  bool isLoading = true;
  String? errorMessage;

  String selectedBusId;
  List<Bus> buses = const [];
  Bus? get selectedBus =>
      buses.where((b) => b.id == selectedBusId).firstOrNull;

  Driver? driver;
  int openDelayMinutes = 0;
  List<UpcomingStop> upcomingStops = const [];
  Map<String, Stop> _stopsById = const {};

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      buses = await _busRepository.getAllBuses();
      if (_stopsById.isEmpty) {
        final stops = await _stopRepository.getAllStops();
        _stopsById = {for (final s in stops) s.id: s};
      }
      await _loadSelected();
    } catch (e) {
      errorMessage = 'No se pudo cargar la información del bus.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectBus(String busId) async {
    if (busId == selectedBusId) return;
    selectedBusId = busId;
    isLoading = true;
    notifyListeners();
    await _loadSelected();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadSelected() async {
    final bus = selectedBus;
    driver = bus == null ? null : await _driverRepository.getDriverForBus(bus.id);

    final incidents = await _incidentRepository.getAllIncidents();
    openDelayMinutes = incidents
        .where((Incident i) => i.busId == selectedBusId && i.isOpen)
        .fold(0, (sum, i) => sum + i.delayMinutes);

    upcomingStops = const [];
    if (bus?.routeId != null) {
      final route = await _routeRepository.getRouteById(bus!.routeId!);
      if (route != null) {
        final anchorId = bus.nextStopId ?? bus.currentStopId;
        var startIndex = 0;
        if (anchorId != null && route.stopIds.contains(anchorId)) {
          startIndex = route.stopIds.indexOf(anchorId);
        }
        final remainingIds = route.stopIds.skip(startIndex).take(5).toList();
        final stops = <UpcomingStop>[];
        for (var i = 0; i < remainingIds.length; i++) {
          final stop = _stopsById[remainingIds[i]];
          if (stop == null) continue;
          stops.add(UpcomingStop(stop: stop, etaMinutes: sequentialEtaMinutes(i)));
        }
        upcomingStops = stops;
      }
    }
  }
}

extension _FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
