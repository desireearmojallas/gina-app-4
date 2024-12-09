import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/widgets/details_container_navigation.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/widgets/office_address_container.dart';
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
                              onTap: () {},
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
                                          Text(
                                            storeDoctorAvailabilityModel != null
                                                ? doctorAvailabilityBloc
                                                    .getDoctorAvailability(state
                                                        .doctorAvailabilityModel)
                                                : '',
                                            style: valueStyle,
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
                                                    state
                                                        .doctorAvailabilityModel
                                                        .startTimes
                                                        .length, (index) {
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
                                                }),
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
                                                    state
                                                        .doctorAvailabilityModel
                                                        .startTimes
                                                        .length, (index) {
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
                                                      .shrink(); // Return an empty widget if it's not in the afternoon
                                                }),
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
                                              'MODE OF\nAPPOINTMENT',
                                              style: labelStyle,
                                            ),
                                          ),
                                          const Gap(35),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: context
                                                .read<DoctorAvailabilityBloc>()
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
                            onPressed: () {},
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
