import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class PendingRequestsNavigationWidget extends StatelessWidget {
  const PendingRequestsNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Pending Requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                color: GinaAppTheme.lightTertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '14',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // TODO: UPCOMING APPOINTMENTS ROUTE
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  'See all',
                  style: ginaTheme.textTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.lightTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(10),
        Container(
          height: size.height * 0.26,
          width: size.width / 1.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: GinaAppTheme.lightOnTertiary,
            boxShadow: [
              GinaAppTheme.defaultBoxShadow,
            ],
          ),
          child: const Column(
            children: [],
          ),
        ),
      ],
    );
  }
}
