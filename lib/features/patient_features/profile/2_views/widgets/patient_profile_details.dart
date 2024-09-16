import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';

class PatientProfileDetails extends StatelessWidget {
  final UserModel patientData;
  const PatientProfileDetails({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.94,
      height: height * 0.2,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Personal Details
          // Gap(height * 0.06),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 10, 0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textHeadlineSmall('Birth date'),
                      const Gap(5),
                      textTitleMedium(patientData.dateOfBirth),
                    ],
                  ),
                ),
                Gap(width * 0.1),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textHeadlineSmall('Gender'),
                      const Gap(5),
                      textTitleMedium(patientData.gender),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(height * 0.02),
          const Divider(
            thickness: 0.2,
            height: 2,
          ),
          Gap(height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textHeadlineSmall('Address'),
                      const Gap(5),
                      textTitleMedium(patientData.address),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Gap(height * 0.01),
          // const Divider(
          //   thickness: 0.2,
          //   height: 2,
          // ),
        ],
      ),
    );
  }

  Widget textHeadlineSmall(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: GinaAppTheme.lightOutline,
      ),
    );
  }

  Widget textTitleMedium(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: GinaAppTheme.lightInverseSurface,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
