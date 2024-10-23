import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/sign_up_success_dialog.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_1.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_2.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_3.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_4.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/patient/patient_registration.dart';

class SignupPage extends StatefulWidget {
  final bool isDoctor;
  const SignupPage({
    super.key,
    required this.isDoctor,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.isDoctor ? 1 : 0;
  }

  int selectedIndex = 0; // 0 for patient, 1 for doctor
  bool obscurePassword = true;
  int currentDoctorStep = 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) => current is AuthActionState,
        buildWhen: (previous, current) => current is! AuthActionState,
        listener: (context, state) {
          if (state is AuthRegisterPatientSuccessState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: GinaAppTheme.lightSurface,
                title: const Text('Success'),
                content:
                    const Text('Your account has been created successfully'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: GinaAppTheme.lightOnBackground,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AuthRegisterPatientFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthRegisterDoctorSuccessState) {
            signUpSuccessDialog(context);
          } else if (state is AuthRegisterDoctorFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(30),
                Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 25,
                      child: IconButton(
                        onPressed: () {
                          if (selectedIndex == 0) {
                            Navigator.of(context).pop();
                          } else if (selectedIndex == 1) {
                            if (currentDoctorStep > 1) {
                              setState(() {
                                currentDoctorStep--;
                              });
                            } else {
                              setState(() {
                                selectedIndex = 0;
                              });
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF36344E),
                          size: 30,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GinaHeader(
                          size: 60,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 250,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: buildPositionedOption(
                          'Patient',
                          38,
                          isSelected: selectedIndex == 0,
                          screenWidth: screenWidth,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: buildPositionedOption(
                          'Doctor',
                          38,
                          isSelected: selectedIndex == 1,
                          screenWidth: screenWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),

                // form fields
                Expanded(
                  flex: 10,
                  child: SizedBox(
                    height: 500,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (selectedIndex == 0) ...[
                            const PatientRegistration(),
                          ] else if (selectedIndex == 1) ...[
                            if (currentDoctorStep == 1)
                              const DoctorRegistrationStepOne(),
                            if (currentDoctorStep == 2)
                              const DoctorRegistrationStepTwo(),
                            if (currentDoctorStep == 3)
                              const DoctorRegistrationStepThree(),
                            if (currentDoctorStep == 4)
                              const DoctorRegistrationStepFour(),
                          ],
                          const Gap(50),
                          selectedIndex == 0
                              ? const SizedBox()
                              : currentDoctorStep == 4
                                  ? doctorSignUpButton()
                                  : nextButton(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  AnimatedContainer buildPositionedOption(
    String label,
    double height, {
    required bool isSelected,
    required double screenWidth,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 125,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        height: height,
        decoration: ShapeDecoration(
            color: isSelected
                ? GinaAppTheme.lightTertiaryContainer
                : const Color(0xFFF3F3F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23),
            )),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? GinaAppTheme.lightOnTertiaryContainer
                  : const Color(0xFF9493A0),
              fontSize: 12,
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton doctorSignUpButton() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final bool isLoading = authBloc.state is AuthRegisterLoadingState;
    return ElevatedButton(
      onPressed: () {
        doctorRegistrationStepFourFormKey.currentState?.validate();

        authBloc.add(AuthRegisterDoctorEvent(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          medicalSpecialty: medicalSpecialtyController.text,
          medicalLicenseNumber: medicalLicenseNumberController.text,
          boardCertificationOrganization:
              boardCertificationOrganizationController.text,
          boardCertificationDate: boardCertificationDateController.text,
          medicalSchool: medicalSchoolController.text,
          medicalSchoolStartDate: medicalSchoolStartDateController.text,
          medicalSchoolEndDate: medicalSchoolEndDateController.text,
          residencyProgram: residencyProgramController.text,
          residencyProgramStartDate: residencyProgramStartDateController.text,
          residencyProgramGraduationYear:
              residencyProgramGraduationYearController.text,
          fellowShipProgram: fellowShipProgramController.text,
          fellowShipProgramStartDate: fellowShipProgramStartDateController.text,
          fellowShipProgramEndDate: fellowShipProgramEndDateController.text,
          officeAddress: officeAddressController.text,
          officeMapsLocationAddress: mapsLocationAddressController.text,
          officeLatLngAddress: officeLatLngAddressController.text,
          officePhoneNumber: officePhoneNumberController.text,
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: GinaAppTheme.lightTertiaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 1.45,
            height: 49,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CustomLoadingIndicator(
                        colors: [
                          Colors.white,
                          Colors.white30,
                          Colors.white60,
                        ],
                      ),
                    )
                  : const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SF UI Display',
                        color: GinaAppTheme.lightOnTertiaryContainer,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  ElevatedButton nextButton() {
    return ElevatedButton(
      onPressed: () {
        if (selectedIndex == 1) {
          GlobalKey<FormState>? currentFormKey;

          switch (currentDoctorStep) {
            case 1:
              currentFormKey = doctorRegistrationStepOneFormKey;
              break;
            case 2:
              currentFormKey = doctorRegistrationStepTwoFormKey;
              break;
            case 3:
              currentFormKey = doctorRegistrationStepThreeFormKey;
              break;
            default:
              break;
          }
          if (currentFormKey?.currentState?.validate() ?? false) {
            // if validation is successful, proceed to the next step
            setState(() {
              currentDoctorStep++;
            });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: GinaAppTheme.lightTertiaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.45,
        height: 49,
        child: const Center(
          child: Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              color: GinaAppTheme.lightOnTertiaryContainer,
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}
