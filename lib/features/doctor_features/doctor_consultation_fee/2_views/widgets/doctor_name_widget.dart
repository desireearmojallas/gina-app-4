import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/doctor_rating_badge/doctor_rating_badge.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';

Widget doctorNameWidget(size, ginaTheme, DoctorModel doctorDetails) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                Images.doctorProfileIcon1,
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorRatingBadge(
                    //! will change this doctor rating id once bloc is implemented
                    doctorRating: doctorDetails.doctorRatingId,
                    width: 100,
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.53,
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Dr. ${doctorDetails.name}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            const Gap(5),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  SizedBox(
                    width: size.width * 0.53,
                    child: Flexible(
                      child: Text(
                        doctorDetails.medicalSpecialty.toUpperCase(),
                        style: ginaTheme.bodySmall?.copyWith(
                          color: GinaAppTheme.lightTertiaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    width: size.width * 0.53,
                    child: Flexible(
                      child: Text(
                        doctorDetails.officeAddress,
                        style: ginaTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
