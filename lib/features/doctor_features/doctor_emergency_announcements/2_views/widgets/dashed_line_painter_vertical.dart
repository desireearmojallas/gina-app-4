import 'package:flutter/material.dart';

class DashedLinePainterVertical extends CustomPainter {
  final double dashHeight;
  final double dashSpace;
  final Color color;

  DashedLinePainterVertical({
    this.dashHeight = 5.0,
    this.dashSpace = 3.0,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
