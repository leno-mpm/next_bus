import 'package:flutter/material.dart';
import 'package:next_bus/app/theme/app_colors.dart';

/// Marco "blueprint" del design system Industry: borde de 1px, esquinas
/// cuadradas y marcas de registro en forma de "+" en cada esquina. Se usa en
/// lugar de un `Card` con sombra/radio para toda superficie tipo tarjeta.
class BlueprintFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? fill;
  final bool showCorners;

  const BlueprintFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.fill,
    this.showCorners = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.neutral300;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fill,
            border: Border.all(color: border, width: 1),
          ),
          child: child,
        ),
        if (showCorners) ..._corners(border),
      ],
    );
  }

  List<Widget> _corners(Color color) => [
        Positioned(top: -6, left: -6, child: _CornerMark(color: color)),
        Positioned(top: -6, right: -6, child: _CornerMark(color: color)),
        Positioned(bottom: -6, left: -6, child: _CornerMark(color: color)),
        Positioned(bottom: -6, right: -6, child: _CornerMark(color: color)),
      ];
}

class _CornerMark extends StatelessWidget {
  final Color color;
  const _CornerMark({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 11,
      height: 11,
      child: CustomPaint(painter: _CornerPainter(color)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(5, 0), Offset(5, size.height), paint);
    canvas.drawLine(Offset(0, 5), Offset(size.width, 5), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) =>
      oldDelegate.color != color;
}
