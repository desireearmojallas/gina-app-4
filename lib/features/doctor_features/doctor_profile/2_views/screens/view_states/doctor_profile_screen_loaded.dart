import 'package:flutter/material.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/doctor_rating_badge/doctor_rating_badge.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/screens/view_states/edit_doctor_profile_screen.dart';

class DoctorProfileScreenLoaded extends StatelessWidget {
  const DoctorProfileScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);
    const divider = Divider(
      thickness: 0.2,
      height: 2,
    );

    return Scaffold(
      body: ScrollbarCustom(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: size.height * 0.8,
                    width: size.width * 0.94,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      boxShadow: [
                        GinaAppTheme.defaultBoxShadow,
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Column(
                        children: [
                          // Profile Picture
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: GinaAppTheme.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(5.0), // Border width
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
                                        AssetImage(Images.doctorProfileIcon1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Gap(15),
                          DoctorRatingBadge(
                            //todo: to change the rating
                            doctorRating: 2,
                          ),
                          Gap(size.height * 0.025),
                          const Column(
                            children: [
                              Text(
                                'Dr. Gina',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Gap(5),
                              Text(
                                'doctor@gina.com',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),

                          Gap(size.height * 0.025),

                          //! -- Edit profile button --
                          SizedBox(
                            height: size.height * 0.045,
                            width: size.width * 0.35,
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
                                  // profileBloc.add(NavigateToEditProfileEvent());
                                  //todo: this is a temporary route
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditDoctorProfileScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Edit Profile',
                                  style:
                                      ginaTheme.textTheme.labelLarge?.copyWith(
                                    color: Colors
                                        .white, // Change text color to white
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Personal Details
                          Gap(size.height * 0.035),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      textHeadlineSmall('Birth date'),
                                      const Gap(5),
                                      textTitleMedium(
                                        // patientData.dateOfBirth,
                                        'January 1, 2000',
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(size.width * 0.1),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      textHeadlineSmall('Gender'),
                                      const Gap(5),
                                      textTitleMedium(
                                        // patientData.gender,
                                        'Male',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(size.height * 0.01),
                          divider,
                          Gap(size.height * 0.03),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      textHeadlineSmall('Office address'),
                                      const Gap(5),
                                      textTitleMedium(
                                        // patientData.address,
                                        '123 Gina St., Gina City',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(size.height * 0.01),
                          divider,
                          Gap(size.height * 0.03),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      textHeadlineSmall('Phone number'),
                                      const Gap(5),
                                      textTitleMedium(
                                        // patientData.address,
                                        '+639123456789',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Gap(size.height * 0.03),

                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: size.height * 0.09,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(Images.patientForumPost),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  GinaAppTheme.defaultBoxShadow,
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
                    ),
                  ),
                ),

                //! -- License Number --
                Gap(size.height * 0.015),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'License Number'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.06,
                      width: size.width * 0.94,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          GinaAppTheme.defaultBoxShadow,
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: textTitleMedium(
                            '1234567890',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //! -- Board Certification --
                Gap(size.height * 0.015),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Board Certification'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.119,
                      width: size.width * 0.94,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          GinaAppTheme.defaultBoxShadow,
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textHeadlineSmall(
                                'Organization',
                              ),
                              textTitleMedium(
                                'Philippine Board of Obstetrics and Gynecology',
                              ),
                              const Gap(10),
                              textHeadlineSmall(
                                'Date of certification',
                              ),
                              textTitleMedium(
                                '05/10/2014',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //! -- Education Experience --
                Gap(size.height * 0.015),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Education Experience'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.356,
                      width: size.width * 0.94,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          GinaAppTheme.defaultBoxShadow,
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textHeadlineSmall(
                                'Medical school',
                              ),
                              textTitleMedium(
                                'Cebu Institute of Medicine',
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textHeadlineSmall(
                                          'Start date',
                                        ),
                                        textTitleMedium(
                                          '06/15/2006',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(size.width * 0.1),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textHeadlineSmall(
                                          'End date',
                                        ),
                                        textTitleMedium(
                                          '05/30/2011',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              divider,
                              const Gap(10),
                              textHeadlineSmall(
                                'Residency program',
                              ),
                              textTitleMedium(
                                'Lapu-Lapu City General Hospital',
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textHeadlineSmall(
                                          'Start date',
                                        ),
                                        textTitleMedium(
                                          '07/01/2011',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(size.width * 0.1),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textHeadlineSmall(
                                          'End date',
                                        ),
                                        textTitleMedium(
                                          '06/30/2015',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              divider,
                              const Gap(10),
                              textHeadlineSmall(
                                'Fellowship program',
                              ),
                              textTitleMedium(
                                'Women\'s Health Center of Cebu',
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textHeadlineSmall(
                                          'Start date',
                                        ),
                                        textTitleMedium(
                                          '08/15/2015',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(size.width * 0.1),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textHeadlineSmall(
                                          'End date',
                                        ),
                                        textTitleMedium(
                                          '08/14/2017',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(size.height * 0.1),
              ],
            ),
          ),
        ),
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
