import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/face_to_face_card_details.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/full_screen_image_viewer.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/appointment_information_container.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/appointment_status_card.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class ConsultationHistoryDetailScreen extends StatelessWidget {
  final DoctorModel doctorDetails;
  final AppointmentModel appointment;
  final UserModel currentPatient;
  final List<String> prescriptionImages;

  const ConsultationHistoryDetailScreen({
    super.key,
    required this.doctorDetails,
    required this.appointment,
    required this.currentPatient,
    required this.prescriptionImages,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    // Reverse the prescriptionImages list
    final reversedPrescriptionImages = prescriptionImages.reversed.toList();

    return RefreshIndicator(
      onRefresh: () async {
        appointmentBloc.add(NavigateToConsultationHistoryEvent(
          doctorUid: doctorDetails.uid,
          appointmentUid: appointment.appointmentUid!,
        ));
      },
      child: ScrollbarCustom(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              doctorNameWidget(size, ginaTheme, doctorDetails),
              AppointmentStatusCard(
                appointmentStatus: appointment.appointmentStatus!,
              ),
              AppointmentInformationContainer(
                appointment: appointment,
                currentPatient: currentPatient,
              ),
              const FaceToFaceCardDetails(),
              reversedPrescriptionImages.isEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No attachment/s available for this appointment.',
                        style: ginaTheme.bodySmall?.copyWith(
                          color: GinaAppTheme.lightOutline,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${reversedPrescriptionImages.length} Attachment/s',
                              style: ginaTheme.bodySmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          width: size.width * 0.9,
                          height: size.height * 0.6,
                          child: Column(
                            children: [
                              const Gap(10),
                              Expanded(
                                child: ScrollbarCustom(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount:
                                        reversedPrescriptionImages.length,
                                    itemBuilder: (context, index) {
                                      final image =
                                          reversedPrescriptionImages[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              HapticFeedback.mediumImpact();
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    FullScreenImageViewer(
                                                  imageUrl: image,
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Image.network(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
