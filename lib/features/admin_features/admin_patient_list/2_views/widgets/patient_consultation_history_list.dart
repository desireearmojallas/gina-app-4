import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/admin_patient_appointment_status.dart';

class PatientConsultationHistoryList extends StatelessWidget {
  final int appointmentStatus;

  const PatientConsultationHistoryList({
    super.key,
    required this.appointmentStatus,
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
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(65),
                  SizedBox(
                    width: size.width * 0.09,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '20230910221545C',
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
                          Expanded(
                            child: Text(
                              'Dr. Desiree Armojallas, MD FPOGS, FSOUG',
                              style: textStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
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
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'December 18, 2024',
                        style: textStyle,
                        softWrap: true,
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    width: size.width * 0.1,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '10:00 AM - 11:00 AM',
                        style: textStyle,
                        softWrap: true,
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    width: size.width * 0.15,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dr. Desiree Armojallas Clinic, Tiangue Rd., Looc, Lapu-Lapu City',
                        style: textStyle,
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    width: size.width * 0.095,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Face-to-face',
                        style: textStyle,
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    width: size.width * 0.06,
                    child: Align(
                      alignment: Alignment.center,
                      child: AdminPatientAppointmentStatusChip(
                        appointmentStatus: appointmentStatus,
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
