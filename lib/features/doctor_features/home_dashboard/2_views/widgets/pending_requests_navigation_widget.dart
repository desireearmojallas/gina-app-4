import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';

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
            Text(
              'Pending Requests'.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
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
        GestureDetector(
          onTap: () {},
          child: Container(
            height: size.height * 0.11,
            width: size.width / 1.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GinaAppTheme.lightOnTertiary,
              boxShadow: [
                GinaAppTheme.defaultBoxShadow,
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CircleAvatar(
                    radius: 37,
                    backgroundImage: AssetImage(
                      Images.patientProfileIcon,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Desiree Armojallas',
                      style: ginaTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(5),
                    Text(
                      'Online Consultation',
                      style: ginaTheme.textTheme.labelMedium?.copyWith(
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      'Tuesday, December 19\n8:00 AM - 9:00 AM',
                      style: ginaTheme.textTheme.labelMedium?.copyWith(
                        color: GinaAppTheme.lightOutline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          MingCute.close_circle_fill,
                          color: Colors.grey[300],
                          size: 38,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          MingCute.check_circle_fill,
                          color: GinaAppTheme.lightTertiaryContainer,
                          size: 38,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
