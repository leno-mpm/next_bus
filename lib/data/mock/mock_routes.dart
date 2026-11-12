import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/models/transit_route.dart';

/// Rutas y secuencias de paradas — DATOS PROVISIONALES de demostración.
///
/// Las secuencias usan los `stop_id` reales del catálogo (sección 4), pero
/// el ORDEN todavía no ha sido proporcionado oficialmente. Cada sentido se
/// define de forma independiente (no se invierte SALIDA para obtener
/// ENTRADA), tal como exige el requerimiento, porque el recorrido físico
/// real puede diferir entre sentidos. Reemplazar con el recorrido oficial
/// cuando esté disponible.
final List<TransitRoute> mockRoutes = [
  const TransitRoute(
    id: 'R1-SALIDA',
    groupId: 'R1',
    name: 'Circuito Universitario',
    description:
        'Recorrido principal que conecta la garita de entrada con las '
        'facultades y servicios del campus. (Secuencia provisional)',
    direction: Direction.salida,
    stopIds: [
      'GARE', 'FCV', 'BIB', 'FCSH', 'FIEC', 'EBUS', 'FAD', 'GYM', 'CELEX',
      'CEP', 'PSC', 'CTI', 'GARS',
    ],
    status: RouteStatus.activa,
  ),
  const TransitRoute(
    id: 'R1-ENTRADA',
    groupId: 'R1',
    name: 'Circuito Universitario',
    description:
        'Recorrido de retorno hacia la garita de salida. El orden de '
        'paradas es independiente del sentido SALIDA. (Secuencia provisional)',
    direction: Direction.entrada,
    stopIds: [
      'GARS', 'GYM', 'FAD', 'EBUS', 'CELEX', 'CTI', 'PSC', 'CEP', 'FIEC',
      'FCSH', 'BIB', 'FCV', 'GARE',
    ],
    status: RouteStatus.activa,
  ),
  const TransitRoute(
    id: 'R2-SALIDA',
    groupId: 'R2',
    name: 'Ruta Corta Biblioteca',
    description:
        'Recorrido abreviado centrado en biblioteca y facultades cercanas. '
        '(Secuencia provisional)',
    direction: Direction.salida,
    stopIds: ['GARE', 'FCV', 'BIB', 'CELEX', 'EBUS'],
    status: RouteStatus.activa,
  ),
  const TransitRoute(
    id: 'R2-ENTRADA',
    groupId: 'R2',
    name: 'Ruta Corta Biblioteca',
    description:
        'Retorno abreviado hacia la garita de entrada. (Secuencia provisional)',
    direction: Direction.entrada,
    stopIds: ['EBUS', 'BIB', 'FCV', 'GARE'],
    status: RouteStatus.activa,
  ),
];
