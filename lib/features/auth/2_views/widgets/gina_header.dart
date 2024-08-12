import 'package:flutter/material.dart';

class GinaHeader extends StatelessWidget {
  final double size;
  const GinaHeader({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'GINA',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF36344E),
        fontSize: size,
        fontFamily: 'Cormorant Upright',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
