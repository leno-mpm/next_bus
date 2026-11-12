/// Formateo de fecha/hora sin depender del paquete `intl`, para no agregar
/// una dependencia solo por esto.
class DateTimeUtils {
  DateTimeUtils._();

  static const _months = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
  ];

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String time(DateTime dt) => '${_two(dt.hour)}:${_two(dt.minute)}';

  static String dateShort(DateTime dt) =>
      '${_two(dt.day)} ${_months[dt.month - 1]}';

  static String dateTime(DateTime dt) =>
      '${dateShort(dt)}, ${time(dt)}';

  /// Texto relativo simple ("hace X s / X min") usado para "última actualización".
  static String relativeToNow(DateTime dt, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final diff = reference.difference(dt);
    if (diff.inSeconds < 5) return 'justo ahora';
    if (diff.inSeconds < 60) return 'hace ${diff.inSeconds} s';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    return 'hace ${diff.inHours} h';
  }
}
