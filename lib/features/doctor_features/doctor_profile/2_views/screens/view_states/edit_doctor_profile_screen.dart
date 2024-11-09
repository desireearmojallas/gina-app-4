import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/profile/2_views/widgets/edit_text_fields_form.dart';

class EditDoctorProfileScreen extends StatelessWidget {
  const EditDoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);
    bool isSavedButtonClicked = false;
    final TextEditingController fullNameController = TextEditingController(
      // text: doctorData.name,
      text: 'Dr. Gina',
    );
    final TextEditingController emailController = TextEditingController(
      // text: doctorData.email,
      text: 'doctor@gina.com',
    );
    final TextEditingController phoneNoController = TextEditingController(
      // text: doctorData.officePhoneNumber,
      text: '+639123456789',
    );
    final TextEditingController addressController = TextEditingController(
      // text: doctorData.address,
      text: '123 Gina St., Gina City',
    );

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'Edit Profile',
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: GinaAppTheme.gradientColors,
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
                          foregroundImage: AssetImage(
                            Images.doctorProfileIcon1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(size.height * 0.04),
                EditProfileTextField(
                  textController: fullNameController,
                  labelText: 'Full Name',
                  ginaTheme: ginaTheme,
                  readOnly: false,
                ),
                Gap(size.height * 0.04),
                EditProfileTextField(
                  textController: emailController,
                  labelText: 'Email address',
                  ginaTheme: ginaTheme,
                  readOnly: false,
                ),
                Gap(size.height * 0.04),
                EditProfileTextField(
                  textController: phoneNoController,
                  labelText: 'Office Phone Number',
                  ginaTheme: ginaTheme,
                  readOnly: false,
                ),
                Gap(size.height * 0.04),
                EditProfileTextField(
                  textController: addressController,
                  labelText: 'Office Address',
                  ginaTheme: ginaTheme,
                  readOnly: false,
                ),
                Gap(size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.38,
                      child: FilledButton(
                        onPressed: () {
                          // profileBloc.add(GetProfileEvent());
                        },
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: const MaterialStatePropertyAll(
                            GinaAppTheme.lightSurfaceVariant,
                          ),
                        ),
                        child: Text(
                          isSavedButtonClicked == true ? 'Close' : 'Cancel',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: GinaAppTheme.lightOnPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.38,
                      child: FilledButton(
                        onPressed: () {
                          //TODO: FUNCTIONALITY FOR SAVE BUTTON
                          // profileUpdateBloc.add(
                          //   EditProfileSaveButtonEvent(
                          //     name: fullNameController.text,
                          //     dateOfBirth: birthdateController.text,
                          //     address: addressController.text,
                          //   ),
                          // );
                          // Future.delayed(const Duration(seconds: 1), () {
                          //   profileBloc.add(GetProfileEvent());
                          // });
                          // showProfileUpdateStateDialog(
                          //   context: context,
                          // );
                        },
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
                const Gap(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
