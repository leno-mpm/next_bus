import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/models/incident.dart';

/// Incidencias iniciales de demostración, para que el historial no arranque
/// vacío. Las incidencias que el conductor registre durante la sesión se
/// agregan en memoria mediante `IncidentRepository`.
final List<Incident> mockIncidents = [
  Incident(
    id: 'INC-0001',
    busId: 'BUS02',
    driverId: 'DRV02',
    routeId: 'R1-ENTRADA',
    stopId: 'FCSH',
    type: IncidentType.congestionVehicular,
    severity: IncidentSeverity.medio,
    description:
        'Tráfico denso cerca de FCSH durante la hora pico de la mañana, '
        'retraso aproximado de 8 minutos.',
    reportedAt: DateTime.now().subtract(const Duration(hours: 3)),
    status: IncidentStatus.enRevision,
  ),
  Incident(
    id: 'INC-0002',
    busId: 'BUS03',
    driverId: 'DRV01',
    routeId: 'R2-SALIDA',
    stopId: null,
    type: IncidentType.fallaMecanica,
    severity: IncidentSeverity.alto,
    description: 'Ruido anormal en el motor, unidad retirada por precaución.',
    reportedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    status: IncidentStatus.resuelta,
  ),
];
