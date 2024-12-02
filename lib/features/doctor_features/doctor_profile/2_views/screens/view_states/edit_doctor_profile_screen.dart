import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/bloc/doctor_profile_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/doctor_profile_update_dialog/bloc/doctor_profile_update_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/doctor_profile_update_dialog/doctor_profile_update_dialog_state.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/widgets/edit_doctor_text_fields_form.dart';

class EditDoctorProfileScreen extends StatelessWidget {
  final DoctorModel doctorData;
  const EditDoctorProfileScreen({super.key, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<DoctorProfileBloc>();
    final profileUpdateBloc = context.read<DoctorProfileUpdateBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);
    bool isSavedButtonClicked = false;
    final TextEditingController fullNameController = TextEditingController(
      text: doctorData.name,
    );
    final TextEditingController emailController = TextEditingController(
      text: doctorData.email,
    );
    final TextEditingController phoneNoController = TextEditingController(
      text: doctorData.officePhoneNumber,
    );
    final TextEditingController addressController = TextEditingController(
      text: doctorData.officeAddress,
    );

    return SingleChildScrollView(
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
              EditDoctorProfileTextField(
                textController: fullNameController,
                labelText: 'Full Name',
                ginaTheme: ginaTheme,
                readOnly: false,
              ),
              Gap(size.height * 0.04),
              EditDoctorProfileTextField(
                textController: emailController,
                labelText: 'Email address',
                ginaTheme: ginaTheme,
                readOnly: true,
              ),
              Gap(size.height * 0.04),
              EditDoctorProfileTextField(
                textController: phoneNoController,
                labelText: 'Office Phone Number',
                ginaTheme: ginaTheme,
                readOnly: false,
              ),
              Gap(size.height * 0.04),
              EditDoctorProfileTextField(
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
                        profileBloc.add(GetDoctorProfileEvent());
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
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        profileUpdateBloc.add(
                          EditDoctorProfileSaveButtonEvent(
                            name: fullNameController.text,
                            phoneNumber: phoneNoController.text,
                            address: addressController.text,
                          ),
                        );
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            profileBloc.add(GetDoctorProfileEvent());
                          },
                        );
                        showDoctorProfileUpdateStateDialog(context: context);
                      },
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
    );
  }
}
