import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/admin_patient_appointment_status.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class PatientConsultationHistoryList extends StatelessWidget {
  // final int appointmentStatus;
  final List<AppointmentModel> appointmentDetails;

  const PatientConsultationHistoryList({
    super.key,
    // required this.appointmentStatus,
    required this.appointmentDetails,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const textStyle = TextStyle(
      color: GinaAppTheme.lightOnPrimaryColor,
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
    );
    return Expanded(
      child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
                color: GinaAppTheme.lightScrim,
                thickness: 0.2,
                height: 5,
              ),
          itemCount: appointmentDetails.length,
          itemBuilder: (context, index) {
            final appointment = appointmentDetails[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(65),
                  SizedBox(
                    width: size.width * 0.09,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        appointment.appointmentUid!,
                        style: textStyle,
                        softWrap: true,
                      ),
                    ),
                  ),
                  // const Gap(10),
                  SizedBox(
                    width: size.width * 0.15,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Dr. ${appointment.doctorName}',
                              style: textStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const Gap(5),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(35),
                  SizedBox(
                    width: size.width * 0.09,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        appointment.appointmentDate!,
                        style: textStyle,
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
                        appointment.appointmentTime!,
                        style: textStyle,
                        softWrap: true,
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    width: size.width * 0.15,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        appointment.doctorClinicAddress!,
                        style: textStyle,
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    width: size.width * 0.095,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        appointment.modeOfAppointment == 0
                            ? 'Online'
                            : 'Face-to-Face',
                        style: textStyle,
                      ),
                    ),
                  ),
                  const Gap(10),

                  //TODO: TO FIX THIS APPOINTMENT STATUS WHEN AN APPOINTMENT HAS BEEN MADE
                  SizedBox(
                    width: size.width * 0.06,
                    child: Align(
                      alignment: Alignment.center,
                      child: AdminPatientAppointmentStatusChip(
                        appointmentStatus: appointment.appointmentStatus!,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
