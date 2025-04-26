import 'package:flutter/material.dart';

class NotchedRoundedRectangle extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double notchRadius;
  final double notchOffsetY;
  final Widget child;

  const NotchedRoundedRectangle({
    super.key,
    required this.width,
    required this.height,
    this.color = Colors.grey,
    this.notchRadius = 10,
    this.notchOffsetY = 0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _SideCircularNotchedRectanglePainter(
        color: color,
        notchRadius: notchRadius,
        notchOffsetY: notchOffsetY,
      ),
      child: child,
    );
  }
}

class _SideCircularNotchedRectanglePainter extends CustomPainter {
  final Color color;
  final double notchRadius;
  final double notchOffsetY;

  _SideCircularNotchedRectanglePainter({
    required this.color,
    required this.notchRadius,
    required this.notchOffsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double notchCenterY = size.height / 2 + notchOffsetY;

    final path = Path()
      ..moveTo(20, 0) // Top-left rounded corner
      ..lineTo(size.width - 20, 0)
      ..arcToPoint(Offset(size.width, 20), radius: const Radius.circular(20))
      ..lineTo(size.width, notchCenterY - notchRadius) // Right side above notch
      ..arcToPoint(Offset(size.width, notchCenterY + notchRadius),
          radius: Radius.circular(notchRadius),
          clockwise: false) // Right circular notch
      ..lineTo(size.width, size.height - 20)
      ..arcToPoint(Offset(size.width - 20, size.height),
          radius: const Radius.circular(20))
      ..lineTo(20, size.height)
      ..arcToPoint(Offset(0, size.height - 20),
          radius: const Radius.circular(20))
      ..lineTo(0, notchCenterY + notchRadius) // Left side above notch
      ..arcToPoint(Offset(0, notchCenterY - notchRadius),
          radius: Radius.circular(notchRadius),
          clockwise: false) // Left circular notch
      ..lineTo(0, 20)
      ..arcToPoint(const Offset(20, 0), radius: const Radius.circular(20));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
