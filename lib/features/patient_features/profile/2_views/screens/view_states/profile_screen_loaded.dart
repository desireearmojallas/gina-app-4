import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/waves_widget.dart';

class ProfileScreenLoaded extends StatelessWidget {
  final UserModel patientData;
  const ProfileScreenLoaded({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    final profileBloc = context.read<ProfileBloc>();
    final List<Color> gradientColors = [
      GinaAppTheme.lightTertiaryContainer,
      GinaAppTheme.lightSecondary,
      GinaAppTheme.lightPrimaryColor,
    ];
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: height * 0.87,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Profile Picture
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    ...gradientColors,
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
                                      foregroundImage:
                                          AssetImage(Images.patientProfileIcon),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                                    
                            Gap(height * 0.025),
                                    
                            // Name & email
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
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
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
                                      color: Colors
                                          .white, // Change text color to white
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                                    
                            // Personal Details
                            Gap(height * 0.06),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                            Gap(height * 0.01),
                            const Divider(
                              thickness: 0.2,
                              height: 2,
                            ),
                            Gap(height * 0.03),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            Gap(height * 0.01),
                            const Divider(
                              thickness: 0.2,
                              height: 2,
                            ),
                                    
                            // 2 cards (view cycle history, my forum posts)
                            Gap(height * 0.05),
                                    
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: width * 0.41,
                                    height: height * 0.12,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage(Images.patientCycleHistory),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          'View \nCycle history',
                                          style: ginaTheme.textTheme.headlineSmall
                                              ?.copyWith(
                                            color: GinaAppTheme.lightOnTertiary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: width * 0.41,
                                    height: height * 0.12,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(Images.patientForumPost),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          'My Forum\nPosts',
                                          style: ginaTheme.textTheme.headlineSmall
                                              ?.copyWith(
                                            color: GinaAppTheme.lightOnTertiary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
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
                    ),
                    const Gap(10),
                    WavesWidget(
                      gradientColors: gradientColors,
                    ),
                  ],
                ),
              ),
            ),
          ),
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