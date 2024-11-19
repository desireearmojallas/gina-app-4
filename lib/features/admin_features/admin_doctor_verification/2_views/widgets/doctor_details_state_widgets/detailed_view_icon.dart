import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DetailedViewIcon extends StatelessWidget {
  final Icon icon;
  const DetailedViewIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: GinaAppTheme.lightOutline,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
