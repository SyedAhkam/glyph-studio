import 'package:flutter/material.dart';

class DiamondArrowPainter extends CustomPainter {
  Color color;

  DiamondArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final Paint paint = Paint();

    paint.color = color;
    path.moveTo(size.width * 0.01, size.height * 0.5);
    path.lineTo(size.width * 0.19, size.height * 0.88);
    path.lineTo(size.width * 0.37, size.height * 0.5);
    path.lineTo(size.width * 0.19, size.height * 0.12);
    path.lineTo(size.width * 0.01, size.height * 0.5);
    path.lineTo(size.width * 0.01, size.height * 0.5);
    path.moveTo(size.width * 0.98, size.height * 0.55);
    path.cubicTo(size.width, size.height * 0.52, size.width, size.height * 0.48,
        size.width * 0.98, size.height * 0.45);
    path.lineTo(size.width * 0.78, size.height * 0.03);
    path.cubicTo(size.width * 0.77, size.height * -0.01, size.width * 0.74,
        size.height * 0.01, size.width * 0.73, size.height * 0.06);
    path.cubicTo(size.width * 0.73, size.height * 0.08, size.width * 0.73,
        size.height * 0.11, size.width * 0.74, size.height * 0.12);
    path.lineTo(size.width * 0.92, size.height * 0.5);
    path.lineTo(size.width * 0.74, size.height * 0.88);
    path.cubicTo(size.width * 0.72, size.height * 0.91, size.width * 0.73,
        size.height * 0.98, size.width * 0.75, size.height * 0.99);
    path.cubicTo(size.width * 0.76, size.height, size.width * 0.78,
        size.height * 0.99, size.width * 0.78, size.height * 0.97);
    path.lineTo(size.width * 0.98, size.height * 0.55);
    path.lineTo(size.width * 0.98, size.height * 0.55);
    path.moveTo(size.width * 0.19, size.height * 0.57);
    path.lineTo(size.width * 0.96, size.height * 0.57);
    path.lineTo(size.width * 0.96, size.height * 0.43);
    path.lineTo(size.width * 0.19, size.height * 0.43);
    path.lineTo(size.width * 0.19, size.height * 0.57);
    path.lineTo(size.width * 0.19, size.height * 0.57);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
