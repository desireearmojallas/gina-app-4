import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/doctor_rating_badge/doctor_rating_badge.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Widget doctorConsultationFeeNameWidget(size, ginaTheme) {
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
                    doctorRating: 2,
                    width: 100,
                  ),
                  Gap(10),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.53,
                        child: const Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Dr. Desiree Armojallas, MD FPOGS, FSOUG',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Gap(5),
                            Icon(
                              Icons.verified,
                              color: Colors.blue,
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
                        'Obstretrics and Gynecology'.toUpperCase(),
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
                        'Dr. Desiree Armojallas Clinic, Looc, Lapu-Lapu City, Cebu, PH 6015',
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
