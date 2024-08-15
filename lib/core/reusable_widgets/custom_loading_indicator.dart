import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SeamlessRotatingLoader();
  }
}

class _SeamlessRotatingLoader extends StatefulWidget {
  const _SeamlessRotatingLoader();

  @override
  __SeamlessRotatingLoaderState createState() => __SeamlessRotatingLoaderState();
}

class __SeamlessRotatingLoaderState extends State<_SeamlessRotatingLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: RotationTransition(
        turns: _controller.drive(CurveTween(curve: Curves.linear)), // Continuous rotation
        child: SvgPicture.asset(
          'assets/images/gina_logo.svg',
          width: 35,
          height: 35,
          colorFilter: const ColorFilter.mode(
            GinaAppTheme.lightOnSelectedColorNavBar,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
