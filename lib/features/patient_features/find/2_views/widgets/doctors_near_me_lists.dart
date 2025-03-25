import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/doctor_rating_badge/doctor_rating_badge.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/2_views/bloc/doctor_availability_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/1_controllers/find_controllers.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorsNearMe extends StatelessWidget {
  final List<DoctorModel> doctorLists;
  const DoctorsNearMe({super.key, required this.doctorLists});

  @override
  Widget build(BuildContext context) {
    final findBloc = context.read<FindBloc>();
    final doctorAvailabilityBloc = context.read<DoctorAvailabilityBloc>();
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    final findController = FindController();

    return GestureDetector(
      onTap: () {},
      child: doctorLists.isEmpty
          ? const SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  'No doctors found',
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: doctorLists.length,
              itemBuilder: (context, index) {
                final doctor = doctorLists[index];
                final distance = findController
                    .calculateDistanceToDoctor(doctor.officeLatLngAddress);
                return BlocProvider(
                  create: (context) => sl<DoctorAvailabilityBloc>()
                    ..add(GetDoctorAvailabilityEvent(doctorId: doctor.uid)),
                  child: BlocBuilder<DoctorAvailabilityBloc,
                      DoctorAvailabilityState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            findBloc.add(FindNavigateToDoctorDetailsEvent(
                              doctor: doctor,
                            ));
                          },
                          child: Container(
                            width: width / 1.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                GinaAppTheme.defaultBoxShadow,
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: AssetImage(
                                          Images.doctorProfileIcon2,
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DoctorRatingBadge(
                                            doctorRating: doctor.doctorRatingId,
                                          ),
                                          const Gap(5),
                                          Row(
                                            children: [
                                              Text(
                                                'Dr. ${doctor.name}',
                                                style: ginaTheme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Gap(8),
                                              const Icon(
                                                Bootstrap.patch_check_fill,
                                                color: Colors.blue,
                                                size: 12,
                                              ),
                                            ],
                                          ),
                                          const Gap(10),
                                          Container(
                                            height: 19,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0xffF2F2F2),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Center(
                                                child: Text(
                                                  doctor.medicalSpecialty
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    color: GinaAppTheme
                                                        .lightInverseSurface,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        Images.officeAddressLogo,
                                        width: 20,
                                      ),
                                      const Gap(12),
                                      SizedBox(
                                        width: width / 1.4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$distance km away',
                                              style: ginaTheme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                color:
                                                    GinaAppTheme.lightOutline,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            const Gap(2),
                                            Text(
                                              doctor.officeAddress,
                                              style: const TextStyle(
                                                color: GinaAppTheme
                                                    .lightInverseSurface,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.visible,
                                            ),
                                            const Gap(2),
                                            Text(
                                              doctor.officeMapsLocationAddress,
                                              style: TextStyle(
                                                color: GinaAppTheme
                                                    .lightInverseSurface
                                                    .withOpacity(0.6),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                BlocBuilder<DoctorAvailabilityBloc,
                                    DoctorAvailabilityState>(
                                  builder: (context, state) {
                                    if (state is DoctorAvailabilityLoaded) {
                                      Map<int, String> dayNames = {
                                        0: 'Sunday',
                                        1: 'Monday',
                                        2: 'Tuesday',
                                        3: 'Wednesday',
                                        4: 'Thursday',
                                        5: 'Friday',
                                        6: 'Saturday',
                                      };
                                      final doctorAvailability =
                                          state.doctorAvailabilityModel;
                                      final List<int> sortedDays =
                                          List.from(doctorAvailability.days)
                                            ..sort();

                                      if (sortedDays.isEmpty) {
                                        return const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'No schedule available',
                                              style: TextStyle(
                                                color:
                                                    GinaAppTheme.lightOutline,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      List<List<int>> groupedDays = [];
                                      List<int> currentRange = [
                                        sortedDays.first
                                      ];

                                      for (int i = 1;
                                          i < sortedDays.length;
                                          i++) {
                                        if (sortedDays[i] ==
                                            sortedDays[i - 1] + 1) {
                                          currentRange.add(sortedDays[i]);
                                        } else {
                                          groupedDays.add(currentRange);
                                          currentRange = [sortedDays[i]];
                                        }
                                      }

                                      groupedDays.add(currentRange);

                                      List<String> formattedRanges =
                                          groupedDays.map((range) {
                                        if (range.length > 1) {
                                          return '${dayNames[range.first]}-${dayNames[range.last]}';
                                        } else {
                                          return dayNames[range.first]!;
                                        }
                                      }).toList();

                                      String scheduleText =
                                          formattedRanges.join(', ');

                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Consultation Availability',
                                                style: ginaTheme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const Gap(5),
                                            if (doctorAvailabilityBloc
                                                .getModeOfAppointment(state
                                                    .doctorAvailabilityModel)
                                                .isEmpty)
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'No schedule available',
                                                  style: TextStyle(
                                                    color: GinaAppTheme
                                                        .lightOutline,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: doctorAvailabilityBloc
                                                  .getModeOfAppointment(state
                                                      .doctorAvailabilityModel)
                                                  .map((mode) => Row(
                                                        children: [
                                                          const Icon(
                                                            MingCute.round_fill,
                                                            size: 8,
                                                            color: GinaAppTheme
                                                                .lightTertiaryContainer,
                                                          ),
                                                          const Gap(5),
                                                          Text(
                                                            mode,
                                                            style: ginaTheme
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11.0,
                                                            ),
                                                          ),
                                                          const Gap(10),
                                                        ],
                                                      ))
                                                  .toList(),
                                            ),
                                            const Gap(25),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Bootstrap.calendar_fill,
                                                  size: 15,
                                                  color: GinaAppTheme
                                                      .lightTertiaryContainer,
                                                ),
                                                const Gap(10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      scheduleText,
                                                      style: ginaTheme
                                                          .textTheme.titleSmall
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //isRescheduleMode = false;
                                        Navigator.pushNamed(
                                          context,
                                          '/bookAppointment',
                                          arguments: doctor,
                                        );
                                      },
                                      child: Container(
                                        width: width / 2.21,
                                        decoration: BoxDecoration(
                                          color: GinaAppTheme.lightPrimaryColor
                                              .withOpacity(0),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomLeft: Radius.circular(8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: Text(
                                              'Book Doctor',
                                              style: ginaTheme
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: GinaAppTheme
                                                    .lightOnPrimaryColor,
                                                fontWeight: FontWeight.w700,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationThickness: 0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        findBloc.add(
                                            FindNavigateToDoctorDetailsEvent(
                                          doctor: doctor,
                                        ));
                                      },
                                      child: Container(
                                        width: width / 2.21,
                                        decoration: const BoxDecoration(
                                          color: GinaAppTheme
                                              .lightTertiaryContainer,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: Text(
                                              'View Profile',
                                              style: ginaTheme
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
