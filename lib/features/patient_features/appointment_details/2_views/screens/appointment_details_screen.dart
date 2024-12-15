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
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

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
              onPressed: () {
                appointment_bloc.isFromConsultationHistory = false;
                Navigator.pushNamed(context, '/consultation');
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
          if (state is AppointmentDetailsStatusState) {
            final appointment = state.appointment;
            return appointment.appointmentUid == null
                ? const AppointmentDetailsInitialScreen()
                : AppointmentDetailsStatusScreen(
                    doctorDetails: doctorDetails!,
                    appointment: appointment,
                    currentPatient: currentActivePatient!,
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
