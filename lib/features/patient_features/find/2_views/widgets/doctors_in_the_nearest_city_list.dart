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
        height: height * 0.09,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  Images.doctorProfileIcon1,
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
                        'Dr. Maria Santos',
                        style: ginaTheme.textTheme.labelLarge?.copyWith(
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
                        '123 Main Street, Suite 201, Lapu-lapu City, Philippines',
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
      ),
    );
  }
}
