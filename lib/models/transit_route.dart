import 'package:next_bus/core/enums/enums.dart';

/// Ruta de transporte interno. Cada sentido (SALIDA/ENTRADA) de una misma
/// ruta física es una instancia independiente de [TransitRoute], con su
/// propia secuencia de `stopIds` — nunca se asume que un sentido es el
/// reverso del otro (sección 7.2 del requerimiento).
///
/// Nombrado `TransitRoute` (no `Route`) para no chocar con `Route` de
/// `package:flutter/widgets.dart`.
class TransitRoute {
  final String id;
  final String groupId;
  final String name;
  final String description;
  final Direction direction;
  final List<String> stopIds;
  final RouteStatus status;

  const TransitRoute({
    required this.id,
    required this.groupId,
    required this.name,
    required this.description,
    required this.direction,
    required this.stopIds,
    this.status = RouteStatus.activa,
  });

  int get stopCount => stopIds.length;
}
