import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/square_avatar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/submissions_data_list.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/submitted_requirements_table_label.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/patient_consultation_history_list.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/patient_consultation_history_table_label.dart';
import 'package:icons_plus/icons_plus.dart';

class AdminPatientDetailsState extends StatelessWidget {
  const AdminPatientDetailsState({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    const headingText = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );
    const labelText = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      color: GinaAppTheme.lightOutline,
    );
    const valueText = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    );

    //TODO: Delete Scaffold after implementing bloc
    return Scaffold(
      body: FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Container(
            height: size.height * 0.96,
            width: size.width / 1.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Temporary back button route. to implement bloc
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: GinaAppTheme.lightOutline,
                    ),
                  ),
                ),

                // Patient Primary Details
                Padding(
                  padding: const EdgeInsets.only(left: 60.0, right: 40.0),
                  child: Row(
                    children: [
                      SquareAvatar(
                        image: AssetImage(
                          Images.patientProfileIcon,
                        ),
                      ),
                      const Gap(40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.4,
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            'Desiree Armojallas',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Gap(20),
                                    Row(
                                      children: [
                                        const Icon(
                                          MingCute.location_fill,
                                          color: GinaAppTheme
                                              .lightTertiaryContainer,
                                        ),
                                        const Gap(5),
                                        SizedBox(
                                          width: size.width * 0.1,
                                          child: const Text(
                                            'Cebu City, PH',
                                            style: TextStyle(
                                              color: GinaAppTheme
                                                  .lightTertiaryContainer,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'E-mail:',
                                        style: labelText,
                                      ),
                                      const Gap(55),
                                      Text(
                                        'desireearmojallas@gina.com',
                                        style: valueText.copyWith(
                                          color: GinaAppTheme
                                              .lightTertiaryContainer,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  const Gap(12),
                                  const Row(
                                    children: [
                                      Text(
                                        'Gender:',
                                        style: labelText,
                                      ),
                                      Gap(50),
                                      Text(
                                        'Female',
                                        style: valueText,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  const Gap(12),
                                  const Row(
                                    children: [
                                      Text(
                                        'Date of birth:',
                                        style: labelText,
                                      ),
                                      Gap(20),
                                      Text(
                                        'December 18, 2000',
                                        style: valueText,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  const Gap(12),
                                  const Row(
                                    children: [
                                      Text(
                                        'Address:',
                                        style: labelText,
                                      ),
                                      Gap(43),
                                      Text(
                                        'Looc, Lapu-Lapu City, PH',
                                        style: valueText,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(450),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Gap(5),
                                      const DetailedViewIcon(
                                        icon: Icon(
                                          Icons.calendar_today_rounded,
                                          color: GinaAppTheme.lightOutline,
                                          size: 20,
                                        ),
                                      ),
                                      const Gap(18),
                                      Text(
                                        'DATE REGISTERED',
                                        style: labelText.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(33),
                                      const Text(
                                        'December 12, 2021',
                                        style: valueText,
                                      ),
                                    ],
                                  ),
                                  const Gap(5),
                                  divider(size.width * 0.18),
                                  const Gap(5),
                                  Row(
                                    children: [
                                      const Gap(5),
                                      const DetailedViewIcon(
                                        icon: Icon(
                                          Icons.perm_contact_calendar_outlined,
                                          color: GinaAppTheme.lightOutline,
                                          size: 20,
                                        ),
                                      ),
                                      const Gap(18),
                                      Text(
                                        'APPOINTMENTS BOOKED',
                                        style: labelText.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(33),
                                      const Text(
                                        'December 12, 2021',
                                        style: valueText,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    const Gap(300),
                    divider(size.width * 0.65),
                  ],
                ),

                const Gap(20),
                const Padding(
                  padding: EdgeInsets.only(left: 60.0, right: 40.0),
                  child: Text(
                    'Consultation History (10)',
                    style: headingText,
                  ),
                ),
                const Gap(20),
                patientConsultationHistoryTableLabel(size, ginaTheme),
                const PatientConsultationHistoryList(
                  appointmentStatus: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget divider(width) {
    return SizedBox(
      width: width,
      child: const Divider(
        color: GinaAppTheme.lightOutline,
        thickness: 0.3,
      ),
    );
  }
}
