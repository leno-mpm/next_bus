import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/incident_repository.dart';
import 'package:next_bus/data/repositories/shift_repository.dart';
import 'package:next_bus/models/driver.dart';
import 'package:next_bus/models/incident.dart';
import 'package:next_bus/models/shift.dart';

/// ViewModel de C5 (Fin de turno): resumen del turno abierto y su cierre.
/// Lee el mismo `Shift` que abre C1 y las mismas eventualidades que C3/C4.
class EndShiftViewModel extends ChangeNotifier {
  final DriverRepository _driverRepository;
  final ShiftRepository _shiftRepository;
  final IncidentRepository _incidentRepository;

  EndShiftViewModel({
    required DriverRepository driverRepository,
    required ShiftRepository shiftRepository,
    required IncidentRepository incidentRepository,
  })  : _driverRepository = driverRepository,
        _shiftRepository = shiftRepository,
        _incidentRepository = incidentRepository;

  bool isLoading = true;
  bool isClosing = false;
  bool closed = false;
  Driver? driver;
  Shift? shift;
  List<Incident> myIncidents = const [];
  String unitCondition = 'Sin novedad';

  int get openCount => myIncidents.where((i) => i.isOpen).length;
  int get totalDelayMinutes =>
      myIncidents.fold(0, (sum, i) => sum + i.delayMinutes);
  Duration get elapsed => shift == null
      ? Duration.zero
      : DateTime.now().difference(shift!.startedAt);

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    driver = await _driverRepository.getCurrentDriver();
    shift = await _shiftRepository.getCurrentShift(driver!.id);
    final allIncidents = await _incidentRepository.getAllIncidents();
    myIncidents = shift == null
        ? const []
        : allIncidents.where((i) => i.busId == shift!.busId).toList();
    isLoading = false;
    notifyListeners();
  }

  void setUnitCondition(String value) {
    unitCondition = value;
    notifyListeners();
  }

  Future<void> closeShift() async {
    if (shift == null) return;
    isClosing = true;
    notifyListeners();
    await _shiftRepository.endShift(shift!.id, unitCondition);
    isClosing = false;
    closed = true;
    notifyListeners();
  }
}
