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

class DoctorEmergencyAnnouncementPatientList extends StatelessWidget {
  final Map<DateTime, List<AppointmentModel>> approvedPatients;
  const DoctorEmergencyAnnouncementPatientList({
    super.key,
    required this.approvedPatients,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    var dates = approvedPatients.keys.toList();
    final doctorUpcomingAppointmentBloc =
        context.read<DoctorUpcomingAppointmentsBloc>();
    final emergencyAnnouncementsBloc =
        context.read<DoctorEmergencyAnnouncementsBloc>();

    return ScrollbarCustom(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        itemCount: approvedPatients.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final appointments = approvedPatients[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  doctorUpcomingAppointmentBloc.isToday(date)
                      ? "Today - ${DateFormat('MMMM d, EEEE').format(date)}"
                      : DateFormat('MMMM d, EEEE').format(date),
                  style: const TextStyle(
                    color: GinaAppTheme.lightOutline,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
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
              ...appointments.map(
                (appointment) => InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashFactory: InkRipple.splashFactory,
                  splashColor: GinaAppTheme.lightTertiaryContainer,
                  onTap: () {
                    emergencyAnnouncementsBloc.add(SelectPatientEvent(
                      appointment: appointment,
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: GinaAppTheme.appbarColorLight,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  width: size.width * 0.4,
                                  child: Expanded(
                                    child: Text(
                                      appointment.patientName ?? '',
                                      style: ginaTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      appointment.appointmentDate ?? '',
                                      style: ginaTheme.bodySmall?.copyWith(
                                        color:
                                            GinaAppTheme.lightTertiaryContainer,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Gap(5),
                                    Text(
                                      appointment.appointmentTime ?? '',
                                      style: ginaTheme.bodySmall?.copyWith(
                                        color: GinaAppTheme.lightOutline,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    const Gap(10),
                                  ],
                                ),
                              ],
                            ),
                            const Gap(15),
                            Row(
                              children: [
                                Text(
                                  appointment.modeOfAppointment == 0
                                      ? 'Online Consultation'.toUpperCase()
                                      : 'Face-to-face Consultation'
                                          .toUpperCase(),
                                  style: ginaTheme.bodySmall?.copyWith(
                                    color: GinaAppTheme.lightTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                const Spacer(),
                                AppointmentStatusContainer(
                                  appointmentStatus:
                                      appointment.appointmentStatus,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
