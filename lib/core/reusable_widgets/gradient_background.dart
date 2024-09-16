import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/waves_widget.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: height * 0.2,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: GinaAppTheme.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.2,
                      child: Container(
                        height: height * 0.6,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: GinaAppTheme.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    GinaAppTheme.blurFilter,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
