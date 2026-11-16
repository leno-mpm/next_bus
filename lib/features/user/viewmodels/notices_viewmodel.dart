import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/models/incident.dart';

/// ViewModel de S7 (Avisos): lee la misma lista de eventualidades que
/// escribe C3 — no hay un modelo de "aviso" separado, el encabezado del
/// mockup lo dice literalmente ("aparece... en los avisos").
class NoticesViewModel extends ChangeNotifier {
  final IncidentRepository _incidentRepository;

  NoticesViewModel({required IncidentRepository incidentRepository})
      : _incidentRepository = incidentRepository;

  bool isLoading = true;
  String? errorMessage;
  List<Incident> feed = const [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      feed = await _incidentRepository.getAllIncidents();
    } catch (e) {
      errorMessage = 'No se pudieron cargar los avisos.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
