/// Enums centrales de la app. Los `label` son textos en español listos para
/// mostrarse en la UI, para no repetir mapeos texto↔valor en cada vista.
library;

enum Direction {
  salida,
  entrada;

  String get label => switch (this) {
        Direction.salida => 'Salida',
        Direction.entrada => 'Entrada',
      };
}

enum BusStatus {
  enRuta,
  enParada,
  disponible,
  sinServicio,
  gpsDesactualizado,
  fueraDeRuta;

  String get label => switch (this) {
        BusStatus.enRuta => 'En ruta',
        BusStatus.enParada => 'En parada',
        BusStatus.disponible => 'Disponible',
        BusStatus.sinServicio => 'Sin servicio',
        BusStatus.gpsDesactualizado => 'GPS desactualizado',
        BusStatus.fueraDeRuta => 'Fuera de ruta',
      };

  /// Si el bus en este estado puede considerarse una "próxima llegada" normal.
  bool get isNormalArrival =>
      this == BusStatus.enRuta || this == BusStatus.enParada;
}

enum RouteStatus {
  activa,
  suspendida,
  inactiva;

  String get label => switch (this) {
        RouteStatus.activa => 'Activa',
        RouteStatus.suspendida => 'Suspendida',
        RouteStatus.inactiva => 'Inactiva',
      };
}

enum ServiceStatus {
  operativo,
  interrumpido,
  finalizado;

  String get label => switch (this) {
        ServiceStatus.operativo => 'Operativo',
        ServiceStatus.interrumpido => 'Interrumpido',
        ServiceStatus.finalizado => 'Finalizado por hoy',
      };
}

enum EtaConfidence {
  alta,
  media,
  baja;

  String get label => switch (this) {
        EtaConfidence.alta => 'Confiabilidad alta',
        EtaConfidence.media => 'Confiabilidad media',
        EtaConfidence.baja => 'Confiabilidad baja',
      };
}

enum GpsStatus {
  actualizado,
  desactualizado;

  String get label => switch (this) {
        GpsStatus.actualizado => 'GPS actualizado',
        GpsStatus.desactualizado => 'GPS desactualizado',
      };
}

enum TripStatus {
  noIniciado,
  enCurso,
  finalizado;

  String get label => switch (this) {
        TripStatus.noIniciado => 'No iniciado',
        TripStatus.enCurso => 'En curso',
        TripStatus.finalizado => 'Finalizado',
      };
}

enum IncidentType {
  fallaMecanica,
  accidente,
  retraso,
  congestionVehicular,
  problemasParada,
  problemasPasajeros,
  desvioRuta,
  clima,
  otro;

  String get label => switch (this) {
        IncidentType.fallaMecanica => 'Falla mecánica',
        IncidentType.accidente => 'Accidente',
        IncidentType.retraso => 'Retraso',
        IncidentType.congestionVehicular => 'Congestión vehicular',
        IncidentType.problemasParada => 'Problemas en una parada',
        IncidentType.problemasPasajeros => 'Problemas con pasajeros',
        IncidentType.desvioRuta => 'Desvío de ruta',
        IncidentType.clima => 'Clima',
        IncidentType.otro => 'Otro',
      };
}

enum IncidentSeverity {
  bajo,
  medio,
  alto,
  critico;

  String get label => switch (this) {
        IncidentSeverity.bajo => 'Bajo',
        IncidentSeverity.medio => 'Medio',
        IncidentSeverity.alto => 'Alto',
        IncidentSeverity.critico => 'Crítico',
      };
}

enum IncidentStatus {
  reportada,
  enRevision,
  resuelta;

  String get label => switch (this) {
        IncidentStatus.reportada => 'Reportada',
        IncidentStatus.enRevision => 'En revisión',
        IncidentStatus.resuelta => 'Resuelta',
      };
}

/// Escenarios de demostración para la consulta de ETA (sección 9.1 del
/// requerimiento). Centraliza los nombres usados por el selector visible.
enum EtaDemoScenario {
  dosBusesMismoSentido,
  dosBusesSentidoOpuesto,
  tresBusesActivos,
  busGpsDesactualizado,
  busDetenidoEnParada,
  busFueraDeRuta,
  ningunBusDisponible,
  busSinServicio;

  String get label => switch (this) {
        EtaDemoScenario.dosBusesMismoSentido =>
          'A · Dos buses, mismo sentido (FCV)',
        EtaDemoScenario.dosBusesSentidoOpuesto =>
          'B · Dos buses, sentidos opuestos (BIB)',
        EtaDemoScenario.tresBusesActivos => 'C · Tres buses activos',
        EtaDemoScenario.busGpsDesactualizado => 'D · Bus con GPS desactualizado',
        EtaDemoScenario.busDetenidoEnParada => 'E · Bus detenido en parada',
        EtaDemoScenario.busFueraDeRuta => 'F · Bus fuera de ruta',
        EtaDemoScenario.ningunBusDisponible => 'G · Ningún bus disponible',
        EtaDemoScenario.busSinServicio => 'H · Bus sin servicio',
      };
}
