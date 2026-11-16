class Driver {
  final String id;
  final String name;
  final String licenseId;
  final String assignedBusId;
  final String assignedRouteId;

  /// Código de empleado mostrado en el perfil (C6), p. ej. "CND-0412".
  final String employeeCode;

  /// Tipo de licencia de conducir, p. ej. "Tipo C".
  final String licenseType;

  /// Vencimiento de la licencia de conducir.
  final DateTime licenseExpiry;

  /// Horario de turno para mostrar en el perfil (C6), ya formateado.
  final String shiftHoursLabel;

  const Driver({
    required this.id,
    required this.name,
    required this.licenseId,
    required this.assignedBusId,
    required this.assignedRouteId,
    this.employeeCode = '',
    this.licenseType = '',
    required this.licenseExpiry,
    this.shiftHoursLabel = '',
  });
}
