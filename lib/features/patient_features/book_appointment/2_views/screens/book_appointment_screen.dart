import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/bloc/appointment_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/screens/view_states/book_appointment_initial_screen.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/screens/view_states/review_appointment_initial_screen.dart';

class BookAppointmentScreenProvider extends StatelessWidget {
  const BookAppointmentScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorModel doctor =
        ModalRoute.of(context)?.settings.arguments as DoctorModel;
    return BlocProvider<BookAppointmentBloc>(
      create: (context) {
        final bookAppointmentBloc = sl<BookAppointmentBloc>();
        bookAppointmentBloc.add(GetDoctorAvailabilityEvent(
          doctorId: doctor.uid,
          // doctorId: doctorDetails!.uid,
        ));
        return bookAppointmentBloc;
      },
      child: BookAppointmentScreen(
        doctor: doctor,
      ),
    );
  }
}

class BookAppointmentScreen extends StatelessWidget {
  final DoctorModel doctor;
  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    // final DoctorModel doctor =
    //     ModalRoute.of(context)?.settings.arguments as DoctorModel;

    return BlocBuilder<BookAppointmentBloc, BookAppointmentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaPatientAppBar(
            leading: isFromAppointmentTabs
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                : isRescheduleMode == true
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/bottomNavigation',
                            arguments: {'initialIndex': 2},
                          );
                          isRescheduleMode = false;
                        },
                      )
                    : null,
            title: state is ReviewAppointmentState
                ? 'Review Appointment'
                : isRescheduleMode == true
                    ? 'Reschedule Appointment'
                    : 'Book Appointment',
          ),
          body: BlocConsumer<BookAppointmentBloc, BookAppointmentState>(
            listenWhen: (previous, current) =>
                current is BookAppointmentActionState,
            buildWhen: (previous, current) =>
                current is! BookAppointmentActionState,
            listener: (context, state) {
              if (state is BookAppointmentRequestLoading) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.of(context).pop();
                    });
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: GinaAppTheme.appbarColorLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 200,
                        width: 200,
                        padding: const EdgeInsets.all(15.0),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomLoadingIndicator(),
                            Gap(30),
                            Text(
                              'Requesting Appointment...',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
            builder: (context, state) {
              if (state is GetDoctorAvailabilityLoading) {
                return const Center(child: CustomLoadingIndicator());
              } else if (state is GetDoctorAvailabilityError) {
                return Center(child: Text(state.errorMessage));
              } else if (state is GetDoctorAvailabilityLoaded) {
                final doctorAvailabilityModel = state.doctorAvailabilityModel;
                return BookAppointmentInitialScreen(
                  doctorAvailabilityModel: doctorAvailabilityModel,
                  doctor: doctor,
                );
              } else if (state is BookAppointmentLoading) {
                return const Center(child: CustomLoadingIndicator());
              } else if (state is BookAppointmentError) {
                return Center(child: Text(state.errorMessage));
              } else if (state is ReviewAppointmentState) {
                final appointmentModel = state.appointmentModel;
                return ReviewAppointmentInitialScreen(
                  doctorDetails: doctor,
                  currentPatient: currentActivePatient!,
                  appointmentModel: appointmentModel,
                );
              }
              return Container();
            },
          ),
        );
      },
    );
  }
}
