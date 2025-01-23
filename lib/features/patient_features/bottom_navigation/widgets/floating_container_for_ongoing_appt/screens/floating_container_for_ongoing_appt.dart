import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/floating_container_for_ongoing_appt/bloc/floating_container_for_ongoing_appt_bloc.dart';
import 'package:intl/intl.dart';

class FloatingContainerForOnGoingAppointmentProvider extends StatelessWidget {
  const FloatingContainerForOnGoingAppointmentProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FloatingContainerForOngoingApptBloc>(
      create: (context) => sl<FloatingContainerForOngoingApptBloc>()
        ..add(
            CheckOngoingAppointments()), // Trigger the check for ongoing appointments
      child: const FloatingContainerForOnGoingAppointment(),
    );
  }
}

class FloatingContainerForOnGoingAppointment extends StatelessWidget {
  const FloatingContainerForOnGoingAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<FloatingContainerForOngoingApptBloc,
        FloatingContainerForOngoingApptState>(
      builder: (context, state) {
        if (state is FloatingContainerForOngoingApptLoading) {
          return const Center(child: CustomLoadingIndicator());
        } else if (state is NoOngoingAppointments) {
          return const SizedBox();
          // return const Center(child: Text('No ongoing appointments'));
        } else if (state is OngoingAppointmentFound) {
          final appointment = state.ongoingAppointment;

          return Positioned(
            bottom: 100, // Adjust the position as needed
            left: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                // Navigate to the ongoing appointment screen
              },
              child: Container(
                width: size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: GinaAppTheme.lightOutline.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 43,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: GinaAppTheme.appbarColorLight,
                                  width: 3.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 23,
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
                                color: GinaAppTheme.appbarColorLight,
                                width: 3.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.transparent,
                              foregroundImage:
                                  AssetImage(Images.doctorProfileIcon1),
                            ),
                          ),
                        ],
                      ),
                      const Gap(50),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.modeOfAppointment == 0
                                      ? 'Ongoing Online Consultation'
                                      : 'Ongoing Face-to-Face Consultation',
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
                              ],
                            ),
                          ),
                          const Gap(2),
                          SizedBox(
                            width: size.width * 0.5,
                            child: Text(
                              '${appointment.appointmentDate} • ${appointment.appointmentTime}',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward_ios),
                        iconSize: 15,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is OngoingAppointmentError) {
          return const Center(
              child: Text('Error loading ongoing appointments'));
        }

        // Default fallback
        return const SizedBox();
      },
    );
  }
}
