import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/bus_eta.dart';

/// Paquete de datos de un escenario de demostración de ETA (sección 9.1):
/// el estado de los buses implicados, sus ETA por parada y qué parada
/// conviene preseleccionar para que el escenario se entienda de inmediato.
class EtaScenarioData {
  final String title;
  final String explanation;
  final String highlightStopId;
  final List<Bus> buses;
  final Map<String, List<BusEta>> etasByStop;

  const EtaScenarioData({
    required this.title,
    required this.explanation,
    required this.highlightStopId,
    required this.buses,
    required this.etasByStop,
  });
}

/// Genera los escenarios mock de ETA. Es una función (no una constante) para
/// que `lastUpdated` se calcule relativo al momento en que se activa el
/// escenario, y así la demo de "actualización simulada" luzca coherente.
Map<EtaDemoScenario, EtaScenarioData> buildMockEtaScenarios() {
  final now = DateTime.now();

  return {
    EtaDemoScenario.dosBusesMismoSentido: EtaScenarioData(
      title: 'Dos buses en el mismo sentido',
      explanation:
          'BUS01 y BUS02 van en sentido SALIDA hacia FCV, uno detrás del otro.',
      highlightStopId: 'FCV',
      buses: [
        const Bus(
          id: 'BUS01',
          name: 'Unidad 01',
          plate: 'GYE-0101',
          status: BusStatus.enRuta,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
          currentSegmentFromStopId: 'GARE',
          currentSegmentToStopId: 'FCV',
          nextStopId: 'FCV',
        ),
        const Bus(
          id: 'BUS02',
          name: 'Unidad 02',
          plate: 'GYE-0102',
          status: BusStatus.enRuta,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
          currentSegmentFromStopId: 'GARE',
          currentSegmentToStopId: 'FCV',
          nextStopId: 'FCV',
        ),
        const Bus(
          id: 'BUS03',
          name: 'Unidad 03',
          plate: 'GYE-0103',
          status: BusStatus.sinServicio,
          routeId: 'R2-SALIDA',
          direction: Direction.salida,
        ),
      ],
      etasByStop: {
        'FCV': [
          BusEta(
            busId: 'BUS01',
            stopId: 'FCV',
            etaMinutes: 3,
            etaLowerMinutes: 2,
            etaUpperMinutes: 4,
            confidence: EtaConfidence.alta,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
          BusEta(
            busId: 'BUS02',
            stopId: 'FCV',
            etaMinutes: 9,
            etaLowerMinutes: 7,
            etaUpperMinutes: 11,
            confidence: EtaConfidence.alta,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
        ],
      },
    ),

    EtaDemoScenario.dosBusesSentidoOpuesto: EtaScenarioData(
      title: 'Dos buses en sentidos opuestos',
      explanation:
          'BUS01 (SALIDA) y BUS02 (ENTRADA) convergen hacia Biblioteca desde '
          'direcciones distintas de su recorrido.',
      highlightStopId: 'BIB',
      buses: [
        const Bus(
          id: 'BUS01',
          name: 'Unidad 01',
          plate: 'GYE-0101',
          status: BusStatus.enRuta,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
          currentSegmentFromStopId: 'FCV',
          currentSegmentToStopId: 'BIB',
          nextStopId: 'BIB',
        ),
        const Bus(
          id: 'BUS02',
          name: 'Unidad 02',
          plate: 'GYE-0102',
          status: BusStatus.enRuta,
          routeId: 'R1-ENTRADA',
          direction: Direction.entrada,
          currentSegmentFromStopId: 'FCSH',
          currentSegmentToStopId: 'BIB',
          nextStopId: 'BIB',
        ),
        const Bus(
          id: 'BUS03',
          name: 'Unidad 03',
          plate: 'GYE-0103',
          status: BusStatus.disponible,
          routeId: 'R2-SALIDA',
          direction: Direction.salida,
          currentStopId: 'EBUS',
        ),
      ],
      etasByStop: {
        'BIB': [
          BusEta(
            busId: 'BUS01',
            stopId: 'BIB',
            etaMinutes: 6,
            etaLowerMinutes: 5,
            etaUpperMinutes: 8,
            confidence: EtaConfidence.alta,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
          BusEta(
            busId: 'BUS02',
            stopId: 'BIB',
            etaMinutes: 7,
            etaLowerMinutes: 6,
            etaUpperMinutes: 9,
            confidence: EtaConfidence.alta,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
        ],
      },
    ),

    EtaDemoScenario.tresBusesActivos: EtaScenarioData(
      title: 'Tres buses activos',
      explanation:
          'Las tres unidades están en ruta, todas con rumbo hacia FIEC.',
      highlightStopId: 'FIEC',
      buses: [
        const Bus(
          id: 'BUS01',
          name: 'Unidad 01',
          plate: 'GYE-0101',
          status: BusStatus.enRuta,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
          currentSegmentFromStopId: 'FCSH',
          currentSegmentToStopId: 'FIEC',
          nextStopId: 'FIEC',
        ),
        const Bus(
          id: 'BUS02',
          name: 'Unidad 02',
          plate: 'GYE-0102',
          status: BusStatus.enRuta,
          routeId: 'R1-ENTRADA',
          direction: Direction.entrada,
          currentSegmentFromStopId: 'CEP',
          currentSegmentToStopId: 'FIEC',
          nextStopId: 'FIEC',
        ),
        const Bus(
          id: 'BUS03',
          name: 'Unidad 03',
          plate: 'GYE-0103',
          status: BusStatus.enRuta,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
          currentSegmentFromStopId: 'BIB',
          currentSegmentToStopId: 'FCSH',
          nextStopId: 'FCSH',
        ),
      ],
      etasByStop: {
        'FIEC': [
          BusEta(
            busId: 'BUS01',
            stopId: 'FIEC',
            etaMinutes: 4,
            etaLowerMinutes: 3,
            etaUpperMinutes: 6,
            confidence: EtaConfidence.alta,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
          BusEta(
            busId: 'BUS02',
            stopId: 'FIEC',
            etaMinutes: 8,
            etaLowerMinutes: 6,
            etaUpperMinutes: 10,
            confidence: EtaConfidence.media,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
          BusEta(
            busId: 'BUS03',
            stopId: 'FIEC',
            etaMinutes: 13,
            etaLowerMinutes: 10,
            etaUpperMinutes: 16,
            confidence: EtaConfidence.media,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
        ],
      },
    ),

    EtaDemoScenario.busGpsDesactualizado: EtaScenarioData(
      title: 'Bus con GPS desactualizado',
      explanation:
          'BUS02 no ha enviado posición reciente: su ETA se muestra con '
          'confiabilidad baja y la señal de GPS desactualizado visible.',
      highlightStopId: 'EBUS',
      buses: [
        Bus(
          id: 'BUS02',
          name: 'Unidad 02',
          plate: 'GYE-0102',
          status: BusStatus.gpsDesactualizado,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
          currentSegmentFromStopId: 'FAD',
          currentSegmentToStopId: 'EBUS',
          nextStopId: 'EBUS',
        ),
        const Bus(
          id: 'BUS01',
          name: 'Unidad 01',
          plate: 'GYE-0101',
          status: BusStatus.sinServicio,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
        ),
        const Bus(
          id: 'BUS03',
          name: 'Unidad 03',
          plate: 'GYE-0103',
          status: BusStatus.disponible,
          routeId: 'R2-SALIDA',
          direction: Direction.salida,
          currentStopId: 'GARE',
        ),
      ],
      etasByStop: {
        'EBUS': [
          BusEta(
            busId: 'BUS02',
            stopId: 'EBUS',
            etaMinutes: 11,
            etaLowerMinutes: 7,
            etaUpperMinutes: 17,
            confidence: EtaConfidence.baja,
            lastUpdated: now.subtract(const Duration(minutes: 12)),
            gpsStatus: GpsStatus.desactualizado,
          ),
        ],
      },
    ),

    EtaDemoScenario.busDetenidoEnParada: EtaScenarioData(
      title: 'Bus detenido en una parada',
      explanation:
          'BUS03 está detenido en FAD; su posición es exacta, por lo que su '
          'ETA hacia GYM es confiable aunque corta.',
      highlightStopId: 'GYM',
      buses: [
        const Bus(
          id: 'BUS03',
          name: 'Unidad 03',
          plate: 'GYE-0103',
          status: BusStatus.enParada,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
          currentStopId: 'FAD',
          nextStopId: 'GYM',
        ),
        const Bus(
          id: 'BUS01',
          name: 'Unidad 01',
          plate: 'GYE-0101',
          status: BusStatus.enRuta,
          routeId: 'R1-ENTRADA',
          direction: Direction.entrada,
          currentSegmentFromStopId: 'GARS',
          currentSegmentToStopId: 'GYM',
          nextStopId: 'GYM',
        ),
        const Bus(
          id: 'BUS02',
          name: 'Unidad 02',
          plate: 'GYE-0102',
          status: BusStatus.sinServicio,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
        ),
      ],
      etasByStop: {
        'GYM': [
          BusEta(
            busId: 'BUS03',
            stopId: 'GYM',
            etaMinutes: 2,
            etaLowerMinutes: 1,
            etaUpperMinutes: 3,
            confidence: EtaConfidence.alta,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
          BusEta(
            busId: 'BUS01',
            stopId: 'GYM',
            etaMinutes: 5,
            etaLowerMinutes: 4,
            etaUpperMinutes: 7,
            confidence: EtaConfidence.alta,
            lastUpdated: now,
            gpsStatus: GpsStatus.actualizado,
          ),
        ],
      },
    ),

    EtaDemoScenario.busFueraDeRuta: EtaScenarioData(
      title: 'Bus fuera de ruta',
      explanation:
          'BUS01 reporta una posición fuera de su recorrido asignado: no se '
          'presenta como una llegada normal en ninguna parada.',
      highlightStopId: 'PSC',
      buses: [
        const Bus(
          id: 'BUS01',
          name: 'Unidad 01',
          plate: 'GYE-0101',
          status: BusStatus.fueraDeRuta,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
        ),
        const Bus(
          id: 'BUS02',
          name: 'Unidad 02',
          plate: 'GYE-0102',
          status: BusStatus.sinServicio,
          routeId: 'R1-ENTRADA',
          direction: Direction.entrada,
        ),
        const Bus(
          id: 'BUS03',
          name: 'Unidad 03',
          plate: 'GYE-0103',
          status: BusStatus.sinServicio,
          routeId: 'R2-SALIDA',
          direction: Direction.salida,
        ),
      ],
      etasByStop: const {'PSC': []},
    ),

    EtaDemoScenario.ningunBusDisponible: EtaScenarioData(
      title: 'Ningún bus disponible',
      explanation:
          'No hay unidades circulando por CTI en este momento de la demo.',
      highlightStopId: 'CTI',
      buses: [
        const Bus(
          id: 'BUS01',
          name: 'Unidad 01',
          plate: 'GYE-0101',
          status: BusStatus.sinServicio,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
        ),
        const Bus(
          id: 'BUS02',
          name: 'Unidad 02',
          plate: 'GYE-0102',
          status: BusStatus.sinServicio,
          routeId: 'R1-ENTRADA',
          direction: Direction.entrada,
        ),
        const Bus(
          id: 'BUS03',
          name: 'Unidad 03',
          plate: 'GYE-0103',
          status: BusStatus.sinServicio,
          routeId: 'R2-SALIDA',
          direction: Direction.salida,
        ),
      ],
      etasByStop: const {'CTI': []},
    ),

    EtaDemoScenario.busSinServicio: EtaScenarioData(
      title: 'Bus sin servicio',
      explanation:
          'BUS02 está marcado SIN_SERVICIO: no genera ETA para ninguna '
          'parada aunque conserve una ruta asignada.',
      highlightStopId: 'CEP',
      buses: [
        const Bus(
          id: 'BUS02',
          name: 'Unidad 02',
          plate: 'GYE-0102',
          status: BusStatus.sinServicio,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
        ),
        const Bus(
          id: 'BUS01',
          name: 'Unidad 01',
          plate: 'GYE-0101',
          status: BusStatus.disponible,
          routeId: 'R1-SALIDA',
          direction: Direction.salida,
          currentStopId: 'GARE',
        ),
        const Bus(
          id: 'BUS03',
          name: 'Unidad 03',
          plate: 'GYE-0103',
          status: BusStatus.disponible,
          routeId: 'R2-SALIDA',
          direction: Direction.salida,
          currentStopId: 'GARE',
        ),
      ],
      etasByStop: const {'CEP': []},
    ),
  };
}
