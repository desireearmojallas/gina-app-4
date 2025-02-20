import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';

class ProfileDetailsPatientData extends StatelessWidget {
  final UserModel patientData;
  const ProfileDetailsPatientData({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    final labelStyle = ginaTheme.textTheme.bodySmall?.copyWith(
      color: GinaAppTheme.lightOutline,
    );
    final textStyle = ginaTheme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    final divider = Column(
      children: [
        const Gap(5),
        SizedBox(
          width: size.width / 1.15,
          child: const Divider(
            thickness: 0.5,
            color: GinaAppTheme.lightSurfaceVariant,
          ),
        ),
        // const Gap(25),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: Container(
        height: size.height * 0.43,
        width: size.width / 1.08,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: GinaAppTheme.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0), // Border width
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        foregroundImage: AssetImage(Images.patientProfileIcon),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              patientData.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              patientData.email,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Birth date',
                        style: labelStyle,
                      ),
                      const Gap(10),
                      Text(
                        patientData.dateOfBirth,
                        style: textStyle,
                      ),
                    ],
                  ),
                  const Gap(130),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: labelStyle,
                      ),
                      const Gap(10),
                      SizedBox(
                        width: size.width * 0.22,
                        child: Flexible(
                          child: Text(
                            patientData.gender,
                            style: textStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            divider,
            const Gap(15),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: labelStyle,
                    ),
                    const Gap(10),
                    Text(
                      patientData.address,
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
