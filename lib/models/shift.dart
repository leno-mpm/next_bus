/// Turno de un conductor (C1 lo abre, C5 lo cierra). Distinto de `Trip`:
/// un turno puede abarcar varias vueltas/recorridos.
class Shift {
  final String id;
  final String driverId;
  final String busId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int lapsCompleted;
  final String? unitConditionAtClose;

  const Shift({
    required this.id,
    required this.driverId,
    required this.busId,
    required this.startedAt,
    this.endedAt,
    this.lapsCompleted = 0,
    this.unitConditionAtClose,
  });

  bool get isOpen => endedAt == null;

  Shift copyWith({
    DateTime? endedAt,
    int? lapsCompleted,
    String? unitConditionAtClose,
  }) {
    return Shift(
      id: id,
      driverId: driverId,
      busId: busId,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      lapsCompleted: lapsCompleted ?? this.lapsCompleted,
      unitConditionAtClose: unitConditionAtClose ?? this.unitConditionAtClose,
    );
  }
}
