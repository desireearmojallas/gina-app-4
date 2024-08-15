import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RotatingSvg();
  }
}

class _RotatingSvg extends StatefulWidget {
  const _RotatingSvg();

  @override
  __RotatingSvgState createState() => __RotatingSvgState();
}

class __RotatingSvgState extends State<_RotatingSvg> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    )..repeat();  // Repeats the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.asset(
        'assets/images/gina_logo.svg',
        width: 35,
        height: 35,
        colorFilter: const ColorFilter.mode(
          GinaAppTheme.lightOnSelectedColorNavBar,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
