import 'package:flutter/material.dart';
import 'package:next_bus/core/enums/enums.dart';

/// Paleta centralizada. Azul marino como color principal, verde/naranja/rojo
/// reservados a semántica de estado (nunca decorativos).
class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF0D2748);
  static const Color navyLight = Color(0xFF14365F);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE1E6ED);
  static const Color textPrimary = Color(0xFF17202A);
  static const Color textSecondary = Color(0xFF5B6B7C);

  static const Color green = Color(0xFF1E8E5A);
  static const Color greenBg = Color(0xFFE4F5EC);
  static const Color orange = Color(0xFFC77700);
  static const Color orangeBg = Color(0xFFFCEFDB);
  static const Color red = Color(0xFFC0392B);
  static const Color redBg = Color(0xFFFBE6E3);
  static const Color grey = Color(0xFF6B7684);
  static const Color greyBg = Color(0xFFE9EBEE);

  static Color forBusStatus(BusStatus status) => switch (status) {
        BusStatus.enRuta => green,
        BusStatus.enParada => navy,
        BusStatus.disponible => green,
        BusStatus.sinServicio => grey,
        BusStatus.gpsDesactualizado => orange,
        BusStatus.fueraDeRuta => red,
      };

  static Color bgForBusStatus(BusStatus status) => switch (status) {
        BusStatus.enRuta => greenBg,
        BusStatus.enParada => const Color(0xFFE3EAF2),
        BusStatus.disponible => greenBg,
        BusStatus.sinServicio => greyBg,
        BusStatus.gpsDesactualizado => orangeBg,
        BusStatus.fueraDeRuta => redBg,
      };

  static Color forSeverity(IncidentSeverity severity) => switch (severity) {
        IncidentSeverity.bajo => green,
        IncidentSeverity.medio => orange,
        IncidentSeverity.alto => red,
        IncidentSeverity.critico => red,
      };

  static Color bgForSeverity(IncidentSeverity severity) => switch (severity) {
        IncidentSeverity.bajo => greenBg,
        IncidentSeverity.medio => orangeBg,
        IncidentSeverity.alto => redBg,
        IncidentSeverity.critico => redBg,
      };

  static Color forIncidentStatus(IncidentStatus status) => switch (status) {
        IncidentStatus.reportada => orange,
        IncidentStatus.enRevision => navy,
        IncidentStatus.resuelta => green,
      };

  static Color bgForIncidentStatus(IncidentStatus status) => switch (status) {
        IncidentStatus.reportada => orangeBg,
        IncidentStatus.enRevision => const Color(0xFFE3EAF2),
        IncidentStatus.resuelta => greenBg,
      };

  static Color forConfidence(EtaConfidence confidence) => switch (confidence) {
        EtaConfidence.alta => green,
        EtaConfidence.media => orange,
        EtaConfidence.baja => red,
      };
}
