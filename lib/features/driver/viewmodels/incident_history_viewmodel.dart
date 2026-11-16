import 'package:flutter/foundation.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/models/incident.dart';

/// ViewModel de C4 (Bitácora del turno): eventualidades del bus asignado al
/// conductor actual, con conteo de abiertas/resueltas y la acción de
/// resolver — misma lista que escribe C3 y lee S7.
class IncidentHistoryViewModel extends ChangeNotifier {
  final IncidentRepository _incidentRepository;
  final DriverRepository _driverRepository;
  final ShiftRepository _shiftRepository;

  IncidentHistoryViewModel({
    required IncidentRepository incidentRepository,
    required DriverRepository driverRepository,
    required ShiftRepository shiftRepository,
  })  : _incidentRepository = incidentRepository,
        _driverRepository = driverRepository,
        _shiftRepository = shiftRepository;

  bool isLoading = true;
  String? errorMessage;
  List<Incident> incidents = const [];
  String busId = '';

  int get openCount => incidents.where((i) => i.isOpen).length;
  int get resolvedCount => incidents.length - openCount;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final driver = await _driverRepository.getCurrentDriver();
      final shift = await _shiftRepository.getCurrentShift(driver.id);
      busId = shift?.busId ?? driver.assignedBusId;
      final all = await _incidentRepository.getAllIncidents();
      incidents = all.where((i) => i.busId == busId).toList();
    } catch (e) {
      errorMessage = 'No se pudo cargar la bitácora.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resolve(String incidentId) async {
    await _incidentRepository.updateIncidentStatus(
      incidentId,
      IncidentStatus.resuelta,
    );
    await load();
  }
}
