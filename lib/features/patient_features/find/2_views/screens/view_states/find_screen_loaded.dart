import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/widgets/find_doctors_search_bar.dart';
import 'package:icons_plus/icons_plus.dart';

class FindScreenLoaded extends StatelessWidget {
  const FindScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const FindDoctorsSearchBar(),
            const Gap(25),
            Row(
              children: [
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
            const Gap(5),
          ],
        ),
      ),
    );
  }
}
