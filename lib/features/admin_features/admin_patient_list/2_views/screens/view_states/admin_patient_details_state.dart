import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/square_avatar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/widgets/doctor_details_state_widgets/detailed_view_icon.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/bloc/admin_patient_list_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/patient_consultation_history_list.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/patient_consultation_history_table_label.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class AdminPatientDetailsState extends StatelessWidget {
  final UserModel patientDetails;
  final List<AppointmentModel> appointmentDetails;
  const AdminPatientDetailsState(
      {super.key,
      required this.patientDetails,
      required this.appointmentDetails});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    final adminPatientListBloc = context.read<AdminPatientListBloc>();

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

    return FittedBox(
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
                    adminPatientListBloc
                        .add(AdminPatientListGetRequestedEvent());
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
                              width: size.width * 0.55,
                              child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      patientDetails.name,
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  // const Gap(200),
                                  const Gap(50),
                                  Row(
                                    children: [
                                      const Icon(
                                        MingCute.location_fill,
                                        color:
                                            GinaAppTheme.lightTertiaryContainer,
                                      ),
                                      const Gap(5),
                                      SizedBox(
                                        width: size.width * 0.1,
                                        child: Text(
                                          patientDetails.address,
                                          style: const TextStyle(
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
                                      patientDetails.email,
                                      style: valueText.copyWith(
                                        color:
                                            GinaAppTheme.lightTertiaryContainer,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    const Text(
                                      'Gender:',
                                      style: labelText,
                                    ),
                                    const Gap(50),
                                    Text(
                                      patientDetails.email,
                                      style: valueText,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    const Text(
                                      'Date of birth:',
                                      style: labelText,
                                    ),
                                    const Gap(20),
                                    Text(
                                      patientDetails.dateOfBirth,
                                      style: valueText,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    const Text(
                                      'Address:',
                                      style: labelText,
                                    ),
                                    const Gap(43),
                                    Text(
                                      patientDetails.address,
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
                                    Text(
                                      DateFormat('MMMM d, yyyy').format(
                                          patientDetails.created!
                                              .toDate()
                                              .toLocal()),
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
                                    Text(
                                      patientDetails.appointmentsBooked.length
                                          .toString(),
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
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 40.0),
                child: Text(
                  'Consultation History (${patientDetails.appointmentsBooked.length})',
                  style: headingText,
                ),
              ),
              const Gap(20),
              patientConsultationHistoryTableLabel(size, ginaTheme),
              PatientConsultationHistoryList(
                // appointmentStatus: 2,
                appointmentDetails: appointmentDetails,
              ),
            ],
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
