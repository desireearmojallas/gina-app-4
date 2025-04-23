import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/bloc/approved_request_state_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class ApprovedRequestStateScreenLoaded extends StatelessWidget {
  final Map<DateTime, List<AppointmentModel>> approvedRequests;
  final bool? isFromHomeScreen;
  const ApprovedRequestStateScreenLoaded({
    super.key,
    required this.approvedRequests,
    this.isFromHomeScreen,
  });

  // Helper method to categorize by time ranges
  Map<String, List<AppointmentModel>> _categorizeByTimeRange(
      List<AppointmentModel> appointments) {
    final Map<String, List<AppointmentModel>> timeRanges = {};

    // Sort appointments by time (latest to earliest)
    appointments.sort((a, b) {
      final timeA = a.appointmentTime ?? '';
      final timeB = b.appointmentTime ?? '';

      // Extract start time for sorting (assuming format "H:MM AM/PM - H:MM AM/PM")
      final startA = timeA.split(' - ').first;
      final startB = timeB.split(' - ').first;

      try {
        final parsedA = DateFormat('h:mm a').parse(startA);
        final parsedB = DateFormat('h:mm a').parse(startB);
        return parsedA
            .compareTo(parsedB); // Reversed comparison for descending order
      } catch (e) {
        return startA.compareTo(startB); // Reversed for descending order
      }
    });

    // Group by time range
    for (var appointment in appointments) {
      final timeRange = appointment.appointmentTime ?? 'Time not specified';
      if (!timeRanges.containsKey(timeRange)) {
        timeRanges[timeRange] = [];
      }
      timeRanges[timeRange]!.add(appointment);
    }

    return timeRanges;
  }

  @override
  Widget build(BuildContext context) {
    final approvedRequestBloc = context.read<ApprovedRequestStateBloc>();
    var dates = approvedRequests.keys.toList();
    // Sort dates in descending order (latest to earliest)
    dates.sort((a, b) => a.compareTo(b));

    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () {
        approvedRequestBloc.add(
          ApprovedRequestStateInitialEvent(),
        );
        return Future.value();
      },
      child: ScrollbarCustom(
        child: approvedRequests.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No approved requests',
                      style: ginaTheme.textTheme.titleSmall?.copyWith(
                        color: GinaAppTheme.lightOutline,
                      ),
                    ),
                    const Gap(150),
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: approvedRequests.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final requestsOnDate = approvedRequests[date]!;
                  final timeRanges = _categorizeByTimeRange(requestsOnDate);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 15.0,
                          bottom: 5.0,
                        ),
                        child: Text(
                          DateFormat('MMMM d, yyyy - EEEE').format(date),
                          style: const TextStyle(
                            color: GinaAppTheme.lightOutline,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SF UI Display",
                          ),
                        ),
                      ),

                      // Time ranges for this date
                      ...timeRanges.entries.map((entry) {
                        final timeRange = entry.key;
                        final appointmentsInRange = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Time range header
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25.0,
                                top: 10.0,
                                bottom: 5.0,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.watch_later_outlined,
                                    size: 14,
                                    color: GinaAppTheme.lightSecondary,
                                  ),
                                  const Gap(5),
                                  Text(
                                    timeRange,
                                    style: const TextStyle(
                                      color: GinaAppTheme.lightSecondary,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "SF UI Display",
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Appointments in this time range
                            ...appointmentsInRange.map(
                              (request) => GestureDetector(
                                onTap: () {
                                  approvedRequestBloc.add(
                                    NavigateToApprovedRequestDetailEvent(
                                      appointment: request,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: size.height * 0.14,
                                  width: size.width / 1.05,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: GinaAppTheme.lightOnTertiary,
                                    boxShadow: [
                                      GinaAppTheme.defaultBoxShadow,
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CircleAvatar(
                                          radius: 37,
                                          backgroundImage: AssetImage(
                                            Images.patientProfileIcon,
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Appt. ID: ${request.appointmentUid!}',
                                              style: ginaTheme
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                color:
                                                    GinaAppTheme.lightOutline,
                                                fontSize: 8,
                                              ),
                                            ),
                                            const Gap(3),
                                            Text(
                                              request.patientName ?? "",
                                              style: ginaTheme
                                                  .textTheme.titleSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Gap(3),
                                            Text(
                                              request.modeOfAppointment ==
                                                      ModeOfAppointmentId
                                                          .onlineConsultation
                                                          .index
                                                  ? 'Online Consultation'
                                                      .toUpperCase()
                                                  : 'Face-to-face Consultation'
                                                      .toUpperCase(),
                                              style: ginaTheme
                                                  .textTheme.labelSmall
                                                  ?.copyWith(
                                                color: GinaAppTheme
                                                    .lightTertiaryContainer,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Gap(5),
                                            Text(
                                              '${request.appointmentDate} | ${request.appointmentTime}',
                                              style: ginaTheme
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                color:
                                                    GinaAppTheme.lightOutline,
                                                fontSize: 8,
                                              ),
                                            ),
                                            const Gap(8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: GinaAppTheme
                                                    .lightSurfaceVariant
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: GinaAppTheme
                                                      .lightSurfaceVariant,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.notes_rounded,
                                                    size: 12,
                                                    color: GinaAppTheme
                                                        .lightOutline,
                                                  ),
                                                  const Gap(4),
                                                  Expanded(
                                                    child: Text(
                                                      request.reasonForAppointment ??
                                                          'Not specified',
                                                      style: ginaTheme
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                        color: GinaAppTheme
                                                            .lightOnBackground
                                                            .withOpacity(0.7),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AppointmentStatusContainer(
                                              appointmentStatus:
                                                  request.appointmentStatus!,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const Gap(20),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
