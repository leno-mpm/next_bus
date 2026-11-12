import 'package:flutter/foundation.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/models/incident.dart';
import 'package:next_bus/models/stop.dart';

/// ViewModel del formulario de incidencias (sección 11). Valida los campos
/// obligatorios y delega el guardado al repositorio; la vista solo refleja
/// el estado.
class ReportIncidentViewModel extends ChangeNotifier {
  final DriverRepository _driverRepository;
  final IncidentRepository _incidentRepository;
  final StopRepository _stopRepository;

  ReportIncidentViewModel({
    required DriverRepository driverRepository,
    required IncidentRepository incidentRepository,
    required StopRepository stopRepository,
  })  : _driverRepository = driverRepository,
        _incidentRepository = incidentRepository,
        _stopRepository = stopRepository;

  bool isLoading = true;
  bool isSubmitting = false;
  bool submitted = false;
  String? errorMessage;

  String? driverId;
  String busId = '';
  String routeId = '';
  List<Stop> stops = const [];

  IncidentType type = IncidentType.fallaMecanica;
  IncidentSeverity severity = IncidentSeverity.medio;
  String description = '';
  String? stopId;

  String? descriptionError;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      final driver = await _driverRepository.getCurrentDriver();
      stops = await _stopRepository.getAllStops();
      driverId = driver.id;
      busId = driver.assignedBusId;
      routeId = driver.assignedRouteId;
    } catch (e) {
      errorMessage = 'No se pudo cargar el formulario.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setType(IncidentType value) {
    type = value;
    notifyListeners();
  }

  void setSeverity(IncidentSeverity value) {
    severity = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    descriptionError = null;
    notifyListeners();
  }

  void setStopId(String? value) {
    stopId = value;
    notifyListeners();
  }

  bool _validate() {
    descriptionError = description.trim().isEmpty
        ? 'Describe brevemente lo ocurrido.'
        : null;
    notifyListeners();
    return descriptionError == null;
  }

  Future<bool> submit() async {
    if (!_validate() || driverId == null) return false;
    isSubmitting = true;
    notifyListeners();
    final incident = Incident(
      id: 'INC-${DateTime.now().millisecondsSinceEpoch}',
      busId: busId,
      driverId: driverId!,
      routeId: routeId,
      stopId: stopId,
      type: type,
      severity: severity,
      description: description.trim(),
      reportedAt: DateTime.now(),
    );
    await _incidentRepository.addIncident(incident);
    isSubmitting = false;
    submitted = true;
    notifyListeners();
    return true;
  }
}
