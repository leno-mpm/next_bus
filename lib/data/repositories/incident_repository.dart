import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/mock/mock_incidents.dart';
import 'package:next_bus/models/incident.dart';

abstract class IncidentRepository {
  Future<List<Incident>> getAllIncidents();
  Future<void> addIncident(Incident incident);
  Future<void> updateIncidentStatus(String id, IncidentStatus status);
}

/// Mantiene las incidencias en memoria durante la sesión (sección 11-12).
/// No hay persistencia en disco/base de datos todavía.
class MockIncidentRepository implements IncidentRepository {
  final List<Incident> _incidents = List.of(mockIncidents);

  @override
  Future<List<Incident>> getAllIncidents() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final sorted = List<Incident>.of(_incidents)
      ..sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
    return List.unmodifiable(sorted);
  }

  @override
  Future<void> addIncident(Incident incident) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _incidents.add(incident);
  }

  @override
  Future<void> updateIncidentStatus(String id, IncidentStatus status) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final index = _incidents.indexWhere((incident) => incident.id == id);
    if (index != -1) {
      _incidents[index] = _incidents[index].copyWith(status: status);
    }
  }
}
