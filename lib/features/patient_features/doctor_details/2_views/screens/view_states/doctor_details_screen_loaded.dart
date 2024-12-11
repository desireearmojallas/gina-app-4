import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/2_views/bloc/doctor_availability_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/widgets/details_container_navigation.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/widgets/office_address_container.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorDetailsScreenLoaded extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorDetailsScreenLoaded({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doctorAvailabilityBloc = context.read<DoctorAvailabilityBloc>();

    return BlocProvider(
      create: (context) => sl<DoctorAvailabilityBloc>()
        ..add(GetDoctorAvailabilityEvent(doctorId: doctor.uid)),
      child: BlocConsumer<DoctorAvailabilityBloc, DoctorAvailabilityState>(
        listenWhen: (previous, current) =>
            current is DoctorAvailabilityActionState,
        buildWhen: (previous, current) =>
            current is! DoctorAvailabilityActionState,
        listener: (context, state) {
          if (state is DoctorAvailabilityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          final size = MediaQuery.of(context).size;
          final ginaTheme = Theme.of(context).textTheme;
          const valueStyle = TextStyle(
            fontSize: 12.0,
          );
          const labelStyle = TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          );

          List<String> formattedRanges = [];
          String scheduleText = '';

          if (state is DoctorAvailabilityLoaded) {
            final doctorAvailability = state.doctorAvailabilityModel;
            final List<int> sortedDays = List.from(doctorAvailability.days)
              ..sort();
            final Map<int, String> dayNames = {
              0: 'Sunday',
              1: 'Monday',
              2: 'Tuesday',
              3: 'Wednesday',
              4: 'Thursday',
              5: 'Friday',
              6: 'Saturday',
            };

            if (sortedDays.isNotEmpty) {
              List<List<int>> groupedDays = [];
              List<int> currentRange = [sortedDays.first];

              for (int i = 1; i < sortedDays.length; i++) {
                if (sortedDays[i] == sortedDays[i - 1] + 1) {
                  currentRange.add(sortedDays[i]);
                } else {
                  groupedDays.add(currentRange);
                  currentRange = [sortedDays[i]];
                }
              }

              groupedDays.add(currentRange);

              formattedRanges = groupedDays.map((range) {
                if (range.length > 1) {
                  return '${dayNames[range.first]}-${dayNames[range.last]}';
                } else {
                  return dayNames[range.first]!;
                }
              }).toList();

              scheduleText = formattedRanges.join(', ');

              if (sortedDays.isEmpty) {
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No schedule available',
                      style: TextStyle(
                        color: GinaAppTheme.lightOutline,
                      ),
                    ),
                  ),
                );
              }
            }
          }

          return ScrollbarCustom(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  doctorNameWidget(size, ginaTheme, doctor),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OfficeAddressContainer(
                          doctor: doctor,
                        ),
                        //const Gap(10),
                        divider(size.width * 0.9),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DetailsContainerNavigation(
                              icon: Icons.monetization_on,
                              containerLabel: 'Consultation Fee\nDetails',
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/consultationFeeDetails',
                                    arguments: doctor);
                              },
                            ),
                            DetailsContainerNavigation(
                              icon: Icons.date_range,
                              containerLabel: 'Appointment\nDetails',
                              onTap: () {},
                            ),
                          ],
                        ),
                        const Gap(18),
                        Text(
                          'Availability'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(10),
                        if (state is DoctorAvailabilityLoading) ...[
                          const Center(
                            child: CustomLoadingIndicator(),
                          ),
                        ] else if (state is DoctorAvailabilityLoaded) ...[
                          IntrinsicHeight(
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        children: [
                                          const DetailedViewIcon(
                                            icon: Icon(
                                              Icons.calendar_today_rounded,
                                              color: GinaAppTheme.lightOutline,
                                              size: 20,
                                            ),
                                          ),
                                          const Gap(20),
                                          SizedBox(
                                            width: size.width * 0.21,
                                            child: const Text(
                                              'OFFICE DAYS',
                                              style: labelStyle,
                                            ),
                                          ),
                                          const Gap(35),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              scheduleText,
                                              style: valueStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    divider(size.width * 0.9),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        children: [
                                          const DetailedViewIcon(
                                            icon: Icon(
                                              MingCute.time_fill,
                                              color: GinaAppTheme.lightOutline,
                                              size: 20,
                                            ),
                                          ),
                                          const Gap(20),
                                          SizedBox(
                                            width: size.width * 0.21,
                                            child: const Text(
                                              'OFFICE HOURS',
                                              style: labelStyle,
                                            ),
                                          ),
                                          const Gap(35),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Morning Section
                                              Text(
                                                'MORNING',
                                                style: valueStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: List.generate(
                                                  state.doctorAvailabilityModel
                                                      .startTimes.length,
                                                  (index) {
                                                    String timeStart = state
                                                        .doctorAvailabilityModel
                                                        .startTimes[index];
                                                    String timeEnd = state
                                                        .doctorAvailabilityModel
                                                        .endTimes[index];

                                                    // Check if the time is in the morning (AM)
                                                    if (timeStart
                                                        .contains('AM')) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Gap(2),
                                                          Text(
                                                            '$timeStart - $timeEnd',
                                                            style: valueStyle,
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return const SizedBox
                                                        .shrink();
                                                  },
                                                ),
                                              ),
                                              const Gap(15),

                                              // Afternoon Section
                                              Text(
                                                'AFTERNOON',
                                                style: valueStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: List.generate(
                                                  state.doctorAvailabilityModel
                                                      .startTimes.length,
                                                  (index) {
                                                    String timeStart = state
                                                        .doctorAvailabilityModel
                                                        .startTimes[index];
                                                    String timeEnd = state
                                                        .doctorAvailabilityModel
                                                        .endTimes[index];

                                                    // Check if the time is in the afternoon (PM)
                                                    if (timeStart
                                                        .contains('PM')) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Gap(2),
                                                          Text(
                                                            '$timeStart - $timeEnd',
                                                            style: valueStyle,
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return const SizedBox
                                                        .shrink();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    divider(size.width * 0.9),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        children: [
                                          const DetailedViewIcon(
                                            icon: Icon(
                                              Icons.assignment_ind,
                                              color: GinaAppTheme.lightOutline,
                                              size: 20,
                                            ),
                                          ),
                                          const Gap(20),
                                          SizedBox(
                                            width: size.width * 0.21,
                                            child: const Text(
                                              'MODE OF APPOINTMENT',
                                              style: labelStyle,
                                            ),
                                          ),
                                          const Gap(35),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: doctorAvailabilityBloc
                                                .getModeOfAppointment(state
                                                    .doctorAvailabilityModel)
                                                .map((mode) => Text(
                                                      mode,
                                                      style: valueStyle,
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else if (state is DoctorAvailabilityError) ...[
                          const Center(
                            child: Text(
                              'Failed to load availability.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ] else ...[
                          const Center(
                            child: Text('Unknown state'),
                          ),
                        ],
                        const Gap(20),
                        SizedBox(
                          width: size.width * 0.93,
                          height: size.height / 17,
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              //isRescheduleMode = false;
                              Navigator.pushNamed(
                                context,
                                '/bookAppointment',
                                arguments: doctor,
                              );
                            },
                            child: Text(
                              'Book Appointment',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget divider(width) {
    return Column(
      children: [
        const Gap(10),
        SizedBox(
          width: width,
          child: const Divider(
            color: GinaAppTheme.lightOutline,
            thickness: 0.3,
          ),
        ),
        const Gap(10),
      ],
    );
  }
}
