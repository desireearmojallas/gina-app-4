import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorsInTheNearestCity extends StatelessWidget {
  const DoctorsInTheNearestCity({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: width / 1.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      Images
                          .doctorProfileIcon1, // Changed to doctorProfileIcon1
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Dr. John Doe', // Adjusted to 'Dr. John Doe'
                            style: ginaTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(8),
                          const Icon(
                            Bootstrap.patch_check_fill,
                            color: Colors.blue,
                            size: 12,
                          ),
                        ],
                      ),
                      const Gap(5),
                      Container(
                        height: 19,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffF2F2F2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                            child: Text(
                              'General Practitioner'.toUpperCase(),
                              style: const TextStyle(
                                color: GinaAppTheme.lightInverseSurface,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          Image.asset(
                            Images.officeAddressLogo,
                            width: 10,
                          ),
                          const Gap(5),
                          const Text(
                            '456 Main Road, City, Philippines', // Adjusted address
                            style: TextStyle(
                              color: GinaAppTheme.lightInverseSurface,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Consultation Availability',
                      style: ginaTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Gap(10),
                  const Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            MingCute.check_2_fill,
                            size: 20,
                            color: Colors.green,
                          ),
                          Gap(5),
                          Text(
                            'Online',
                          ),
                        ],
                      ),
                      Gap(20),
                      Row(
                        children: [
                          Icon(
                            MingCute.check_2_fill,
                            size: 20,
                            color: Colors.green,
                          ),
                          Gap(5),
                          Text(
                            'In-Person',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(25),
                  Row(
                    children: [
                      const Icon(
                        Bootstrap.calendar_fill,
                        size: 15,
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
                      const Gap(10),
                      Text(
                        'Monday - Friday',
                        style: ginaTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: width / 2.21,
                    decoration: BoxDecoration(
                      color: GinaAppTheme.lightPrimaryColor.withOpacity(0),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          'Book Doctor',
                          style: ginaTheme.textTheme.bodyMedium?.copyWith(
                            color: GinaAppTheme.lightOnPrimaryColor,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationThickness: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: width / 2.21,
                    decoration: const BoxDecoration(
                      color: GinaAppTheme.lightTertiaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          'View Profile',
                          style: ginaTheme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
