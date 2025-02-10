import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/prescription_images_list.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upload_sucessfully_dialog.dart';
import 'package:icons_plus/icons_plus.dart';

class UploadPrescriptionStateScreen extends StatelessWidget {
  const UploadPrescriptionStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: GinaPatientAppBar(title: 'Upload Prescription'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ScrollbarCustom(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Please select the prescription/s you want to upload',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: GinaAppTheme.lightOutline,
                      ),
                ),
                const Gap(20),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: const [25, 20],
                  color: const Color(0xffB4B4B4),
                  strokeWidth: 2,
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Bootstrap.cloud_upload_fill,
                          color: Color(0xffB4B4B4),
                          size: 125,
                        ),
                        const Gap(20),
                        SizedBox(
                          width: size.width * 0.3,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: GinaAppTheme.lightOnPrimaryColor,
                                  width: 1.4,
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Import file',
                              style: TextStyle(
                                color: GinaAppTheme.lightOnPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              appointmentBloc.prescriptionImages.clear();
                              appointmentBloc.imageTitles.clear();

                              appointmentBloc.add(
                                ChooseImageEvent(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(35),
                BlocConsumer<AppointmentBloc, AppointmentState>(
                  listenWhen: (previous, current) =>
                      current is AppointmentActionState,
                  buildWhen: (previous, current) =>
                      current is! AppointmentActionState,
                  listener: (context, state) {
                    if (state is PrescriptionUploadedSuccessfully) {
                      showUploadSuccessDialog(context, ginaTheme, size)
                          .then((value) => Navigator.pop(context));
                    } else if (state is UploadingPrescriptionInFirebase) {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.1),
                        builder: (context) {
                          return Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 200,
                              width: 200,
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CustomLoadingIndicator(),
                                  const Gap(30),
                                  Text(
                                    'Uploading Prescription...',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).then((value) {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, '/appointments');
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is UploadPrescriptionState) {
                      final prescriptionImage = state.prescriptionImage;
                      final imageTitle = state.imageTitle;

                      return prescriptionImage.isEmpty
                          ? const SizedBox()
                          : PrescriptionImagesList(
                              prescriptionImage: prescriptionImage,
                              imageTitle: imageTitle,
                              appointmentBloc: appointmentBloc,
                            );
                    } else if (state is UploadPrescriptionLoading) {
                      return const Center(
                        child: CustomLoadingIndicator(),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
