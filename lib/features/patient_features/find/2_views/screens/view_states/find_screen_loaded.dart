import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/widgets/doctors_in_the_nearest_city_list.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/widgets/doctors_near_me_lists.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/widgets/find_doctors_search_bar.dart';
import 'package:icons_plus/icons_plus.dart';

class FindScreenLoaded extends StatelessWidget {
  const FindScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 70.0), // Adjust this value as needed
            child: RefreshIndicator(
              onRefresh: () async {},
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Gap(10),
                        const Icon(
                          MingCute.location_fill,
                          size: 20,
                          color: GinaAppTheme.lightOnPrimaryColor,
                        ),
                        const Gap(10),
                        Text(
                          'Near me',
                          style: ginaTheme.textTheme.bodyMedium?.copyWith(
                            color: GinaAppTheme.lightOnPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      children: List.generate(2, (index) {
                        return const Column(
                          children: [
                            DoctorsNearMe(),
                            Gap(10),
                          ],
                        );
                      }),
                    ),

                    //--- Cebu City ---
                    const Gap(15),
                    const Divider(
                      color: GinaAppTheme.lightSurfaceVariant,
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        const Gap(10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Cebu City',
                            style: ginaTheme.textTheme.bodyMedium?.copyWith(
                              color: GinaAppTheme.lightOnPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      children: List.generate(3, (index) {
                        return const Column(
                          children: [
                            DoctorsInTheNearestCity(),
                            Gap(10),
                          ],
                        );
                      }),
                    ),

                    //--- Lapu-Lapu City ---
                    const Gap(15),
                    const Divider(
                      color: GinaAppTheme.lightSurfaceVariant,
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        const Gap(10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Lapu-Lapu City',
                            style: ginaTheme.textTheme.bodyMedium?.copyWith(
                              color: GinaAppTheme.lightOnPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      children: List.generate(5, (index) {
                        return const Column(
                          children: [
                            DoctorsInTheNearestCity(),
                            Gap(10),
                          ],
                        );
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FindDoctorsSearchBar(),
          ),
        ],
      ),
    );
  }
}
