import 'package:flutter/material.dart';

class ScrollbarCustom extends StatelessWidget {
  final ScrollController? scrollController;
  final bool thumbVisibility;
  final Radius radius;
  final bool interactive;
  final double thickness;
  final Widget child;

  const ScrollbarCustom({
    super.key,
    this.scrollController,
    this.thumbVisibility = false,
    this.radius = const Radius.circular(20),
    this.interactive = true,
    this.thickness = 5,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: thumbVisibility,
      controller: scrollController,
      radius: radius,
      interactive: interactive,
      thickness: thickness,
      child: child,
    );
  }
}