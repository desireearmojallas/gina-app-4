import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';

import 'package:intl/intl.dart';

class DoctorChatCard extends StatefulWidget {
  final ScrollController scrollController;
  final int index;
  final bool isGroup;
  final List<ChatMessageModel> chat;
  final String chatroom;
  final String recipient;
  const DoctorChatCard({
    super.key,
    required this.scrollController,
    required this.index,
    this.isGroup = false,
    required this.chat,
    required this.chatroom,
    required this.recipient,
  });

  @override
  State<DoctorChatCard> createState() => _DoctorChatCardState();
}

class _DoctorChatCardState extends State<DoctorChatCard> {
  var isVisible = false;
  double space = 0;
  List<ChatMessageModel> get chat => widget.chat;
  ScrollController get scrollController => widget.scrollController;
  int get index => widget.index;
  String get chatroom => widget.chatroom;
  final isDoctor = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = chat[index].authorUid == isDoctor;
    bool isNextSameAuthor = index < chat.length - 1 &&
        chat[index + 1].authorUid == chat[index].authorUid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            CircleAvatar(
              backgroundImage: !isNextSameAuthor
                  ? AssetImage(Images.patientProfileIcon)
                  : null,
              backgroundColor: Colors.transparent,
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 1.0,
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  messageDate(context),
                  messageBubble(context),
                  messageSeen(context),
                ],
              ),
            ),
          ),
          // if (isCurrentUser)
          //   CircleAvatar(
          //     backgroundImage: !isNextSameAuthor
          //         ? AssetImage(Images.doctorProfileIcon1)
          //         : null,
          //     backgroundColor: Colors.transparent,
          //   ),
        ],
      ),
    );
  }

  //-------------Message Date----------------
  Visibility messageDate(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        padding: const EdgeInsets.only(bottom: 5, top: 15),
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          DateFormat('MMM d, y hh:mm a')
              // DateFormat('hh:mm a')
              .format(chat[index].createdAt!.toDate()),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  //-------------Message Bubble----------------
  Row messageBubble(BuildContext context) {
    return Row(
      mainAxisAlignment: chat[index].authorUid == isDoctor
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        editedLeft(context),
        messageBody(context),
        editedRight(context),
      ],
    );
  }

  //-------------Message Seen----------------
  Visibility messageSeen(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: chat[index].authorUid == isDoctor
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text(
                chat[index].seenBy.length > 1 ? 'Seen by' : 'Sent',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              for (String uid in chat[index].seenBy)
                FutureBuilder(
                  future: UserModel.fromUid(uid: uid),
                  builder: (context, AsyncSnapshot snap) {
                    if (snap.hasData &&
                        chat[index].seenBy.length > 1 &&
                        snap.data?.uid != isDoctor) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        width: 22,
                      );
                    }
                    return Text(chat[index].authorName ?? '');
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  //-------------Edited Left----------------
  Visibility editedLeft(BuildContext context) {
    return Visibility(
      visible: chat[index].isEdited
          ? chat[index].isDeleted
              ? false
              : chat[index].authorUid == isDoctor
          : false,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          '(edited)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  //-------------Message Body----------------
  Container messageBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            isVisible = !isVisible;
          });
        },
        onLongPress: () {
          HapticFeedback.vibrate();
          chat[index].isDeleted
              ? null
              : chat[index].authorUid == isDoctor
                  ? null
                  : null;
        },
        child: Column(
          crossAxisAlignment: chat[index].authorUid == isDoctor
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if ((chat[index].authorUid != isDoctor) &&
                (index == 0 ||
                    chat[index - 1].authorUid != chat[index].authorUid))
              FutureBuilder(
                future: DoctorModel.fromUid(uid: widget.recipient),
                builder: (context, AsyncSnapshot<DoctorModel> snap) {
                  if (!snap.hasData) {}
                  return Padding(
                    padding: widget.isGroup
                        ? const EdgeInsets.only(top: 2.0, bottom: 5.0)
                        : const EdgeInsets.only(top: 2.0, bottom: 5.0),
                    child: const Row(
                      children: [],
                    ),
                  );
                },
              ),
            if (chat[index].isDeleted)
              Container(
                padding: widget.isGroup
                    ? EdgeInsets.only(left: space)
                    : const EdgeInsets.only(left: 0),
                child: deletedMessage(context),
              )
            else
              Container(
                padding: widget.isGroup
                    ? EdgeInsets.only(left: space)
                    : const EdgeInsets.only(left: 0),
                child: stringMessage(context),
              )
          ],
        ),
      ),
    );
  }

  //-------------Edited Right----------------
  Visibility editedRight(BuildContext context) {
    return Visibility(
      visible: chat[index].isEdited
          ? chat[index].isDeleted
              ? false
              : chat[index].authorUid == isDoctor
                  ? false
                  : true
          : false,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          '(edited)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  //-------------Message----------------
  Container stringMessage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        maxWidth: size.width / 1.3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: backgroundColor(context),
      child: Text(
        chat[index].message!,
        style: TextStyle(
          fontSize: 14.0,
          color: chat[index].isDeleted
              ? Colors.white
              : chat[index].authorUid == isDoctor
                  ? GinaAppTheme.appbarColorLight
                  : GinaAppTheme.lightOnPrimaryColor,
        ),
        overflow: TextOverflow.visible,
      ),
    );
  }

  //-------------Deleted Message----------------
  Container deletedMessage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxWidth: size.width / 1.3),
      padding: const EdgeInsets.all(12.0),
      decoration: backgroundColor(context),
      child: Text(
        overflow: TextOverflow.visible,
        'message deleted',
        style: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).textTheme.titleSmall?.color,
        ),
      ),
    );
  }

  //-------------Background Color----------------
  BoxDecoration backgroundColor(BuildContext context) {
    final currentUserUid = isDoctor;
    final isCurrentUser = chat[index].authorUid == currentUserUid;

    bool isPreviousSameAuthor =
        index > 0 && chat[index - 1].authorUid == chat[index].authorUid;
    bool isNextSameAuthor = index < chat.length - 1 &&
        chat[index + 1].authorUid == chat[index].authorUid;

    BorderRadius borderRadius;
    return BoxDecoration(
      border: Border.all(
        color: chat[index].isDeleted ? Colors.white : Colors.transparent,
      ),
      borderRadius:
          chat[index].authorUid == FirebaseAuth.instance.currentUser?.uid
              ? (() {
                  if (isPreviousSameAuthor && isNextSameAuthor) {
                    // Middle message in a series
                    return const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    );
                  } else if (isPreviousSameAuthor) {
                    // Last message in a series
                    return const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(20),
                    );
                  } else if (isNextSameAuthor) {
                    // First message in a series
                    return const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(8),
                    );
                  } else {
                    // Single message
                    return const BorderRadius.all(Radius.circular(20));
                  }
                })()
              : (() {
                  if (isPreviousSameAuthor && isNextSameAuthor) {
                    // Middle message in a series
                    return const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    );
                  } else if (isPreviousSameAuthor) {
                    // Last message in a series
                    return const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    );
                  } else if (isNextSameAuthor) {
                    // First message in a series
                    return const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    );
                  } else {
                    // Single message
                    return const BorderRadius.all(Radius.circular(20));
                  }
                })(),
      color: chat[index].isDeleted
          ? Colors.transparent
          : chat[index].authorUid == isDoctor
              ? GinaAppTheme.lightTertiaryContainer
              : GinaAppTheme.appbarColorLight,
    );
  }
}
