import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/my_forum_posts_widget.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/patient_profile_details.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/patient_profile_header.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/view_cycle_history_widget.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/waves_widget.dart';

class ProfileScreenLoaded extends StatelessWidget {
  final UserModel patientData;
  const ProfileScreenLoaded({super.key, required this.patientData});

// TODO : UI ONLY, ADD LOGIC LATER
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    final profileBloc = context.read<ProfileBloc>();

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: PatientProfileHeader(
                    patientData: patientData,
                  ),
                ),
              ),
              Gap(height * 0.005),
              PatientProfileDetails(
                patientData: patientData,
              ),
              Container(
                width: width * 0.94,
                height: height * 0.2,
                decoration: const BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ViewCycleHistoryWidget(),
                    Gap(15),
                    MyForumPostsWidget(),
                  ],
                ),
              ),
              WavesWidget(
                gradientColors: GinaAppTheme.gradientColors,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
