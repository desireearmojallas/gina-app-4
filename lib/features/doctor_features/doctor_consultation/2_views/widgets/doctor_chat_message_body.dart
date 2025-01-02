import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/1_controllers/doctor_chat_message_controller.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/widgets/doctor_chat_card.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:intl/intl.dart';

class DoctorChatMessageBody extends StatelessWidget {
  final DoctorChatMessageController chatController;
  final ScrollController scrollController;
  final String selectedDoctorUID;
  const DoctorChatMessageBody({
    super.key,
    required this.chatController,
    required this.scrollController,
    required this.selectedDoctorUID,
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
                              const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text(
                            'Your scheduled appointment has now begun. Happy chatting!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: GinaAppTheme.appbarColorLight,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const Gap(15),
                        FutureBuilder(
                          future: chatController.getFirstMessageTime(),
                          builder: (BuildContext context,
                              AsyncSnapshot<Timestamp?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CustomLoadingIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                'Started ${DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(snapshot.data?.toDate() ?? DateTime.now())}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: GinaAppTheme.appbarColorLight,
                                    ),
                              );
                            }
                          },
                        ),
                        const Gap(15),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: chatController.messages.length,
                          itemBuilder: (context, index) {
                            return DoctorChatCard(
                              scrollController: scrollController,
                              index: index,
                              chat: chatController.messages,
                              chatroom: chatController.chatroom ?? '',
                              recipient: selectedDoctorUID,
                            );
                          },
                        ),
                        const Gap(15),
                        FutureBuilder<Timestamp?>(
                          future: chatController.getLastMessageTime(),
                          builder: (BuildContext context,
                              AsyncSnapshot<Timestamp?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: GinaAppTheme.appbarColorLight
                                          .withOpacity(0.5),
                                      thickness: 1,
                                      endIndent: 10,
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    'Ended ${DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(snapshot.data?.toDate() ?? DateTime.now())}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: GinaAppTheme.appbarColorLight,
                                        ),
                                  ),
                                  const Gap(5),
                                  Expanded(
                                    child: Divider(
                                      color: GinaAppTheme.appbarColorLight
                                          .withOpacity(0.5),
                                      thickness: 1,
                                      indent: 10,
                                    ),
                                  ),
                                ],
                              );
                            }
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
