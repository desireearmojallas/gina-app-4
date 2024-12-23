import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/widgets/confirming_pending_request_modal.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class PendingRequestsNavigationWidget extends StatelessWidget {
  final int pendingRequests;
  final AppointmentModel? pendingAppointment;
  final UserModel patientData;
  const PendingRequestsNavigationWidget({
    super.key,
    required this.pendingRequests,
    required this.pendingAppointment,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    String formattedDate = 'No pending appointment';
    String formattedTime = 'No time';
    if (pendingAppointment?.appointmentDate != null) {
      try {
        DateTime appointmentDate = DateFormat('MMMM d, yyyy')
            .parse(pendingAppointment!.appointmentDate!);
        formattedDate = DateFormat('EEEE, MMMM d').format(appointmentDate);
        formattedTime = pendingAppointment!.appointmentTime ?? 'No time';
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }

    String appointmentType;
    if (pendingAppointment?.modeOfAppointment == 0) {
      appointmentType = 'Online Consultation';
    } else if (pendingAppointment?.modeOfAppointment == 1) {
      appointmentType = 'F2F Consultation';
    } else {
      appointmentType = 'No appointment';
    }

    // Debug prints to check the values of patientData
    debugPrint(
        'PendingRequestsNavigationWidget Patient Name: ${patientData.name}');
    debugPrint(
        'PendingRequestsNavigationWidget Patient Date of Birth: ${patientData.dateOfBirth}');
    debugPrint(
        'PendingRequestsNavigationWidget Patient Gender: ${patientData.gender}');
    debugPrint(
        'PendingRequestsNavigationWidget Patient Address: ${patientData.address}');
    debugPrint(
        'PendingRequestsNavigationWidget Patient Email: ${patientData.email}');

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Pending Requests'.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: pendingRequests == 0
                    ? Colors.grey[300]
                    : GinaAppTheme.lightTertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  pendingRequests.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // pendingRequests == 0
                //     ? null
                //     : Navigator.of(context).pushNamed('');
                // TODO: PENDING REQUESTS ROUTE
              },
              child: Text(
                'See all',
                style: ginaTheme.textTheme.labelMedium?.copyWith(
                  color: pendingRequests == 0
                      ? Colors.grey[300]
                      : GinaAppTheme.lightTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        // const Gap(10),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: size.height * 0.14,
            width: size.width / 1.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GinaAppTheme.lightOnTertiary,
              boxShadow: [
                GinaAppTheme.defaultBoxShadow,
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: CircleAvatar(
                    radius: 37,
                    backgroundImage: AssetImage(
                      pendingRequests == 0
                          ? Images.placeholderProfileIcon
                          : Images.patientProfileIcon,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: Flexible(
                        child: Text(
                          pendingAppointment != null &&
                                  pendingAppointment!.appointmentUid != null
                              ? 'Appt. ID: ${pendingAppointment!.appointmentUid}'
                              : 'No Appointment ID',
                          style: ginaTheme.textTheme.labelSmall?.copyWith(
                            color: pendingRequests == 0
                                ? Colors.grey[300]
                                : GinaAppTheme.lightOutline,
                            fontSize: 9,
                          ),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                    ),
                    const Gap(5),
                    SizedBox(
                      width: size.width * 0.33,
                      child: Text(
                        pendingAppointment?.patientName ?? 'No Patient',
                        style: ginaTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: pendingRequests == 0
                              ? Colors.grey[300]
                              : GinaAppTheme.lightOnPrimaryColor,
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      appointmentType.toUpperCase(),
                      style: ginaTheme.textTheme.labelSmall?.copyWith(
                        color: pendingRequests == 0
                            ? Colors.grey[300]
                            : GinaAppTheme.lightTertiaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      '$formattedDate\n$formattedTime',
                      style: ginaTheme.textTheme.labelMedium?.copyWith(
                        color: pendingRequests == 0
                            ? Colors.grey[300]
                            : GinaAppTheme.lightOutline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: pendingRequests == 0
                            ? null
                            : () {
                                showConfirmingPendingRequestDialog(
                                  context,
                                  appointmentId:
                                      pendingAppointment!.appointmentUid!,
                                  appointment: pendingAppointment!,
                                  patientData: patientData,
                                );
                              },
                        icon: Icon(
                          MingCute.close_circle_fill,
                          color: pendingRequests == 0
                              ? Colors.grey[100]
                              : Colors.grey[300],
                          size: 38,
                        ),
                      ),
                      IconButton(
                        onPressed: pendingRequests == 0
                            ? null
                            : () {
                                showConfirmingPendingRequestDialog(
                                  context,
                                  appointmentId:
                                      pendingAppointment!.appointmentUid!,
                                  appointment: pendingAppointment!,
                                  patientData: patientData,
                                );
                              },
                        icon: Icon(
                          MingCute.check_circle_fill,
                          color: pendingRequests == 0
                              ? Colors.grey[100]
                              : GinaAppTheme.lightTertiaryContainer,
                          size: 38,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
