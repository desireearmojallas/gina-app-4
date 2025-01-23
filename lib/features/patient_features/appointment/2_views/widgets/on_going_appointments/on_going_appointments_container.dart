import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/1_controllers/appointment_controller.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class OnGoingAppointmentsContainer extends StatelessWidget {
  final AppointmentModel appointment;
  final ChatMessageModel chatRoom;
  const OnGoingAppointmentsContainer({
    super.key,
    required this.appointment,
    required this.chatRoom,
  });

  @override
  Widget build(BuildContext context) {
    ongoingAppointmentForFloatingContainer = appointment;
    chatRoomForFloatingContainer = chatRoom;

    final AppointmentController appointmentController =
        sl<AppointmentController>();
    final appointmentBloc = context.read<AppointmentBloc>();
    final width = MediaQuery.of(context).size.width;

    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    final appointmentEndTime = DateFormat('hh:mm a')
        .parse(appointment.appointmentTime!.split(' - ')[1]);
    final appointmentDate =
        DateFormat('MMMM dd, yyyy').parse(appointment.appointmentDate!);
    final appointmentEndDateTime = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      appointmentEndTime.hour,
      appointmentEndTime.minute,
    );

    final isAppointmentFinished = appointment.appointmentStatus == 2 ||
        appointment.appointmentStatus == 5 ||
        appointmentEndDateTime.isBefore(DateTime.now());

    final isRead =
        isAppointmentFinished || chatRoom.seenBy.contains(currentUserUid);

    DateTime now = DateTime.now();
    DateTime createdAt = chatRoom.createdAt!.toDate();
    String time;
    if (now.difference(createdAt).inHours < 24) {
      time = DateFormat.jm().format(createdAt);
    } else if (now.difference(createdAt).inDays == 1) {
      time = 'Yesterday';
    } else if (now.difference(createdAt).inDays <= 7) {
      time = DateFormat('EEEE').format(createdAt);
    } else {
      time = DateFormat.yMd().format(createdAt);
    }

    return GestureDetector(
      onTap: () async {
        HapticFeedback.mediumImpact();
        // appointmentBloc.add(NavigateToAppointmentDetailsEvent(
        //   doctorUid: appointment.doctorUid!,
        //   appointmentUid: appointment.appointmentUid!,
        // ));

        final appointmentUid = appointment.appointmentUid;
        final doctorUid = appointment.doctorUid;

        if (appointmentUid != null) {
          debugPrint('Fetching appointment details for UID: $appointmentUid');
          final appointmentDetails = await appointmentController
              .getAppointmentDetailsNew(appointmentUid);
          if (appointmentDetails != null) {
            final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
            final DateFormat timeFormat = DateFormat('hh:mm a');
            final DateTime now = DateTime.now();

            final DateTime appointmentDate =
                dateFormat.parse(appointmentDetails.appointmentDate!.trim());
            final List<String> times =
                appointmentDetails.appointmentTime!.split(' - ');
            final DateTime endTime = timeFormat.parse(times[1].trim());

            final DateTime appointmentEndDateTime = DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day,
              endTime.hour,
              endTime.minute,
            );

            debugPrint('Current time: $now');
            debugPrint('Appointment end time: $appointmentEndDateTime');

            if (now.isBefore(appointmentEndDateTime)) {
              debugPrint(
                  'Marking appointment as visited for UID: $appointmentUid');
              await appointmentController
                  .markAsVisitedConsultationRoom(appointmentUid);
            } else {
              debugPrint('Appointment has already ended.');
            }
          } else {
            debugPrint('Appointment not found.');
          }
        } else {
          debugPrint('Appointment UID is null.');
        }

        if (doctorUid != null) {
          final getDoctorDetailsResult =
              await appointmentController.getDoctorDetail(
            doctorUid: doctorUid,
          );

          getDoctorDetailsResult.fold(
            (failure) {
              debugPrint('Failed to fetch doctor details: $failure');
            },
            (doctorDetailsData) {
              doctorDetails = doctorDetailsData;
            },
          );
        } else {
          debugPrint('Doctor UID is null.');
        }

        isFromConsultationHistory = false;
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            '/consultation',
            arguments: {
              'doctorDetails': doctorDetails,
              'appointment': appointment,
            },
          ).then((value) => appointmentBloc.add(GetAppointmentsEvent()));
        }
      },
      child: Column(
        children: [
          Container(
            width: width / 1.05,
            height: 90.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isRead
                  ? GinaAppTheme.appbarColorLight.withOpacity(0.4)
                  : GinaAppTheme.appbarColorLight,
              boxShadow: isRead
                  ? []
                  : [
                      GinaAppTheme.defaultBoxShadow,
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(
                      Images.doctorProfileIcon1,
                    ),
                  ),
                  const Gap(15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isAppointmentFinished
                          ? const SizedBox.shrink()
                          : Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: GinaAppTheme.lightTertiaryContainer,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                      vertical: 1.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'On-going'.toUpperCase(),
                                        style: const TextStyle(
                                          color: GinaAppTheme.appbarColorLight,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      const Gap(2),
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              'Dr. ${chatRoom.doctorName!}',
                              style: TextStyle(
                                color: isRead
                                    ? isAppointmentFinished
                                        ? GinaAppTheme.cancelledTextColor
                                        : GinaAppTheme.lightOnPrimaryColor
                                    : GinaAppTheme.lightOnPrimaryColor,
                                fontSize: 14,
                                fontWeight:
                                    isRead ? FontWeight.w600 : FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const Gap(3),
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              (chatRoom.patientName == chatRoom.authorName)
                                  ? 'You: ${chatRoom.message}'
                                  : chatRoom.message!,
                              style: TextStyle(
                                color: isRead
                                    ? GinaAppTheme.cancelledTextColor
                                    : GinaAppTheme.lightOnPrimaryColor,
                                fontSize: 12,
                                fontWeight:
                                    isRead ? FontWeight.w400 : FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: width * 0.11,
                          child: Text(
                            time,
                            style: TextStyle(
                              color: (chatRoom.patientName ==
                                          chatRoom.authorName) ||
                                      isRead
                                  ? isAppointmentFinished
                                      ? GinaAppTheme.cancelledTextColor
                                      : GinaAppTheme.lightOnPrimaryColor
                                  : GinaAppTheme.lightOnPrimaryColor,
                              fontSize: 10,
                              fontWeight: (chatRoom.patientName ==
                                          chatRoom.authorName) ||
                                      isRead
                                  ? FontWeight.w400
                                  : FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const Gap(2),
                      if (!(chatRoom.patientName == chatRoom.authorName) &&
                          isRead)
                        const Row(
                          children: [
                            Text(
                              'Read',
                              style: TextStyle(
                                color: GinaAppTheme.lightOutline,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Gap(3),
                            Icon(
                              Bootstrap.check2_all,
                              color: GinaAppTheme.lightOutline,
                              size: 12,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const Gap(2),
                  (chatRoom.patientName == chatRoom.authorName) || isRead
                      ? const SizedBox.shrink()
                      : const CircleAvatar(
                          radius: 4.0,
                          backgroundColor: GinaAppTheme.lightTertiaryContainer,
                        ),
                ],
              ),
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
