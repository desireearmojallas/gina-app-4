import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/waves_widget.dart';

class ProfileScreenLoadingSkeleton extends StatelessWidget {
  const ProfileScreenLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final List<Color> gradientColors = [
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade100,
    ];

    final effect = ShimmerEffect(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade50,
      duration: const Duration(seconds: 1),
    );

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: height * 0.87,
                width: width * 0.94,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    GinaAppTheme.defaultBoxShadow,
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Skeletonizer(
                              effect: effect,
                              enabled: true,
                              child: ClipOval(
                                child: Container(
                                  width: width * 0.4,
                                  height: width * 0.4,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            Gap(height * 0.025),
                            Skeletonizer(
                              effect: effect,
                              enabled: true,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: width * 0.375,
                                      height: height * 0.025,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  const Gap(5),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: width * 0.5,
                                      height: height * 0.02,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(height * 0.025),
                            Skeletonizer(
                              effect: effect,
                              enabled: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: width * 0.35,
                                  height: height * 0.045,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            Gap(height * 0.06),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Skeletonizer(
                                  effect: effect,
                                  enabled: true,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: width * 0.25,
                                          height: height * 0.02,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      const Gap(5),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: width * 0.375,
                                          height: height * 0.025,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Skeletonizer(
                                  effect: effect,
                                  enabled: true,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: width * 0.25,
                                          height: height * 0.02,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      const Gap(5),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: width * 0.375,
                                          height: height * 0.025,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(height * 0.01),
                            const Divider(thickness: 0.2, height: 2),
                            Gap(height * 0.03),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Skeletonizer(
                                effect: effect,
                                enabled: true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: width * 0.25,
                                        height: height * 0.02,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    const Gap(5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: width * 0.5,
                                        height: height * 0.025,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gap(height * 0.01),
                            const Divider(thickness: 0.2, height: 2),
                            Gap(height * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Skeletonizer(
                                  effect: effect,
                                  enabled: true,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: width * 0.41,
                                      height: height * 0.12,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                Skeletonizer(
                                  effect: effect,
                                  enabled: true,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: width * 0.41,
                                      height: height * 0.12,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    WavesWidget(
                      gradientColors: gradientColors,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
