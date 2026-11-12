import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/models/bus.dart';
import 'package:next_bus/models/stop.dart';

/// Representación esquemática del recorrido (sección 9.4): paradas en
/// orden, conexión entre ellas, posición simulada de cada bus y sentido.
/// No depende de coordenadas geográficas, que todavía no están validadas.
class RouteSchematicView extends StatelessWidget {
  final List<Stop> orderedStops;
  final String highlightStopId;
  final List<Bus> buses;
  final Direction? direction;

  const RouteSchematicView({
    super.key,
    required this.orderedStops,
    required this.highlightStopId,
    required this.buses,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    if (orderedStops.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.route_rounded,
                size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              direction == null
                  ? 'Esquema del recorrido'
                  : 'Esquema del recorrido · Sentido ${direction!.label}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildSegments(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSegments() {
    final widgets = <Widget>[];
    for (var i = 0; i < orderedStops.length; i++) {
      final stop = orderedStops[i];
      widgets.add(_StopDot(
        stop: stop,
        isHighlighted: stop.id == highlightStopId,
      ));
      if (i < orderedStops.length - 1) {
        final next = orderedStops[i + 1];
        final busesHere = buses.where((bus) {
          return bus.currentSegmentFromStopId == stop.id &&
              bus.currentSegmentToStopId == next.id;
        }).toList();
        widgets.add(_Connector(buses: busesHere));
      }
    }
    return widgets;
  }
}

class _StopDot extends StatelessWidget {
  final Stop stop;
  final bool isHighlighted;

  const _StopDot({required this.stop, required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isHighlighted ? AppColors.navy : AppColors.surface,
              border: Border.all(
                color: isHighlighted ? AppColors.navy : AppColors.border,
                width: 2,
              ),
            ),
            child: isHighlighted
                ? const Icon(Icons.location_pin, size: 10, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            stop.id,
            textAlign: TextAlign.center,
            style: isHighlighted
                ? AppTextStyles.caption.copyWith(
                    color: AppColors.navy, fontWeight: FontWeight.w800)
                : AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  final List<Bus> buses;

  const _Connector({required this.buses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Column(
        children: [
          const SizedBox(height: 7),
          SizedBox(
            height: 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 2, color: AppColors.border),
                if (buses.isNotEmpty)
                  Icon(
                    Icons.directions_bus_rounded,
                    size: 16,
                    color: AppColors.forBusStatus(buses.first.status),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
