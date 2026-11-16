import 'package:flutter/material.dart';
import 'package:next_bus/core/enums/enums.dart';

/// Paleta "Industry": acero/azul grisáceo como único acento sobre un fondo
/// claro, verde/ámbar/rojo reservados a semántica de estado (nunca
/// decorativos). Cada rampa (neutral/accent) usa 9 pasos de igual peso
/// perceptual, tomados del design system importado (`styles.css`).
class AppColors {
  AppColors._();

  static const Color bg = Color(0xFFF2F2F3);
  static const Color surface = Color(0xFFE9E9EA);
  static const Color text = Color(0xFF1D1F20);
  static const Color accent = Color(0xFF5980A6);
  static const Color divider = Color(0x291D1F20); // text @ 16%

  static const Color neutral100 = Color(0xFFF5F5F8);
  static const Color neutral200 = Color(0xFFE7E7EA);
  static const Color neutral300 = Color(0xFFD4D4D7);
  static const Color neutral400 = Color(0xFFB7B7BA);
  static const Color neutral500 = Color(0xFF98989B);
  static const Color neutral600 = Color(0xFF7A7A7D);
  static const Color neutral700 = Color(0xFF5D5D60);
  static const Color neutral800 = Color(0xFF424244);
  static const Color neutral900 = Color(0xFF2B2B2D);

  static const Color accent100 = Color(0xFFEEF6FF);
  static const Color accent200 = Color(0xFFD6EBFF);
  static const Color accent300 = Color(0xFFB5D9FD);
  static const Color accent400 = Color(0xFF94BCE3);
  static const Color accent500 = Color(0xFF749DC4);
  static const Color accent600 = Color(0xFF597EA3);
  static const Color accent700 = Color(0xFF416180);
  static const Color accent800 = Color(0xFF2C455D);
  static const Color accent900 = Color(0xFF1D2D3D);

  // Legacy aliases kept so existing call sites (title/background/etc. in
  // widgets not yet migrated) keep compiling while screens are restyled.
  static const Color navy = accent900;
  static const Color navyLight = accent700;
  static const Color background = bg;
  static const Color border = neutral300;
  static const Color textPrimary = text;
  static const Color textSecondary = neutral700;

  static const Color green = Color(0xFF1E8E5A);
  static const Color greenBg = Color(0xFFE4F5EC);
  static const Color orange = Color(0xFFC77700);
  static const Color orangeBg = Color(0xFFFCEFDB);
  static const Color red = Color(0xFFC0392B);
  static const Color redBg = Color(0xFFFBE6E3);
  static const Color grey = neutral600;
  static const Color greyBg = neutral100;

  static Color forBusStatus(BusStatus status) => switch (status) {
        BusStatus.enRuta => green,
        BusStatus.enParada => accent800,
        BusStatus.disponible => green,
        BusStatus.sinServicio => grey,
        BusStatus.gpsDesactualizado => orange,
        BusStatus.fueraDeRuta => red,
      };

  static Color bgForBusStatus(BusStatus status) => switch (status) {
        BusStatus.enRuta => greenBg,
        BusStatus.enParada => accent100,
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
        IncidentStatus.enRevision => accent800,
        IncidentStatus.resuelta => green,
      };

  static Color bgForIncidentStatus(IncidentStatus status) => switch (status) {
        IncidentStatus.reportada => orangeBg,
        IncidentStatus.enRevision => accent100,
        IncidentStatus.resuelta => greenBg,
      };

  static Color forConfidence(EtaConfidence confidence) => switch (confidence) {
        EtaConfidence.alta => green,
        EtaConfidence.media => orange,
        EtaConfidence.baja => red,
      };

  /// Verde→ámbar→rojo según qué tan cerca está un nivel (0.0–1.0+) de su
  /// límite — usado por las barras de combustible (C1/C2/C7) y de ocupación
  /// (S2/S5/C2). >=1.0 significa "en el límite o excedido".
  static Color forUsageLevel(double pct) {
    if (pct >= 1) return red;
    if (pct >= 0.7) return orange;
    return green;
  }

  static Color bgForUsageLevel(double pct) {
    if (pct >= 1) return redBg;
    if (pct >= 0.7) return orangeBg;
    return greenBg;
  }
}
