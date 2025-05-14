import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/admin_patient_appointment_status.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class AppointmentsHistoryDataList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  const AppointmentsHistoryDataList({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const textStyle = TextStyle(
      color: GinaAppTheme.lightOnPrimaryColor,
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
    );
    return Container(
      height: appointments.length > 3 ? 300 : appointments.length * 80.0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(
          color: GinaAppTheme.lightScrim,
          thickness: 0.2,
          height: 5,
        ),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(65),
                SizedBox(
                  width: size.width * 0.19,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appointment.appointmentUid!,
                      style: textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.12,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appointment.patientName!,
                      style: textStyle,
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.12,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${DateFormat('MM/dd/yyyy').format(DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!))} @ ${appointment.appointmentTime!}',
                      style: textStyle,
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.12,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appointment.doctorClinicAddress!,
                      style: textStyle.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: GinaAppTheme.lightTertiaryContainer,
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: size.width * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appointment.modeOfAppointment == 0
                          ? 'Online'
                          : 'Face-to-Face',
                      style: textStyle,
                    ),
                  ),
                ),
                const Gap(10),
                AdminPatientAppointmentStatusChip(
                  appointmentStatus: appointment.appointmentStatus!,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
