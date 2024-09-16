import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';

class PatientProfileDetails extends StatelessWidget {
  final UserModel patientData;
  const PatientProfileDetails({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GlassmorphicContainer(
      width: width * 0.94,
      height: height * 0.2,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // const Color(0xFFffffff).withOpacity(0.1),
            // const Color(0xFFFFFFFF).withOpacity(0.05),
            const Color(0xFFffffff).withOpacity(0.2),
            const Color(0xFFFFFFFF).withOpacity(0.08),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
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
            color: Colors.white,
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
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey[200],
      ),
    );
  }

  Widget textTitleMedium(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
