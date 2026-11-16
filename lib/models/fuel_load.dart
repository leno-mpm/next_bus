/// Carga de combustible registrada para una unidad (C7). Cada carga suma a
/// `Bus.fuelUsed` y descuenta del presupuesto mensual compartido.
class FuelLoad {
  final String id;
  final String busId;
  final double amount;
  final String registeredBy;
  final DateTime registeredAt;

  const FuelLoad({
    required this.id,
    required this.busId,
    required this.amount,
    required this.registeredBy,
    required this.registeredAt,
  });
}
