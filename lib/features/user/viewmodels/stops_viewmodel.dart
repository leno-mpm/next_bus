import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/bus_repository.dart';
import 'package:next_bus/data/repositories/route_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/data/services/eta_estimator.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/stop.dart';

/// Una fila de la lista de S3: o bien una parada (con ETA del bus
/// filtrado, si hay uno) o el marcador de posición del propio bus.
class StopRow {
  final Stop? stop;
  final Bus? busMarker;
  final int? etaMinutes;

  const StopRow.stop(this.stop, {this.etaMinutes}) : busMarker = null;
  const StopRow.bus(this.busMarker)
      : stop = null,
        etaMinutes = null;

  bool get isBusMarker => busMarker != null;
}

/// ViewModel de S3 (Paradas): lista con búsqueda libre, o — al elegir un bus
/// en el filtro — la secuencia completa de su ruta con su posición y ETA
/// aproximada por parada.
class StopsViewModel extends ChangeNotifier {
  final StopRepository _stopRepository;
  final BusRepository _busRepository;
  final RouteRepository _routeRepository;

  StopsViewModel({
    required StopRepository stopRepository,
    required BusRepository busRepository,
    required RouteRepository routeRepository,
  })  : _stopRepository = stopRepository,
        _busRepository = busRepository,
        _routeRepository = routeRepository;

  bool isLoading = true;
  String? errorMessage;
  List<Stop> _stops = const [];
  Map<String, Stop> _stopsById = const {};
  List<Bus> buses = const [];
  String query = '';

  /// `null` = "Todas" (sin filtro de bus).
  String? busFilterId;

  List<Stop> get allStopsFiltered {
    if (query.trim().isEmpty) return _stops;
    final normalized = query.trim().toLowerCase();
    return _stops.where((stop) {
      return stop.name.toLowerCase().contains(normalized) ||
          stop.id.toLowerCase().contains(normalized);
    }).toList();
  }

  List<StopRow> _busRows = const [];
  List<StopRow> get rows {
    if (busFilterId == null) {
      return allStopsFiltered.map(StopRow.stop).toList();
    }
    return _busRows;
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _stops = await _stopRepository.getAllStops();
      _stopsById = {for (final s in _stops) s.id: s};
      buses = await _busRepository.getAllBuses();
    } catch (e) {
      errorMessage = 'No se pudieron cargar las paradas.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  Future<void> setBusFilter(String? busId) async {
    busFilterId = busId;
    if (busId == null) {
      notifyListeners();
      return;
    }
    final bus = buses.where((b) => b.id == busId).firstOrNull;
    if (bus?.routeId == null) {
      _busRows = const [];
      notifyListeners();
      return;
    }
    final route = await _routeRepository.getRouteById(bus!.routeId!);
    if (route == null) {
      _busRows = const [];
      notifyListeners();
      return;
    }
    final rows = <StopRow>[];
    var etaIndex = 0;
    for (final stopId in route.stopIds) {
      final stop = _stopsById[stopId];
      if (stop == null) continue;
      final isCurrentSegmentStart = bus.currentSegmentFromStopId == stopId;
      rows.add(StopRow.stop(stop, etaMinutes: sequentialEtaMinutes(etaIndex)));
      etaIndex++;
      if (isCurrentSegmentStart) {
        rows.add(StopRow.bus(bus));
      }
    }
    _busRows = rows;
    notifyListeners();
  }
}

extension _FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
