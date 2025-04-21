import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/bloc/doctor_emergency_announcements_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class DoctorEmergencyAnnouncementPatientList extends StatefulWidget {
  final Map<DateTime, List<AppointmentModel>> approvedPatients;

  const DoctorEmergencyAnnouncementPatientList({
    super.key,
    required this.approvedPatients,
  });

  @override
  State<DoctorEmergencyAnnouncementPatientList> createState() =>
      _DoctorEmergencyAnnouncementPatientListState();
}

class _DoctorEmergencyAnnouncementPatientListState
    extends State<DoctorEmergencyAnnouncementPatientList> {
  // Local set to track selected appointments
  final Set<AppointmentModel> _selectedAppointments = {};

  @override
  void initState() {
    super.initState();
    // Initialize selection from the bloc state if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<DoctorEmergencyAnnouncementsBloc>().state;
      if (state is SelectedPatientsState) {
        setState(() {
          _selectedAppointments.addAll(state.selectedAppointments);
        });
      }
    });
  }

  // Handle checkbox toggle
  void _toggleSelection(AppointmentModel appointment, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedAppointments.add(appointment);
      } else {
        _selectedAppointments.remove(appointment);
      }
    });
  }

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
        return parsedB
            .compareTo(parsedA); // Reversed comparison for descending order
      } catch (e) {
        return startB.compareTo(startA); // Reversed for descending order
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
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    var dates = widget.approvedPatients.keys.toList();

    // Sort dates in descending order (latest to earliest)
    dates.sort((a, b) => b.compareTo(a));

    final doctorUpcomingAppointmentBloc =
        context.read<DoctorUpcomingAppointmentsBloc>();

    return Scaffold(
      body: widget.approvedPatients.isEmpty
          ? const Center(
              child: Text(
                'No patients',
                style: TextStyle(
                  color: GinaAppTheme.lightOutline,
                ),
              ),
            )
          : ScrollbarCustom(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                itemCount: widget.approvedPatients.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final appointments = widget.approvedPatients[date]!;
                  final timeRanges = _categorizeByTimeRange(appointments);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          doctorUpcomingAppointmentBloc.isToday(date)
                              ? "Today - ${DateFormat('MMMM d, EEEE').format(date)}"
                              : DateFormat('MMMM d, yyy - EEEE').format(date),
                          style: const TextStyle(
                            color: GinaAppTheme.lightOutline,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Gap(2),

                      if (doctorUpcomingAppointmentBloc.isToday(date) &&
                          appointments.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 30.0),
                            child: Text(
                              'No patients for today'.toUpperCase(),
                              style: const TextStyle(
                                color: GinaAppTheme.lightTertiaryContainer,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      // Display appointments grouped by time range
                      ...timeRanges.entries.map((entry) {
                        final timeRange = entry.key;
                        final appointmentsInRange = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Time range header
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
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
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Appointments in this time range
                            ...appointmentsInRange.map(
                              (appointment) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: GinaAppTheme.appbarColorLight,
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage: AssetImage(
                                                Images.patientProfileIcon,
                                              ),
                                            ),
                                            const Gap(15),
                                            SizedBox(
                                              width: size.width * 0.35,
                                              child: Text(
                                                appointment.patientName ?? '',
                                                style: ginaTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                              ),
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  appointment.appointmentDate ??
                                                      '',
                                                  style: ginaTheme.bodySmall
                                                      ?.copyWith(
                                                    color: GinaAppTheme
                                                        .lightOutline,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const Gap(5),
                                                Text(
                                                  appointment.appointmentTime ??
                                                      '',
                                                  style: ginaTheme.bodySmall
                                                      ?.copyWith(
                                                    color: GinaAppTheme
                                                        .lightOutline,
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                                const Gap(10),
                                              ],
                                            ),
                                            // Checkbox for selection
                                            Checkbox(
                                              value: _selectedAppointments
                                                  .contains(appointment),
                                              activeColor: GinaAppTheme
                                                  .lightTertiaryContainer,
                                              onChanged: (bool? value) {
                                                _toggleSelection(appointment,
                                                    value ?? false);
                                              },
                                            ),
                                          ],
                                        ),
                                        const Gap(15),
                                        Row(
                                          children: [
                                            Text(
                                              appointment.modeOfAppointment == 0
                                                  ? 'Online Consultation'
                                                      .toUpperCase()
                                                  : 'Face-to-face Consultation'
                                                      .toUpperCase(),
                                              style:
                                                  ginaTheme.bodySmall?.copyWith(
                                                color: GinaAppTheme
                                                    .lightTertiaryContainer,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                            const Spacer(),
                                            AppointmentStatusContainer(
                                              appointmentStatus: appointment
                                                  .appointmentStatus!,
                                            ),
                                          ],
                                        ),
                                        const Gap(10),
                                        if (appointment.reasonForAppointment !=
                                                null &&
                                            appointment.reasonForAppointment!
                                                .isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
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
                                                  color:
                                                      GinaAppTheme.lightOutline,
                                                ),
                                                const Gap(4),
                                                Expanded(
                                                  child: Text(
                                                    appointment
                                                            .reasonForAppointment ??
                                                        'Not specified',
                                                    style: ginaTheme.bodySmall
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
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
      floatingActionButton: _selectedAppointments.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                debugPrint('✅ FAB pressed - Selection confirmed');
                debugPrint(
                    '📋 Selected patients count: ${_selectedAppointments.length}');

                // Print each selected patient name for debugging
                for (var appointment in _selectedAppointments) {
                  debugPrint(
                      '👤 Selected patient: ${appointment.patientName} (ID: ${appointment.appointmentUid})');
                }

                debugPrint('🔄 Dispatching SelectPatientsEvent');
                context.read<DoctorEmergencyAnnouncementsBloc>().add(
                      SelectPatientsEvent(
                        selectedAppointments: _selectedAppointments.toList(),
                      ),
                    );
              },
              backgroundColor: GinaAppTheme.lightTertiaryContainer,
              child: const Icon(Icons.check_rounded, color: Colors.white),
            )
          : null,
    );
  }
}
