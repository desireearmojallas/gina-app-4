import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/1_controllers/chat_message_controllers.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/widgets/chat_card.dart';
import 'package:intl/intl.dart';

class MessageBody extends StatelessWidget {
  final ChatMessageController chatController;
  final ScrollController scrollController;
  final String selectedDoctorUID;
  final bool isChatWaiting;

  const MessageBody({
    super.key,
    required this.chatController,
    required this.scrollController,
    required this.selectedDoctorUID,
    required this.isChatWaiting,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
        animation: chatController,
        builder: (context, Widget? w) {
          return isChatWaiting
              ? const SizedBox()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 0.0),
                          child: Text(
                            'Your scheduled appointment has now begun. Happy chatting!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: GinaAppTheme.appbarColorLight,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        const Gap(15),
                        ...chatController.appointmentMessages.entries.map(
                          (entry) {
                            String appointmentId = entry.key;
                            List<ChatMessageModel> messages = entry.value;
                            Map<String, dynamic> times =
                                chatController.appointmentTimes[appointmentId]!;

                            Timestamp? startTime =
                                times['startTime'] as Timestamp?;
                            Timestamp? lastMessageTime =
                                times['lastMessageTime'] as Timestamp?;
                            Timestamp? scheduledEndTime =
                                times['scheduledEndTime'] as Timestamp?;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: GinaAppTheme.appbarColorLight
                                              .withOpacity(0.3),
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: Text(
                                          'Appointment ID: $appointmentId',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: GinaAppTheme
                                                    .appbarColorLight
                                                    .withOpacity(0.9),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: GinaAppTheme.appbarColorLight
                                              .withOpacity(0.3),
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (startTime != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(
                                      DateFormat('MMM dd, yyyy \'at\' hh:mm a')
                                          .format(startTime.toDate())
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: GinaAppTheme.appbarColorLight
                                                .withOpacity(0.8),
                                          ),
                                    ),
                                  ),
                                const Gap(20),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    return ChatCard(
                                      scrollController: scrollController,
                                      index: index,
                                      chat: messages,
                                      chatroom: chatController.chatroom ?? '',
                                      recipient: selectedDoctorUID,
                                    );
                                  },
                                ),
                                if (lastMessageTime != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 10.0),
                                    child: Text(
                                      DateFormat('MMM dd, yyyy \'at\' hh:mm a')
                                          .format(lastMessageTime.toDate())
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: GinaAppTheme.appbarColorLight
                                                .withOpacity(0.8),
                                          ),
                                    ),
                                  ),
                                // if (scheduledEndTime != null)
                                //   Padding(
                                //     padding:
                                //         const EdgeInsets.only(bottom: 10.0),
                                //     child: Text(
                                //       'Scheduled to end at ${DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(scheduledEndTime.toDate())}',
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .labelMedium
                                //           ?.copyWith(
                                //             color: GinaAppTheme.appbarColorLight
                                //                 .withOpacity(0.8),
                                //           ),
                                //     ),
                                //   ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
