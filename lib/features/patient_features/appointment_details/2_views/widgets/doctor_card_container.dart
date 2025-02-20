import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/doctor_rating_badge/doctor_rating_badge.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';

class DoctorCardContainer extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorCardContainer({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: size.width * 0.9,
      height: size.height * 0.19,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 30,
            ),
            child: CircleAvatar(
              radius: 20,
              foregroundImage: AssetImage(Images.doctorProfileIcon1),
              backgroundColor: Colors.transparent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorRatingBadge(doctorRating: doctor.doctorRatingId),
              const Gap(5),
              Row(
                children: [
                  Text(
                    'Dr. ${doctor.name}',
                    style: ginaTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(5),
                  const Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 18,
                  ),
                  Text(
                    doctor.medicalSpecialty,
                    style: ginaTheme.bodyMedium?.copyWith(
                      color: GinaAppTheme.lightOutline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
