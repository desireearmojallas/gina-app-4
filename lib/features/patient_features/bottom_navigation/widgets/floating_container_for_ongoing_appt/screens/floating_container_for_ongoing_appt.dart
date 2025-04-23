import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/floating_container_for_ongoing_appt/bloc/floating_container_for_ongoing_appt_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:intl/intl.dart';

// Replace this class completely
class FloatingContainerForOnGoingAppointmentProvider extends StatelessWidget {
  const FloatingContainerForOnGoingAppointmentProvider({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('💬 FLOATING PROVIDER: Building provider widget');

    // Use BlocBuilder instead of creating a new BlocProvider
    // This will use the existing bloc from the parent widget
    return BlocBuilder<FloatingContainerForOngoingApptBloc,
        FloatingContainerForOngoingApptState>(
      builder: (context, state) {
        debugPrint(
            '💬 FLOATING PROVIDER: Inside BlocBuilder with state: ${state.runtimeType}');

        if (state is OngoingAppointmentFound) {
          final appointment = state.ongoingAppointment;
          debugPrint(
              '💬 FLOATING PROVIDER: Rendering container for ${appointment.appointmentUid}');

          // Use your existing container component
          return const FloatingContainerForOnGoingAppointment();
        }

        debugPrint('💬 FLOATING PROVIDER: No appointment to display');
        return const SizedBox.shrink();
      },
    );
  }
}

class FloatingContainerForOnGoingAppointment extends StatelessWidget {
  const FloatingContainerForOnGoingAppointment({super.key});

  Future<void> _handleAppointmentTap(
      BuildContext context,
      AppointmentModel appointment,
      AppointmentController appointmentController,
      AppointmentBloc appointmentsBloc) async {
    HapticFeedback.mediumImpact();

    final appointmentUid = appointment.appointmentUid;
    final doctorUid = appointment.doctorUid;

    if (appointmentUid != null) {
      debugPrint('Fetching appointment details for UID: $appointmentUid');
      final appointmentDetails =
          await appointmentController.getAppointmentDetailsNew(appointmentUid);
      if (appointmentDetails != null) {
        // Add payment verification here
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
                  'Please complete the payment for this appointment before accessing the consultation room.',
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

        // Continue with the existing code for time verification
        final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
        final DateFormat timeFormat = DateFormat('hh:mm a');
        final DateTime now = DateTime.now();

        final DateTime appointmentDate =
            dateFormat.parse(appointmentDetails.appointmentDate!.trim());
        final List<String> times =
            appointmentDetails.appointmentTime!.split(' - ');
        final DateTime endTime = timeFormat.parse(times[1].trim());

        final DateTime appointmentEndDateTime = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          endTime.hour,
          endTime.minute,
        );

        if (now.isBefore(appointmentEndDateTime)) {
          debugPrint('Marking appointment as visited for UID: $appointmentUid');
          await appointmentController
              .markAsVisitedConsultationRoom(appointmentUid);
        } else {
          debugPrint('Appointment has already ended.');
        }
      } else {
        debugPrint('Appointment not found.');
      }
    } else {
      debugPrint('Appointment UID is null.');
    }

    if (doctorUid != null) {
      final getDoctorDetailsResult =
          await appointmentController.getDoctorDetail(
        doctorUid: doctorUid,
      );

      getDoctorDetailsResult.fold(
        (failure) {
          debugPrint('Failed to fetch doctor details: $failure');
        },
        (doctorDetailsData) {
          doctorDetails = doctorDetailsData;
        },
      );
    } else {
      debugPrint('Doctor UID is null.');
    }

    isFromConsultationHistory = false;
    if (context.mounted) {
      Navigator.pushNamed(
        context,
        '/consultation',
        arguments: {
          'doctorDetails': doctorDetails,
          'appointment': appointment,
        },
      ).then((_) {
        Navigator.pushNamed(
          context,
          '/bottomNavigation',
          arguments: {
            'initialIndex': 2,
            'appointmentTabIndex': 3,
          },
        );
      });
    }
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

  // Replace the build method in FloatingContainerForOnGoingAppointment class
  @override
  Widget build(BuildContext context) {
    final appointmentsBloc = context.read<AppointmentBloc>();
    final AppointmentController appointmentController = AppointmentController();

    return BlocBuilder<FloatingContainerForOngoingApptBloc,
        FloatingContainerForOngoingApptState>(
      builder: (context, state) {
        if (state is FloatingContainerForOngoingApptLoading) {
          return const Center(child: CustomLoadingIndicator());
        } else if (state is NoOngoingAppointments) {
          return const SizedBox();
        } else if (state is OngoingAppointmentFound) {
          final appointment = state.ongoingAppointment;

          // Replace the problematic Stack with a Container
          return GestureDetector(
            onTap: () => _handleAppointmentTap(
                context, appointment, appointmentController, appointmentsBloc),
            child: Container(
              width: double.infinity, // Use full width given by parent
              height: 60,
              margin: const EdgeInsets.only(bottom: 12.0),
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
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    // Avatar stack
                    SizedBox(
                      width: 60,
                      height: 44,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 30,
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
                                foregroundImage:
                                    AssetImage(Images.patientProfileIcon),
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
                                  AssetImage(Images.doctorProfileIcon1),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(30),

                    // Text content
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isWithinTimeRange(appointment.appointmentDate!,
                                    appointment.appointmentTime!)
                                ? 'Ongoing ${appointment.modeOfAppointment == 0 ? 'Online' : 'Face-to-Face'} Consultation'
                                : 'Upcoming ${appointment.modeOfAppointment == 0 ? 'Online' : 'Face-to-Face'} Consultation',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'with Dr. ${appointment.doctorName}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
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
                        ],
                      ),
                    ),

                    // Arrow icon
                    IconButton(
                      onPressed: () => _handleAppointmentTap(context,
                          appointment, appointmentController, appointmentsBloc),
                      icon: const Icon(Icons.arrow_forward_ios),
                      iconSize: 15,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
