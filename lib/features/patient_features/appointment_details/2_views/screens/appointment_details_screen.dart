import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart'
    as appointment_bloc;
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/screens/view_states/appointment_details_initial_screen.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/screens/view_states/appointment_details_status_screen.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/screens/view_states/review_rescheduled_appointment.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/cancel_appointment_widgets/cancellation_success_modal.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreenProvider extends StatelessWidget {
  const AppointmentDetailsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppointmentDetailsBloc>(
      create: (context) {
        final appointmentDetailsBloc = sl<AppointmentDetailsBloc>();

        appointmentDetailsBloc.add(NavigateToAppointmentDetailsStatusEvent());
        debugPrint('Navigating to Appointment Details Status Screen');

        return appointmentDetailsBloc;
      },
      child: const AppointmentDetailsScreen(),
    );
  }
}

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppointmentController appointmentController =
        sl<AppointmentController>();
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Appointment Details',
        leading: appointment_bloc.isFromAppointmentTabs
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      floatingActionButton:
          BlocBuilder<AppointmentDetailsBloc, AppointmentDetailsState>(
        builder: (context, state) {
          if (state is AppointmentDetailsStatusState) {
            return FloatingActionButton(
              onPressed: () async {
                debugPrint('FloatingActionButton pressed');
                final appointmentUid = state.appointment.appointmentUid;
                if (appointmentUid != null) {
                  debugPrint(
                      'Fetching appointment details for UID: $appointmentUid');
                  final appointment = await appointmentController
                      .getAppointmentDetailsNew(appointmentUid);
                  if (appointment != null) {
                    final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
                    final DateFormat timeFormat = DateFormat('hh:mm a');
                    final DateTime now = DateTime.now();

                    final DateTime appointmentDate =
                        dateFormat.parse(appointment.appointmentDate!.trim());
                    final List<String> times =
                        appointment.appointmentTime!.split(' - ');
                    final DateTime endTime = timeFormat.parse(times[1].trim());

                    final DateTime appointmentEndDateTime = DateTime(
                      appointmentDate.year,
                      appointmentDate.month,
                      appointmentDate.day,
                      endTime.hour,
                      endTime.minute,
                    );

                    debugPrint('Current time: $now');
                    debugPrint('Appointment end time: $appointmentEndDateTime');

                    if (now.isBefore(appointmentEndDateTime)) {
                      debugPrint(
                          'Marking appointment as visited for UID: $appointmentUid');
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

                appointment_bloc.isFromConsultationHistory = false;
                if (context.mounted) {
                  Navigator.pushNamed(context, '/consultation');
                }
              },
              child: const Icon(MingCute.message_3_fill),
            );
          }
          return Container();
        },
      ),
      body: BlocConsumer<AppointmentDetailsBloc, AppointmentDetailsState>(
        listenWhen: (previous, current) =>
            current is AppointmentDetailsActionState,
        buildWhen: (previous, current) =>
            current is! AppointmentDetailsActionState,
        listener: (context, state) {
          if (state is CancelAppointmentState) {
            showCancellationSuccessDialog(context)
                .then((value) => Navigator.pop(context));
          } else if (state is CancelAppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          } else if (state is NavigateToReviewRescheduledAppointmentState) {
            debugPrint(
                "State received, navigating to ReviewRescheduledAppointmentScreen");
            // Navigate to the new screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ReviewRescheduledAppointmentScreen(
                    doctorDetails: state.doctor,
                    currentPatient: state.patient,
                    appointmentModel: state.appointment,
                  );
                },
              ),
            );
          } else if (state is CancelAppointmentLoading) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 200,
                    width: 300,
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomLoadingIndicator(),
                        const Gap(30),
                        Text(
                          'Cancelling Appointment...',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).then((value) => Navigator.pop(context));
          }
        },
        builder: (context, state) {
          debugPrint('State being built: $state');
          if (state is AppointmentDetailsStatusState) {
            final appointment = state.appointment;
            if (appointment.appointmentUid == null) {
              return const AppointmentDetailsInitialScreen();
            }

// Safe null checks
            final doctor = doctorDetails;
            final patient = currentActivePatient;

            if (doctor == null || patient == null) {
              return const Center(
                child: Text('Missing doctor or patient information'),
              );
            }

            return AppointmentDetailsStatusScreen(
              doctorDetails: doctor,
              appointment: appointment,
              currentPatient: patient,
            );
          } else if (state is AppointmentDetailsLoading) {
            return const Center(
              child: CustomLoadingIndicator(),
            );
          } else if (state is AppointmentDetailsError) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is NavigateToReviewRescheduledAppointmentState) {
            debugPrint(
                'Navigating to Review Rescheduled Appointment Screen $state');
            return ReviewRescheduledAppointmentScreen(
              doctorDetails: state.doctor,
              currentPatient: state.patient,
              appointmentModel: state.appointment,
            );
          }
          return Container();
        },
      ),
    );
  }
}
