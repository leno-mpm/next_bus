import 'package:next_bus/core/enums/enums.dart';

/// Estimación de llegada de un bus a una parada. Todos los valores son
/// simulados (sección 9 del requerimiento) — no provienen de un motor de
/// predicción real.
class BusEta {
  final String busId;
  final String stopId;
  final int etaMinutes;
  final int etaLowerMinutes;
  final int etaUpperMinutes;
  final EtaConfidence confidence;
  final DateTime lastUpdated;
  final GpsStatus gpsStatus;

  const BusEta({
    required this.busId,
    required this.stopId,
    required this.etaMinutes,
    required this.etaLowerMinutes,
    required this.etaUpperMinutes,
    required this.confidence,
    required this.lastUpdated,
    required this.gpsStatus,
  });

  BusEta copyWith({
    int? etaMinutes,
    int? etaLowerMinutes,
    int? etaUpperMinutes,
    DateTime? lastUpdated,
  }) {
    return BusEta(
      busId: busId,
      stopId: stopId,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      etaLowerMinutes: etaLowerMinutes ?? this.etaLowerMinutes,
      etaUpperMinutes: etaUpperMinutes ?? this.etaUpperMinutes,
      confidence: confidence,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      gpsStatus: gpsStatus,
    );
  }
}
