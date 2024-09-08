import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WavesWidget extends StatelessWidget {
  final List<Color> gradientColors;
  const WavesWidget({super.key, required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: WaveWidget(
              config: CustomConfig(
                colors: gradientColors.map((color) {
                  return color.withOpacity(1);
                }).toList(),
                durations: [20000, 18000, 16000],
                heightPercentages: [0.20, 0.30, 0.40],
              ),
              backgroundColor: Colors.transparent,
              size: Size(constraints.maxWidth, 190),
              waveAmplitude: 10,
            ),
          );
        },
      ),
    );
  }
}
