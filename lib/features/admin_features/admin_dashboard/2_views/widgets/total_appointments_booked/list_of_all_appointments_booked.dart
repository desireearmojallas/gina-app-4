import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';

class ListOfAllAppointmentsBooked extends StatelessWidget {
  const ListOfAllAppointmentsBooked({super.key});

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
        itemCount: 50,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Row(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Gap(40),
                    SizedBox(
                      width: size.width * 0.08,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '20230910221545C001',
                          style: ginaTheme.labelMedium,
                        ),
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      width: size.width * 0.12,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Desiree Armojallas',
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Dr. Malou Malooy, FPOGS, FPSOUG',
                                style: ginaTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Gap(2),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(25),
                    SizedBox(
                      width: size.width * 0.12,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sep 10, 2023\n@ 10:00 AM - 11:00 AM',
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
                            'Dr. Desiree Armojallas Clinic, 1234 Main St., Looc, Lapu-Lapu City, Cebu, PH 6015',
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
                          'Face-to-face',
                          style: ginaTheme.labelMedium,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppointmentStatusContainer(
                          appointmentStatus: 2,
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
