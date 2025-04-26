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
          text: state is SelectedPatientsState &&
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
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                          child: Row(
                            children: [
                              Text(
                                'To',
                                style: ginaTheme.titleSmall?.copyWith(
                                  color: GinaAppTheme.lightOutline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  debugPrint(
                                      'Navigate to patient list clicked');
                                  context
                                      .read<DoctorEmergencyAnnouncementsBloc>()
                                      .add(NavigateToPatientList());
                                },
                                icon: const Icon(
                                  MingCute.user_add_2_line,
                                  color: GinaAppTheme.lightOnPrimaryColor,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        if (state is SelectedPatientsState &&
                            (state).selectedAppointments.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: (state)
                                  .selectedAppointments
                                  .map((appointment) => Chip(
                                        backgroundColor: GinaAppTheme
                                            .lightSurfaceVariant
                                            .withOpacity(0.2),
                                        label: Text(
                                          appointment.patientName ?? 'Unknown',
                                          style: ginaTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        deleteIcon: const Icon(
                                          Icons.cancel,
                                          size: 16,
                                        ),
                                        onDeleted: () {
                                          context
                                              .read<
                                                  DoctorEmergencyAnnouncementsBloc>()
                                              .add(
                                                RemovePatientFromSelectionEvent(
                                                    appointment: appointment),
                                              );
                                        },
                                      ))
                                  .toList(),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                            child: Text(
                              'No patients selected',
                              style: ginaTheme.bodySmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  if (state is SelectedPatientsState) ...[
                    Container(
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
                            const Text(
                              'SELECTED PATIENT APPOINTMENTS',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            ...state.selectedAppointments.map((appointment) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    // Left: Patient name and appointment type
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointment.patientName ??
                                                'Unknown',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Gap(4),
                                          Text(
                                            appointment.modeOfAppointment == 0
                                                ? 'Online'
                                                : 'Face-to-face',
                                            style: const TextStyle(
                                              color: GinaAppTheme
                                                  .lightTertiaryContainer,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Right: Date/time and status
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            appointment.appointmentDate ?? '',
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: GinaAppTheme.lightOutline,
                                            ),
                                          ),
                                          const Gap(4),
                                          Text(
                                            appointment.appointmentTime ?? '',
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: GinaAppTheme.lightOutline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Status indicator (small)
                                    const Gap(8),
                                    SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: AppointmentStatusContainer(
                                        appointmentStatus:
                                            appointment.appointmentStatus!,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
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
                    height: size.height * 0.06,
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
                        final appointment = state is SelectedPatientsState
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
                            } else if (state is! SelectedPatientsState ||
                                (state).selectedAppointments.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select at least one patient',
                                  ),
                                ),
                              );
                            } else {
                              doctorEmergencyAnnouncementBloc.add(
                                CreateEmergencyAnnouncementEvent(
                                  message: emergencyMessageController.text,
                                  appointments: (state).selectedAppointments,
                                ),
                              );
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
