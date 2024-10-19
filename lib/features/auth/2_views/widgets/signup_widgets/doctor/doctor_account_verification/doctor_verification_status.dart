import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_account_verification/doctor_upload_status.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_account_verification/submitting_medical_license_dialog.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/posted_confirmation_dialog.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorVerificationStatusScreen extends StatelessWidget {
  const DoctorVerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Document Validation',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
            ),
            const Gap(20),
            const Text(
              'Our team will thoroughly review your submitted documents to verify their authenticity and ensure they meet the necessary criteria. This process usually takes 24 hours. Once the verification is complete, you will receive an email confirming your verified status on the GINA app. You can then start using the app.',
              textAlign: TextAlign.justify,
            ),
            const Gap(50),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorUploadStatusScreen(),
                  ),
                );
              },
              child: Container(
                width: size.width,
                height: 65,
                decoration: BoxDecoration(
                  color: GinaAppTheme.appbarColorLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    GinaAppTheme.defaultBoxShadow,
                  ],
                ),
                child: Row(
                  children: [
                    const Gap(30),
                    const Icon(
                      Bootstrap.person_vcard,
                      color: GinaAppTheme.lightOnSecondary,
                    ),
                    const Gap(20),
                    Text(
                      'Medical License',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is UploadMedicalImageState) {
                          final image = state.medicalImageId;
                          return image.path.isEmpty
                              ? const CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Color(0xffD6D7D8),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: GinaAppTheme.appbarColorLight,
                                    size: 18,
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.green,
                                  child: Icon(
                                    Icons.check,
                                    color: GinaAppTheme.appbarColorLight,
                                    size: 18,
                                  ),
                                );
                        }
                        return const CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xffD6D7D8),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: GinaAppTheme.appbarColorLight,
                            size: 18,
                          ),
                        );
                      },
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
            const Gap(50),
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: GinaAppTheme.lightOnSecondary,
                ),
                const Gap(5),
                Text(
                  'Instruction',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const Gap(25),
            const Text(
              '• The file must be submitted in the format JPG, JPEG, PNG or PDF, and the file size is limited to 2.5 MB.\n• Select the type of document that you are submitting.\n• Warning: Submitting fake or altered documents will result in account suspension',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: GinaAppTheme.lightOutline,
              ),
            ),
            const Gap(35),
            const Text(
              'Note: Please ensure the submitted documents are clear, legible, and contain all relevant information. If any documents are found to be incomplete or invalid, you may be requested to resubmit them.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: GinaAppTheme.lightOutline,
              ),
            ),
            const Gap(80),
            BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) => current is AuthActionState,
              buildWhen: (previous, current) => current is! AuthActionState,
              listener: (context, state) {
                if (state is UploadMedicalImageSuccessState) {
                  postedConfirmationDialog(
                          context, 'Submitted for verification')
                      .then(
                    (value) =>
                        Navigator.pushReplacementNamed(context, '/login'),
                  );
                } else if (state is UploadMedicalImageFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to Submit Medical License'),
                      backgroundColor: GinaAppTheme.lightError,
                    ),
                  );
                } else if (state is SubmittingVerificationLoadingState) {
                  submittingMedicalLicenseDialog(
                    context,
                    'Submitting your medical license',
                  ).then(
                    (value) => Navigator.pop(context),
                  );
                }
              },
              builder: (context, state) {
                if (state is UploadMedicalImageState) {
                  final image = state.medicalImageId;
                  final title = state.medicalImageIdTitle;

                  return image.path.isEmpty
                      ? const SizedBox()
                      : SizedBox(
                          width: size.width * 0.9,
                          height: 50,
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            onPressed: () {
                              authBloc.add(
                                SubmitDoctorMedicalVerificationEvent(
                                  doctorUid: registeredDoctorUid!,
                                  medicalLicenseImage: image,
                                  medicalLicenseImageTitle:
                                      title.path.split('/').last,
                                ),
                              );
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
