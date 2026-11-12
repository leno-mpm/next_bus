/// Parada del catálogo real de la universidad (13 paradas, sección 4 del
/// requerimiento). `latitude`/`longitude` son nullable a propósito: los
/// valores recibidos para las 13 paradas llegaron corruptos (separador
/// decimal `,` combinado con notación científica `E+15`/`E+16`, fuera del
/// rango válido de latitud/longitud) y no fueron corregidos ni inventados.
/// Quedan en `null` hasta que se reciban coordenadas válidas.
class Stop {
  final String id;
  final String name;
  final double? latitude;
  final double? longitude;
  final String description;
  final bool active;

  const Stop({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    required this.description,
    this.active = true,
  });

  bool get hasValidCoordinates => latitude != null && longitude != null;
}
