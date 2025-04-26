import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/widgets/dashed_line_painter_vertical.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/custom_appointment_countdown.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ConsultationWaitingAppointmentScreen extends StatelessWidget {
  final AppointmentModel appointment;
  final bool? isDoctor;
  const ConsultationWaitingAppointmentScreen({
    super.key,
    required this.appointment,
    this.isDoctor = false,
  });

  @override
  Widget build(BuildContext context) {
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    final patientConsultationBloc = context.read<ConsultationBloc>();
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    bool isDialogShown = false;
    return Scaffold(
      // backgroundColor: Colors.white,
      body: ScrollbarCustom(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppointmentCard(
                      size: size,
                      appointment: appointment,
                      ginaTheme: ginaTheme,
                      doctorConsultationBloc: doctorConsultationBloc,
                      patientConsultationBloc: patientConsultationBloc,
                      isDoctor: isDoctor!,
                    ),
                    GinaDivider(
                      space: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * 0.85,
                              child: Flexible(
                                child: Text(
                                  isDoctor == true
                                      ? 'Countdown to ${appointment.patientName}\'s consultation'
                                      : 'Countdown to Your Consultation with Dr. ${appointment.doctorName}',
                                  style: ginaTheme.bodyMedium?.copyWith(
                                    // fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                            ),
                            const Gap(5),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${appointment.appointmentDate} at ${appointment.appointmentTime} ',
                                    style: ginaTheme.bodySmall?.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '| ',
                                    style: ginaTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors
                                          .grey, // Optional: Different color for the separator
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'As of today ${DateFormat('MMMM d, yyyy').format(DateTime.now())} at ${DateFormat.jm().format(DateTime.now())}',
                                    style: ginaTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(5),
                    AppointmentCountdown(
                      appointment: appointment,
                      onCountdownComplete: () {
                        if (!isDialogShown) {
                          isDialogShown = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  icon: const Icon(
                                    Icons.info_rounded,
                                    color: GinaAppTheme.lightSecondary,
                                    size: 80,
                                  ),
                                  title: const Text(
                                      'Your Consultation Starts Soon!'),
                                  content: const Text(
                                    'In just 15 minutes, your consultation will begin. Please prepare and head to your consultation room now.',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Center(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: FilledButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            HapticFeedback.mediumImpact();
                                            Navigator.of(context).pop();
                                            isDoctor == true
                                                ? doctorConsultationBloc.add(
                                                    DoctorConsultationGetRequestedAppointmentEvent(
                                                    recipientUid:
                                                        selectedPatientUid!,
                                                  ))
                                                : patientConsultationBloc.add(
                                                    ConsultationGetRequestedAppointmentEvent(
                                                    recipientUid:
                                                        doctorDetails!.uid,
                                                  ));
                                          },
                                          child: const Text(
                                              'Go to consultation room'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      },
                    ),
                    const Gap(30),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        height: size.height * 0.22,
                        width: size.width * 0.70,
                        child: Lottie.network(
                          'https://lottie.host/f5cdd338-d7e0-44d1-850f-849ace6835d3/lT5Yt3AwJq.json',
                          width: 230,
                          height: 230,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'Failed to load animation',
                              style: TextStyle(color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                    const Gap(25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Your consultation will begin soon. Please stay tuned for the countdown.',
                        style: ginaTheme.bodyMedium?.copyWith(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Gap(25),
                    Container(
                      height: size.height * 0.06,
                      width: size.width * 0.9,
                      margin: const EdgeInsets.only(bottom: 30),
                      child: FilledButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Ok',
                          style: ginaTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.size,
    required this.appointment,
    required this.ginaTheme,
    required this.isDoctor,
    required this.doctorConsultationBloc,
    required this.patientConsultationBloc,
  });

  final Size size;
  final AppointmentModel appointment;
  final TextTheme ginaTheme;
  final bool isDoctor;
  final DoctorConsultationBloc doctorConsultationBloc;
  final ConsultationBloc patientConsultationBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
      child: IntrinsicHeight(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          appointment.modeOfAppointment == 0
                              ? 'Online Consultation'.toUpperCase()
                              : 'Face-to-face Consultation'.toUpperCase(),
                          style: const TextStyle(
                            color: GinaAppTheme.lightTertiaryContainer,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    StreamBuilder<AppointmentModel>(
                      stream: isDoctor
                          ? doctorConsultationBloc.doctorAppointmentStream(
                              appointment.appointmentUid!)
                          : patientConsultationBloc.patientAppointmentStream(
                              appointment.appointmentUid!),
                      initialData: appointment,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 25,
                            width: 25,
                            child: CustomLoadingIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          debugPrint(
                              'Error in appointment stream: ${snapshot.error}');
                          // Fallback to the original status if there's an error
                          return AppointmentStatusContainer(
                            appointmentStatus: appointment.appointmentStatus!,
                          );
                        }

                        // Use the updated appointment status from the stream
                        final updatedAppointment = snapshot.data!;
                        return AppointmentStatusContainer(
                          appointmentStatus:
                              updatedAppointment.appointmentStatus!,
                        );
                      },
                    ),
                  ],
                ),
                const Gap(20),
                Text(
                  'Appointment ID: ${appointment.appointmentUid}',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.2,
                              child: const Text(
                                'Patient name',
                                style: TextStyle(
                                  color: GinaAppTheme.lightOutline,
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
                                  appointment.patientName!,
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
                                  color: GinaAppTheme.lightOutline,
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
                                  'Dr. ${appointment.doctorName}',
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
                              appointment.appointmentTime!,
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
                              appointment.appointmentDate!,
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
    );
  }
}
