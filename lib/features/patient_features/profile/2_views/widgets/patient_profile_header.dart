import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';

class PatientProfileHeader extends StatelessWidget {
  final UserModel patientData;
  const PatientProfileHeader({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final profileBloc = context.read<ProfileBloc>();
    final ginaTheme = Theme.of(context);

    return GlassmorphicContainer(
      height: height * 0.38,
      width: width * 0.94,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.05),
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
        children: [
          // Profile Picture
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SingleChildScrollView(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ...GinaAppTheme.gradientColors,
                    ],
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
                        radius: 76,
                        foregroundImage: AssetImage(Images.patientProfileIcon),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Gap(height * 0.025),
          Text(
            patientData.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            patientData.email,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),

          Gap(height * 0.025),

          // Edit profile button
          SizedBox(
            height: height * 0.045,
            width: width * 0.35,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: GinaAppTheme.lightTertiaryContainer,
              ),
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  side: MaterialStateProperty.all(
                    const BorderSide(
                      width: 2.0,
                      color: Colors
                          .transparent, // Make the button's border transparent
                    ),
                  ),
                ),
                onPressed: () {
                  profileBloc.add(NavigateToEditProfileEvent());
                },
                child: Text(
                  'Edit Profile',
                  style: ginaTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white, // Change text color to white
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    /* return Container(
      height: height * 0.38,
      width: width * 0.94,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          GinaAppTheme.defaultBoxShadow,
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SingleChildScrollView(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ...GinaAppTheme.gradientColors,
                    ],
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
                        radius: 76,
                        foregroundImage: AssetImage(Images.patientProfileIcon),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Gap(height * 0.025),
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
              fontSize: 14,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),

          Gap(height * 0.025),

          // Edit profile button
          SizedBox(
            height: height * 0.045,
            width: width * 0.35,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: GinaAppTheme.lightTertiaryContainer,
              ),
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  side: MaterialStateProperty.all(
                    const BorderSide(
                      width: 2.0,
                      color: Colors
                          .transparent, // Make the button's border transparent
                    ),
                  ),
                ),
                onPressed: () {
                  profileBloc.add(NavigateToEditProfileEvent());
                },
                child: Text(
                  'Edit Profile',
                  style: ginaTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white, // Change text color to white
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ); */
  }
}
