import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final List<Color>? colors;
  const CustomLoadingIndicator({
    super.key,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: LoadingIndicator(
        indicatorType: Indicator.ballScale,
        colors: colors ??
            [
              GinaAppTheme.lightTertiaryContainer,
              GinaAppTheme.lightTertiary,
              GinaAppTheme.lightSecondary,
              GinaAppTheme.lightPrimaryColor,
            ],
        strokeWidth: 1,
        pause: false,
      ),
    );
  }
}
