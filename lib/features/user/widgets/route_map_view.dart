import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/stop.dart';

/// Posición de un bus a lo largo del recorrido, como fracción entre una
/// parada y la siguiente (0.0 = en `fromStopId`, 1.0 = en `toStopId`).
class MapBusPosition {
  final Bus bus;
  final String fromStopId;
  final String toStopId;
  final double progress;

  const MapBusPosition({
    required this.bus,
    required this.fromStopId,
    required this.toStopId,
    this.progress = 0.5,
  });
}

/// "Mapa" esquemático del recorrido (sección 9.4, extendido): en vez de
/// coordenadas geográficas reales (que no están disponibles — ver
/// `mock_stops.dart`), dispone las paradas en una trayectoria en zig-zag
/// cuya única entrada es el ORDEN de la ruta, igual que
/// `RouteSchematicView`, pero en dos dimensiones para leerse como un mapa.
class RouteMapView extends StatelessWidget {
  final List<Stop> orderedStops;
  final String? highlightStopId;
  final List<MapBusPosition> buses;
  final ValueChanged<String>? onStopTap;
  final ValueChanged<String>? onBusTap;

  const RouteMapView({
    super.key,
    required this.orderedStops,
    this.highlightStopId,
    this.buses = const [],
    this.onStopTap,
    this.onBusTap,
  });

  @override
  Widget build(BuildContext context) {
    if (orderedStops.isEmpty) return const SizedBox.shrink();
    return AspectRatio(
      aspectRatio: 358 / 232,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accent100,
          border: Border.all(color: AppColors.neutral300),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            final positions = _layout(orderedStops.length, size);
            final stopIndex = {
              for (var i = 0; i < orderedStops.length; i++)
                orderedStops[i].id: i,
            };

            return Stack(
              children: [
                CustomPaint(
                  size: size,
                  painter: _MapPainter(positions: positions),
                ),
                for (var i = 0; i < orderedStops.length; i++)
                  _stopMarker(orderedStops[i], positions[i]),
                for (final busPos in buses)
                  if (stopIndex.containsKey(busPos.fromStopId) &&
                      stopIndex.containsKey(busPos.toStopId))
                    _busMarker(
                      busPos,
                      Offset.lerp(
                        positions[stopIndex[busPos.fromStopId]!],
                        positions[stopIndex[busPos.toStopId]!],
                        busPos.progress,
                      )!,
                    ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _stopMarker(Stop stop, Offset pos) {
    final highlighted = stop.id == highlightStopId;
    return Positioned(
      left: pos.dx - 9,
      top: pos.dy - 9,
      child: GestureDetector(
        onTap: onStopTap == null ? null : () => onStopTap!(stop.id),
        child: Column(
          children: [
            Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: highlighted ? AppColors.accent900 : AppColors.bg,
                border: Border.all(
                  color: AppColors.accent800,
                  width: highlighted ? 2 : 1.5,
                ),
              ),
            ),
            Text(
              stop.id,
              style: AppTextStyles.caption.copyWith(
                fontSize: 9,
                fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _busMarker(MapBusPosition busPos, Offset pos) {
    return Positioned(
      left: pos.dx - 14,
      top: pos.dy - 10,
      child: GestureDetector(
        onTap: onBusTap == null ? null : () => onBusTap!(busPos.bus.id),
        child: Container(
          width: 28,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.forBusStatus(busPos.bus.status),
            border: Border.all(color: AppColors.bg, width: 1.5),
          ),
          child: Text(
            busPos.bus.name.replaceAll(RegExp(r'[^0-9]'), ''),
            style: AppTextStyles.badge.copyWith(color: AppColors.bg, fontSize: 10),
          ),
        ),
      ),
    );
  }

  /// Distribuye `count` paradas en una trayectoria en zig-zag de 3 filas,
  /// de izquierda a derecha y luego de derecha a izquierda, para que el
  /// recorrido se lea como un mapa y no como una lista horizontal.
  List<Offset> _layout(int count, Size size) {
    const margin = 24.0;
    const rows = 3;
    final perRow = (count / rows).ceil();
    final usableW = size.width - margin * 2;
    final usableH = size.height - margin * 2;
    final positions = <Offset>[];
    for (var i = 0; i < count; i++) {
      final row = i ~/ perRow;
      final indexInRow = i % perRow;
      final countInRow =
          (row == rows - 1) ? count - perRow * (rows - 1) : perRow;
      final reversed = row.isOdd;
      final t = countInRow <= 1
          ? 0.0
          : indexInRow / (countInRow - 1) * (reversed ? -1 : 1) +
              (reversed ? 1 : 0);
      final x = margin + usableW * t;
      final y = margin + usableH * (rows <= 1 ? 0 : row / (rows - 1));
      positions.add(Offset(x, y));
    }
    return positions;
  }
}

class _MapPainter extends CustomPainter {
  final List<Offset> positions;
  const _MapPainter({required this.positions});

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.16)
      ..strokeWidth = 0.6;
    for (double x = 0; x < size.width; x += 18) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 18) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    if (positions.length > 1) {
      final outline = Paint()
        ..color = AppColors.accent200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final line = Paint()
        ..color = AppColors.accent700
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round;
      final path = Path()..moveTo(positions.first.dx, positions.first.dy);
      for (final p in positions.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, outline);
      canvas.drawPath(path, line);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) =>
      oldDelegate.positions != positions;
}
