import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/models/incident.dart';

class IncidentHistoryViewModel extends ChangeNotifier {
  final IncidentRepository _incidentRepository;

  IncidentHistoryViewModel({required IncidentRepository incidentRepository})
      : _incidentRepository = incidentRepository;

  bool isLoading = true;
  String? errorMessage;
  List<Incident> incidents = const [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      incidents = await _incidentRepository.getAllIncidents();
    } catch (e) {
      errorMessage = 'No se pudo cargar el historial de incidencias.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
