import 'package:next_bus/models/shift.dart';

abstract class ShiftRepository {
  /// Turno abierto más reciente de un conductor, si existe.
  Future<Shift?> getCurrentShift(String driverId);

  Future<Shift> startShift(String driverId, String busId);

  /// Incrementa el contador de vueltas completadas del turno abierto.
  Future<void> completeLap(String shiftId);

  Future<void> endShift(String shiftId, String unitCondition);
}

/// Turnos en memoria durante la sesión (C1 abre, C5 cierra). No hay
/// persistencia real, igual que el resto de repositorios mock.
class MockShiftRepository implements ShiftRepository {
  final List<Shift> _shifts = [];

  @override
  Future<Shift?> getCurrentShift(String driverId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    for (final shift in _shifts.reversed) {
      if (shift.driverId == driverId && shift.isOpen) return shift;
    }
    return null;
  }

  @override
  Future<Shift> startShift(String driverId, String busId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final shift = Shift(
      id: 'SHF${_shifts.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      driverId: driverId,
      busId: busId,
      startedAt: DateTime.now(),
    );
    _shifts.add(shift);
    return shift;
  }

  @override
  Future<void> completeLap(String shiftId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final index = _shifts.indexWhere((shift) => shift.id == shiftId);
    if (index != -1) {
      final current = _shifts[index];
      _shifts[index] =
          current.copyWith(lapsCompleted: current.lapsCompleted + 1);
    }
  }

  @override
  Future<void> endShift(String shiftId, String unitCondition) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final index = _shifts.indexWhere((shift) => shift.id == shiftId);
    if (index != -1) {
      _shifts[index] = _shifts[index].copyWith(
        endedAt: DateTime.now(),
        unitConditionAtClose: unitCondition,
      );
    }
  }
}
