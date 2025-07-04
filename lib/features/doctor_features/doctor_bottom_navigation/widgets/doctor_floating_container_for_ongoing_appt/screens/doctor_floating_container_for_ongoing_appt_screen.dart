import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/1_controllers/doctor_appointment_request_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/widgets/doctor_floating_container_for_ongoing_appt/bloc/doctor_floating_container_for_ongoing_appt_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class DoctorFloatingContainerForOnGoingAppointmentProvider
    extends StatelessWidget {
  const DoctorFloatingContainerForOnGoingAppointmentProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorFloatingContainerForOngoingApptBloc>(
      create: (context) => sl<DoctorFloatingContainerForOngoingApptBloc>()
        ..add(DoctorCheckOngoingAppointments()),
      child: const DoctorFloatingContainerForOnGoingAppointment(),
    );
  }
}

class DoctorFloatingContainerForOnGoingAppointment extends StatelessWidget {
  const DoctorFloatingContainerForOnGoingAppointment({super.key});

  Future<void> _handleAppointmentTap(
      BuildContext context,
      AppointmentModel appointment,
      DoctorAppointmentRequestController appointmentController,
      DoctorEconsultBloc doctorEConsultBloc) async {
    HapticFeedback.mediumImpact();

    final appointmentUid = appointment.appointmentUid;

    // Add payment verification here
    if (appointmentUid != null) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check both payment collections
      final pendingPaymentDoc = await firestore
          .collection('pending_payments')
          .doc(appointmentUid)
          .get();

      final appointmentPaymentsSnapshot = await firestore
          .collection('appointments')
          .doc(appointmentUid)
          .collection('payments')
          .get();

      bool isPaid = false;

      // Check pending_payments first
      if (pendingPaymentDoc.exists) {
        final status = pendingPaymentDoc.data()?['status'] as String? ?? '';
        isPaid = status.toLowerCase() == 'paid';
      }

      // If not found in pending_payments, check appointments/payments
      if (!isPaid && appointmentPaymentsSnapshot.docs.isNotEmpty) {
        final status = appointmentPaymentsSnapshot.docs.first.data()['status']
                as String? ??
            '';
        isPaid = status.toLowerCase() == 'paid';
      }

      if (!isPaid && context.mounted) {
        // Show payment required dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 24,
                  ),
                  const Gap(8),
                  Text(
                    'Payment Required',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GinaAppTheme.lightOnPrimaryColor,
                        ),
                  ),
                ],
              ),
              content: const Text(
                'Patient has not completed payment for this appointment. Consultation cannot begin until payment is verified.',
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return; // Exit early if payment is not verified
      }
    }

    // Continue with existing functionality if payment is verified
    selectedPatientUid = appointment.patientUid;

    doctorEConsultBloc
        .add(GetPatientDataEvent(patientUid: appointment.patientUid!));

    isFromChatRoomLists = false;

    selectedPatientAppointment = appointment.appointmentUid;
    selectedPatientUid = appointment.patientUid ?? '';
    selectedPatientName = appointment.patientName ?? '';
    selectedPatientAppointmentModel = appointment;

    appointmentDataFromDoctorUpcomingAppointmentsBloc = appointment;

    Navigator.pushNamed(context, '/doctorOnlineConsultChat').then((value) =>
        context
            .read<DoctorEconsultBloc>()
            .add(GetRequestedEconsultsDisplayEvent()));
  }

  bool isToday(String appointmentDate) {
    final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    final DateTime date = dateFormat.parse(appointmentDate.trim());
    final DateTime today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool isWithinTimeRange(String appointmentDate, String appointmentTime) {
    final DateFormat dateTimeFormat = DateFormat('MMMM d, yyyy h:mm a');
    final DateTime now = DateTime.now();
    final DateTime appointmentStartTime = dateTimeFormat
        .parse('$appointmentDate ${appointmentTime.split('-')[0].trim()}');
    final DateTime appointmentEndTime = dateTimeFormat
        .parse('$appointmentDate ${appointmentTime.split('-')[1].trim()}');

    return now.isAfter(appointmentStartTime) &&
        now.isBefore(appointmentEndTime);
  }

  Future<bool> hasMessages(String chatroomId, String appointmentId) async {
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('consultation-chatrooms')
        .doc(chatroomId)
        .collection('appointments')
        .doc(appointmentId)
        .collection('messages')
        .get();

    return messagesSnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final appointmentsBloc = context.read<AppointmentBloc>();
    final doctorEConsultBloc = context.read<DoctorEconsultBloc>();
    final DoctorAppointmentRequestController appointmentController =
        DoctorAppointmentRequestController();

    return BlocBuilder<DoctorFloatingContainerForOngoingApptBloc,
        DoctorFloatingContainerForOngoingApptState>(
      builder: (context, state) {
        if (state is DoctorFloatingContainerForOngoingApptLoading) {
          return const Center(child: CustomLoadingIndicator());
        } else if (state is DoctorNoOngoingAppointments) {
          return const SizedBox();
        } else if (state is DoctorOngoingAppointmentFound) {
          final appointment = state.ongoingAppointment;
          final hasMessages = state.hasMessages;

          return Stack(
            children: [
              Positioned(
                bottom: 98,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    // this container will be hidden when there are messages from firebase
                    if (!hasMessages)
                      Container(
                        width: size.width * 0.58,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.black.withOpacity(0.65),
                          boxShadow: [
                            BoxShadow(
                              color: GinaAppTheme.lightOutline.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Send a message first to begin consultation',
                              style: TextStyle(
                                color: GinaAppTheme.appbarColorLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Gap(5),
                            Icon(
                              Icons.arrow_downward_rounded,
                              color: GinaAppTheme.appbarColorLight,
                              size: 11,
                            ),
                          ],
                        ),
                      ),
                    const Gap(8),
                    GestureDetector(
                      onTap: () => _handleAppointmentTap(context, appointment,
                          appointmentController, doctorEConsultBloc),
                      child: Container(
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: GinaAppTheme.lightOutline.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5.0,
                          ),
                          child: Row(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 35,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.9),
                                          width: 3.0,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.transparent,
                                        foregroundImage: AssetImage(
                                            Images.doctorProfileIcon1),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.9),
                                        width: 3.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                      foregroundImage:
                                          AssetImage(Images.patientProfileIcon),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(45),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isWithinTimeRange(
                                                  appointment.appointmentDate!,
                                                  appointment.appointmentTime!)
                                              ? 'Ongoing ${appointment.modeOfAppointment == 0 ? 'Online' : 'Face-to-Face'} Consultation'
                                              : 'Upcoming ${appointment.modeOfAppointment == 0 ? 'Online' : 'Face-to-Face'} Consultation',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'with ${appointment.patientName}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(2),
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: Row(
                                      children: [
                                        Text(
                                          isToday(appointment.appointmentDate!)
                                              ? 'Today • ${appointment.appointmentTime}'
                                              : '${appointment.appointmentDate} • ${appointment.appointmentTime}',
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Gap(5),
                                        Text(
                                          '| ${appointment.appointmentUid}',
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Colors.grey,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => _handleAppointmentTap(
                                    context,
                                    appointment,
                                    appointmentController,
                                    doctorEConsultBloc),
                                icon: const Icon(Icons.arrow_forward_ios),
                                iconSize: 15,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
