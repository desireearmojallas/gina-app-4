import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/screens/view_states/approved_request_details_screen_state.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class UpcomingAppointmentsNavigationWidget extends StatelessWidget {
  final AppointmentModel? upcomingAppointment;
  final UserModel patientData;
  const UpcomingAppointmentsNavigationWidget({
    super.key,
    this.upcomingAppointment,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    String formattedDate = 'No upcoming appointment';
    if (upcomingAppointment?.appointmentDate != null) {
      try {
        DateTime appointmentDate = DateFormat('MMMM d, yyyy')
            .parse(upcomingAppointment!.appointmentDate!);
        formattedDate = DateFormat('EEEE, MMMM d').format(appointmentDate);
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }

    String appointmentType;
    if (upcomingAppointment?.modeOfAppointment == 0) {
      appointmentType = 'Online Consultation';
    } else if (upcomingAppointment?.modeOfAppointment == 1) {
      appointmentType = 'F2F Consultation';
    } else {
      appointmentType = 'No appointment';
    }

    bool isEmpty = upcomingAppointment!.appointmentUid == null ||
        upcomingAppointment!.appointmentUid!.isEmpty;

    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'This is your next appointment. Please ensure you are prepared.',
            style: TextStyle(
              fontSize: 10,
              // fontStyle: FontStyle.italic,
              color: GinaAppTheme.lightOutline,
            ),
          ),
        ),
        const Gap(10),
        GestureDetector(
          onTap: () {
            upcomingAppointment?.appointmentUid != null
                ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ApprovedRequestDetailsScreenState(
                      appointment: upcomingAppointment!,
                      patientData: patientData,
                      appointmentStatus: upcomingAppointment?.appointmentStatus,
                    );
                  }))
                : null;
          },
          child: Container(
            height: size.height * 0.22,
            width: size.width / 1.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: isEmpty
                    ? [Colors.white, Colors.white]
                    : GinaAppTheme.gradientColors,
                begin: Alignment.bottomRight,
                end: Alignment.topRight,
              ),
              boxShadow: [
                GinaAppTheme.defaultBoxShadow,
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              isEmpty
                                  ? Images.placeholderProfileIcon
                                  : Images.patientProfileIcon,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                upcomingAppointment?.patientName ??
                                    'No Patient',
                                style:
                                    ginaTheme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isEmpty ? Colors.grey[300] : Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(3),
                              Text(
                                appointmentType.toUpperCase(),
                                style: TextStyle(
                                  color: isEmpty
                                      ? Colors.grey[300]
                                      : Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(3),
                              SizedBox(
                                width: size.width * 0.33,
                                child: Flexible(
                                  child: Text(
                                    upcomingAppointment!.appointmentUid != null
                                        ? 'ID: ${upcomingAppointment!.appointmentUid}'
                                        : 'No appointment ID',
                                    style: TextStyle(
                                      color: isEmpty
                                          ? Colors.grey[300]
                                          : Colors.white.withOpacity(0.6),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!isEmpty) ...[
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: AppointmentStatusContainer(
                          appointmentStatus:
                              upcomingAppointment!.appointmentStatus!,
                          colorOverride: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: size.height * 0.05,
                    width: size.width / 1.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isEmpty
                            ? Colors.grey[300]!
                            : Colors.white.withOpacity(0.6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MingCute.calendar_line,
                          color: isEmpty
                              ? Colors.grey[300]
                              : Colors.white.withOpacity(0.6),
                          size: 20,
                        ),
                        const Gap(10),
                        Text(
                          formattedDate.isNotEmpty
                              ? formattedDate
                              : 'No upcoming appointment',
                          style: TextStyle(
                            color: isEmpty ? Colors.grey[300] : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          '|',
                          style: TextStyle(
                            color: isEmpty
                                ? Colors.grey[300]
                                : Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        Icon(
                          MingCute.time_line,
                          color: isEmpty
                              ? Colors.grey[300]
                              : Colors.white.withOpacity(0.6),
                          size: 20,
                        ),
                        const Gap(10),
                        Text(
                          upcomingAppointment?.appointmentTime ?? 'No time',
                          style: TextStyle(
                            color: isEmpty ? Colors.grey[300] : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
