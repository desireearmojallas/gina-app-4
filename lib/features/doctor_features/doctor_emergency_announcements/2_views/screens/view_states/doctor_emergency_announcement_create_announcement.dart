import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/widgets/dashed_line_painter_vertical.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/forums/2_views/widgets/posted_confirmation_dialog.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorEmergencyAnnouncementCreateAnnouncementScreen
    extends StatelessWidget {
  final bool isLoading;

  final TextEditingController emergencyMessageController =
      TextEditingController();
  final int characterLimit = 2000;

  DoctorEmergencyAnnouncementCreateAnnouncementScreen(
      {super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    final doctorEmergencyAnnouncementBloc =
        context.read<DoctorEmergencyAnnouncementsBloc>();

    return BlocBuilder<DoctorEmergencyAnnouncementsBloc,
        DoctorEmergencyAnnouncementsState>(
      builder: (context, state) {
        final TextEditingController patientChosenController =
            TextEditingController(
          text: state is SelectedAPatientState &&
                  state.appointment.patientName != null
              ? state.appointment.patientName
              : '',
        );

        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: size.height * 0.05,
                    child: Center(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'To',
                              style: ginaTheme.titleSmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: size.width * 0.8,
                            height: size.height * 0.05,
                            child: TextFormField(
                              readOnly: true,
                              controller: patientChosenController,
                              maxLines: 1,
                              style: ginaTheme.titleSmall?.copyWith(
                                color: GinaAppTheme.lightOnPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    debugPrint(
                                        'Navigate to patient list clicked');
                                    context
                                        .read<
                                            DoctorEmergencyAnnouncementsBloc>()
                                        .add(NavigateToPatientList());
                                    debugPrint(
                                        'Successfully added NavigateToPatientList event to the bloc');
                                  },
                                  icon: const Icon(
                                    MingCute.user_add_2_line,
                                    color: GinaAppTheme.lightOnPrimaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                  if (state is SelectedAPatientState) ...[
                    IntrinsicHeight(
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            GinaAppTheme.defaultBoxShadow,
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Appointment Details'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(10),
                                      Text(
                                        state.appointment.modeOfAppointment == 0
                                            ? 'Online Consultation'
                                                .toUpperCase()
                                            : 'Face-to-face Consultation'
                                                .toUpperCase(),
                                        style: const TextStyle(
                                          color: GinaAppTheme
                                              .lightTertiaryContainer,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  AppointmentStatusContainer(
                                    appointmentStatus:
                                        state.appointment.appointmentStatus!,
                                  ),
                                ],
                              ),
                              const Gap(20),
                              Text(
                                'Appointment ID: ${state.appointment.appointmentUid}',
                                style: ginaTheme.labelMedium?.copyWith(
                                  color: GinaAppTheme.lightOutline,
                                  fontSize: 10.0,
                                ),
                                maxLines: null,
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.2,
                                            child: const Text(
                                              'Patient name',
                                              style: TextStyle(
                                                color:
                                                    GinaAppTheme.lightOutline,
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Gap(5),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Flexible(
                                              child: Text(
                                                state.appointment.patientName!,
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.2,
                                            child: const Text(
                                              'Doctor name',
                                              style: TextStyle(
                                                color:
                                                    GinaAppTheme.lightOutline,
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Gap(5),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Flexible(
                                              child: Text(
                                                'Dr. ${state.appointment.doctorName}',
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  CustomPaint(
                                    size: Size(1, size.height * 0.05),
                                    painter: DashedLinePainterVertical(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            state.appointment.appointmentTime!,
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          Text(
                                            state.appointment.appointmentDate!,
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                  ],
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: emergencyMessageController,
                      maxLines: 18,
                      maxLength: characterLimit,
                      style: ginaTheme.bodyMedium,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      enableSuggestions: true,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Write emergency announcement here...',
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                        counterStyle: TextStyle(
                          color: GinaAppTheme.lightOutline,
                        ),
                      ),
                    ),
                  ),
                  const Gap(80),
                  SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.05,
                    child: BlocConsumer<DoctorEmergencyAnnouncementsBloc,
                        DoctorEmergencyAnnouncementsState>(
                      listenWhen: (previous, current) =>
                          current is DoctorEmergencyAnnouncementsActionState,
                      buildWhen: (previous, current) =>
                          current is! DoctorEmergencyAnnouncementsActionState,
                      listener: (context, state) {
                        if (state
                            is CreateEmergencyAnnouncementPostSuccessState) {
                          postedConfirmationDialog(context, 'Posted', false)
                              .then((value) => doctorEmergencyAnnouncementBloc
                                  .add(GetDoctorEmergencyAnnouncementsEvent()));
                        }
                      },
                      builder: (context, state) {
                        final appointment = state is SelectedAPatientState
                            ? state.appointment
                            : null;
                        final isLoading =
                            state is CreateAnnouncementLoadingState;
                        return FilledButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (emergencyMessageController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please write an emergency announcement',
                                  ),
                                ),
                              );
                            } else if (patientChosenController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select a patient',
                                  ),
                                ),
                              );
                            } else {
                              doctorEmergencyAnnouncementBloc
                                  .add(CreateEmergencyAnnouncementEvent(
                                message: emergencyMessageController.text,
                                appointment: appointment!,
                              ));
                            }
                          },
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CustomLoadingIndicator(
                                    colors: [
                                      GinaAppTheme.appbarColorLight,
                                    ],
                                  ),
                                )
                              : const Text(
                                  'Post',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
