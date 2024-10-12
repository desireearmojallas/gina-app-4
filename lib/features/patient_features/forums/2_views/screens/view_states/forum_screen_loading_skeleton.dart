import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class ForumScreenLoadingSkeleton extends StatelessWidget {
  const ForumScreenLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final effect = ShimmerEffect(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade50,
      duration: const Duration(seconds: 1),
    );

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Skeletonizer(
                    effect: effect,
                    enabled: true,
                    child: Container(
                      width: width * 0.94,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          GinaAppTheme.defaultBoxShadow,
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Skeletonizer(
                                  effect: effect,
                                  enabled: true,
                                  child: CircleAvatar(
                                    radius: width * 0.05,
                                    backgroundColor: Colors.grey.shade100,
                                  ),
                                ),
                                Gap(width * 0.025),
                                Skeletonizer(
                                  effect: effect,
                                  enabled: true,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: width * 0.25,
                                      height: height * 0.02,
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(height * 0.01),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Skeletonizer(
                                effect: effect,
                                enabled: true,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: width * 0.8,
                                    height: height * 0.02,
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                            ),
                            Gap(height * 0.01),
                            Skeletonizer(
                              effect: effect,
                              enabled: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: width * 0.9,
                                  height: height * 0.08,
                                  color: Colors.grey.shade100,
                                ),
                              ),
                            ),
                            Gap(height * 0.01),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Skeletonizer(
                                effect: effect,
                                enabled: true,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: width * 0.2,
                                    height: height * 0.02,
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
