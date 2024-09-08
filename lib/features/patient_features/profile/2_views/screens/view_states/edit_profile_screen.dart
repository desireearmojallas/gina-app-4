import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/bloc/profile_bloc.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/screens/profile_screen.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/edit_text_fields_form.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/waves_widget.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel patientData;
  const EditProfileScreen({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final TextEditingController fullNameController =
        TextEditingController(text: patientData.name);
    final TextEditingController emailController =
        TextEditingController(text: patientData.email);
    final TextEditingController birthdateController =
        TextEditingController(text: patientData.dateOfBirth);
    final TextEditingController genderController =
        TextEditingController(text: patientData.gender);
    final TextEditingController addressController =
        TextEditingController(text: patientData.address);
    final ginaTheme = Theme.of(context);
    final profileBloc = context.read<ProfileBloc>();
    bool isSavedButtonClicked = false;
    final gradientColors = [
      GinaAppTheme.lightTertiaryContainer,
      GinaAppTheme.lightPrimaryColor,
      GinaAppTheme.lightSecondary,
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: height * 0.87,
              width: width * 0.94,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Column(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0), // Border width
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  radius: 56,
                                  foregroundImage:
                                      AssetImage(Images.patientProfileIcon),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(height * 0.04),
                        EditProfileTextField(
                          textController: fullNameController,
                          labelText: 'Full Name',
                          ginaTheme: ginaTheme,
                          readOnly: false,
                        ),
                        Gap(height * 0.04),
                        EditProfileTextField(
                          textController: emailController,
                          labelText: 'Email address',
                          ginaTheme: ginaTheme,
                          readOnly: true,
                        ),
                        Gap(height * 0.04),
                        EditProfileTextField(
                          textController: birthdateController,
                          labelText: 'Birth date',
                          ginaTheme: ginaTheme,
                          readOnly: false,
                        ),
                        Gap(height * 0.04),
                        EditProfileTextField(
                          textController: genderController,
                          labelText: 'Gender',
                          ginaTheme: ginaTheme,
                          readOnly: false,
                        ),
                        Gap(height * 0.04),
                        EditProfileTextField(
                          textController: addressController,
                          labelText: 'Address',
                          ginaTheme: ginaTheme,
                          readOnly: false,
                        ),
                        Gap(height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.38,
                              child: FilledButton(
                                onPressed: () {
                                  // TODO : CHANGE THIS, FOR DEBUGGING PURPOSES ONLY
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/bottomNavigation',
                                  );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                    GinaAppTheme.lightSurfaceVariant,
                                  ),
                                ),
                                child: Text(
                                  isSavedButtonClicked == true
                                      ? 'Close'
                                      : 'Cancel',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: GinaAppTheme.lightOnPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.38,
                              child: FilledButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  WavesWidget(
                    gradientColors: gradientColors,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
