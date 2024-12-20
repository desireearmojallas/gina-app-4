import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:intl/intl.dart';

class ChatEConsultCardList extends StatelessWidget {
  final List<ChatMessageModel> chatRooms;
  const ChatEConsultCardList({super.key, required this.chatRooms});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.6,
      child: RefreshIndicator(
        onRefresh: () async {
          // Add your refresh logic here
          return;
        },
        child: ScrollbarCustom(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: chatRooms.length, // todo: to change
              itemBuilder: (context, index) {
                final chatRoom = chatRooms[index];
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
                    //todo:  to change route when bloc implemented
                    Navigator.pushNamed(context, '/doctorOnlineConsultChat');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 90.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GinaAppTheme.appbarColorLight,
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
                                      radius: 28.0,
                                      backgroundImage: AssetImage(
                                        Images.patientProfileIcon,
                                      ),
                                    ),
                                    const Gap(10),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                chatRoom.patientName ?? '',
                                                style: const TextStyle(
                                                  color: GinaAppTheme
                                                      .cancelledTextColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                (chatRoom.doctorName ==
                                                        chatRoom.authorName)
                                                    ? 'You: ${chatRoom.message}'
                                                    : chatRoom.message!,
                                                style: const TextStyle(
                                                  color: GinaAppTheme
                                                      .cancelledTextColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Gap(30),
                                    Text(
                                      time,
                                      style: const TextStyle(
                                        color: GinaAppTheme.cancelledTextColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
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
              }),
        ),
      ),
    );
  }
}
