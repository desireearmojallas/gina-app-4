import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatEConsultCardList extends StatelessWidget {
  final DoctorEconsultBloc doctorEconsultBloc;
  final List<ChatMessageModel> chatRooms;

  const ChatEConsultCardList({
    super.key,
    required this.chatRooms,
    required this.doctorEconsultBloc,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final doctorConsultationBloc = context.read<DoctorConsultationBloc>();
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return SizedBox(
      height: size.height * 0.6,
      child: RefreshIndicator(
        onRefresh: () async {
          // Add your refresh logic here
          return;
        },
        child: ScrollbarCustom(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];

              return StreamBuilder<AppointmentModel?>(
                stream: doctorEconsultBloc
                    .fetchAppointmentDetails(chatRoom.appointmentId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CustomLoadingIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error fetching appointment'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('Appointment not found'));
                  } else {
                    final appointment = snapshot.data!;
                    final appointmentEndTime = DateFormat('hh:mm a')
                        .parse(appointment.appointmentTime!.split(' - ')[1]);
                    final appointmentDate = DateFormat('MMMM dd, yyyy')
                        .parse(appointment.appointmentDate!);
                    final appointmentEndDateTime = DateTime(
                      appointmentDate.year,
                      appointmentDate.month,
                      appointmentDate.day,
                      appointmentEndTime.hour,
                      appointmentEndTime.minute,
                    );

                    final isAppointmentFinished =
                        appointment.appointmentStatus == 2 ||
                            appointment.appointmentStatus == 5 ||
                            appointmentEndDateTime.isBefore(DateTime.now());

                    final isRead = chatRoom.seenBy.contains(currentUserUid);

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
                      onTap: () {
                        selectedPatientUid = chatRoom.patientUid;
                        selectedPatientName = chatRoom.patientName;

                        isFromChatRoomLists = true;

                        doctorEconsultBloc.add(GetAppointmentDetailsEvent(
                            appointmentUid: chatRoom.appointmentId!));
                        selectedPatientAppointment = chatRoom.appointmentId;
                        doctorEconsultBloc.add(GetPatientDataEvent(
                            patientUid: chatRoom.patientUid!));
                        doctorConsultationBloc.add(
                            DoctorConsultationCheckStatusEvent(
                                appointmentId: chatRoom.appointmentId!));

                        Navigator.pushNamed(context, '/doctorOnlineConsultChat')
                            .then((value) => doctorEconsultBloc
                                .add(GetRequestedEconsultsDisplayEvent()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          height: 90.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isRead
                                ? GinaAppTheme.appbarColorLight.withOpacity(0.4)
                                : GinaAppTheme.appbarColorLight,
                            boxShadow: isRead
                                ? []
                                : [
                                    GinaAppTheme.defaultBoxShadow,
                                  ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25.0,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: AssetImage(
                                              Images.patientProfileIcon),
                                        ),
                                        const Gap(15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            isAppointmentFinished
                                                ? const SizedBox.shrink()
                                                : Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: GinaAppTheme
                                                              .approvedTextColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 4.0,
                                                            vertical: 1.0,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'On-going'
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                color: GinaAppTheme
                                                                    .appbarColorLight,
                                                                fontSize: 8,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // const Gap(5),
                                                      // Text(
                                                      //   'Ends on ${DateFormat('MMM dd yyyy').format(appointmentEndDateTime)} at ${DateFormat('hh:mm a').format(appointmentEndDateTime)}',
                                                      //   style: const TextStyle(
                                                      //     color: GinaAppTheme
                                                      //         .lightOutline,
                                                      //     fontSize: 8,
                                                      //     fontWeight:
                                                      //         FontWeight.w500,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                            const Gap(2),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    chatRoom.patientName!,
                                                    style: TextStyle(
                                                      color: isRead
                                                          ? isAppointmentFinished
                                                              ? GinaAppTheme
                                                                  .cancelledTextColor
                                                              : GinaAppTheme
                                                                  .lightOnPrimaryColor
                                                          : GinaAppTheme
                                                              .lightOnPrimaryColor,
                                                      fontSize: 14,
                                                      fontWeight: isRead
                                                          ? FontWeight.w600
                                                          : FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                    (chatRoom.doctorName ==
                                                            chatRoom.authorName)
                                                        ? 'You: ${chatRoom.message}'
                                                        : chatRoom.message!,
                                                    style: TextStyle(
                                                      color: isRead
                                                          ? GinaAppTheme
                                                              .cancelledTextColor
                                                          : GinaAppTheme
                                                              .lightOnPrimaryColor,
                                                      fontSize: 12,
                                                      fontWeight: isRead
                                                          ? FontWeight.w400
                                                          : FontWeight.w600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Gap(40),
                                        Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: SizedBox(
                                                width: size.width * 0.11,
                                                child: Text(
                                                  time,
                                                  style: TextStyle(
                                                    color: (chatRoom.doctorName ==
                                                                chatRoom
                                                                    .authorName) ||
                                                            isRead
                                                        ? isAppointmentFinished
                                                            ? GinaAppTheme
                                                                .cancelledTextColor
                                                            : GinaAppTheme
                                                                .lightOnPrimaryColor
                                                        : GinaAppTheme
                                                            .lightOnPrimaryColor,
                                                    fontSize: 10,
                                                    fontWeight: (chatRoom
                                                                    .doctorName ==
                                                                chatRoom
                                                                    .authorName) ||
                                                            isRead
                                                        ? FontWeight.w400
                                                        : FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                            const Gap(2),
                                            if (!(chatRoom.doctorName ==
                                                    chatRoom.authorName) &&
                                                isRead)
                                              const Row(
                                                children: [
                                                  Text(
                                                    'Read',
                                                    style: TextStyle(
                                                      color: GinaAppTheme
                                                          .lightOutline,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Gap(3),
                                                  Icon(
                                                    Bootstrap.check2_all,
                                                    color: GinaAppTheme
                                                        .lightOutline,
                                                    size: 12,
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        const Gap(2),
                                        (chatRoom.doctorName ==
                                                    chatRoom.authorName) ||
                                                isRead
                                            ? const SizedBox.shrink()
                                            : const CircleAvatar(
                                                radius: 4.0,
                                                backgroundColor: GinaAppTheme
                                                    .lightTertiaryContainer,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
