import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class ListOfAllAppointmentsBooked extends StatelessWidget {
  final List<AppointmentModel> appointments;
  const ListOfAllAppointmentsBooked({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: GinaAppTheme.lightScrim,
          thickness: 0.1,
          height: 12,
        ),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          final appointmentDate =
              DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
          final appointmentTimes = appointment.appointmentTime!.split(' - ');
          final appointmentStartTime =
              DateFormat('hh:mm a').parse(appointmentTimes[0]);
          final appointmentEndTime =
              DateFormat('hh:mm a').parse(appointmentTimes[1]);

          final formattedAppointmentDate =
              DateFormat('MMM d, yyyy').format(appointmentDate);
          final formattedAppointmentStartTime =
              DateFormat('h:mm a').format(appointmentStartTime);
          final formattedAppointmentEndTime =
              DateFormat('h:mm a').format(appointmentEndTime);

          return InkWell(
            onTap: () {},
            child: Row(
              children: [
                Row(
                  children: [
                    const Gap(40),
                    SizedBox(
                      width: size.width * 0.09,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          appointment.appointmentUid!,
                          style: ginaTheme.labelMedium,
                        ),
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      width: size.width * 0.1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          appointment.patientName!,
                          style: ginaTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Gap(25),
                    SizedBox(
                      width: size.width * 0.14,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Flexible(
                          child: Row(
                            children: [
                              Text(
                                'Dr. ${appointment.doctorName!}',
                                style: ginaTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(5),
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(25),
                    SizedBox(
                      width: size.width * 0.12,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$formattedAppointmentDate\n$formattedAppointmentStartTime - $formattedAppointmentEndTime',
                          style: ginaTheme.labelMedium,
                          softWrap: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: size.width * 0.16,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            appointment.doctorClinicAddress!,
                            style: ginaTheme.labelMedium,
                          ),
                        ),
                      ),
                    ),
                    const Gap(15),
                    SizedBox(
                      width: size.width * 0.08,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          appointment.modeOfAppointment == 0
                              ? 'Online'
                              : 'Face-to-face',
                          style: ginaTheme.labelMedium,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppointmentStatusContainer(
                          appointmentStatus: appointment.appointmentStatus!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
