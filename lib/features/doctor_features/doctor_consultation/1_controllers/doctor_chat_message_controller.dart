import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';

class DoctorChatMessageController with ChangeNotifier {
  late StreamSubscription chatSub;
  late StreamSubscription authStream;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;
  DoctorModel? doctor;
  final StreamController<String?> controller = StreamController();
  Stream<String?> get stream => controller.stream;
  String? chatroom;
  late String recipient;
  List<ChatMessageModel> messages = [];

  DoctorChatMessageController() {
    chatSub = const Stream.empty().listen((_) {});
    if (chatroom != null) {
      subscribe();
    } else {
      controller.add('empty');
    }

    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    chatSub.cancel();
    super.dispose();
  }

  subscribe() {
    chatSub = ChatMessageModel.individualCurrentChats(chatroom!)
        .listen(chatUpdateHandler);
    controller.add('success');
  }

  getChatRoom(String room, String currentRecipient) {
    DoctorModel.fromUid(uid: auth.currentUser!.uid).then((value) {
      recipient = currentRecipient;
      doctor = value;
      if (doctor != null && doctor!.chatrooms.contains(room)) {
        subscribe();
      } else {
        controller.add('empty');
      }
      chatroom = room;
    });
  }

  Future<String?> initChatRoom(String room, String currentRecipient) {
    DoctorModel.fromUid(uid: FirebaseAuth.instance.currentUser!.uid)
        .then((value) {
      recipient = currentRecipient;
      doctor = value;
      if (doctor != null && doctor!.chatrooms.contains(room)) {
        subscribe();
      } else {
        controller.add('empty');
      }

      chatroom = room;
      return chatroom;
    });
    return Future.value(chatroom);
  }

  // Future<String?> initChatRoom(String room, String currentRecipient) async {
  //   try {
  //     DoctorModel doctor =
  //         await DoctorModel.fromUid(uid: auth.currentUser!.uid);

  //     recipient = currentRecipient;

  //     if (doctor.chatrooms.contains(room)) {
  //       subscribe();
  //     } else {
  //       controller.add('empty');
  //     }

  //     chatroom = room;
  //     return chatroom; // Return the resolved chatroom.
  //   } catch (e) {
  //     controller.add('error');
  //     return null; // Handle any errors gracefully.
  //   }
  // }

  generateRoomId(String recipientUid) {
    String currentDoctorUid = FirebaseAuth.instance.currentUser!.uid;

    if (currentDoctorUid.codeUnits[0] >= recipientUid.codeUnits[0]) {
      if (currentDoctorUid.codeUnits[1] == recipientUid.codeUnits[1]) {
        return chatroom = recipientUid + currentDoctorUid;
      }
      return chatroom = currentDoctorUid + recipientUid;
    }
    return chatroom = recipientUid + currentDoctorUid;
  }

  // String generateRoomId(String recipientUid) {
  //   String currentDoctorUid = auth.currentUser!.uid;

  //   List<String> sortedUids = [currentDoctorUid, recipientUid]..sort();

  //   return sortedUids.join();
  // }

  chatUpdateHandler(List<ChatMessageModel> update) {
    for (ChatMessageModel message in update) {
      if (chatroom == generateRoomId(recipient) &&
          message.hasNotSeenMessage(auth.currentUser!.uid)) {
        message.individualUpdateSeen(auth.currentUser!.uid, chatroom!);
      } else {}
    }

    messages = update;
    notifyListeners();
  }

  //----------------- SEND FIRST MESSAGE ----------------

  sendFirstMessage({
    required String message,
    required String recipient,
  }) async {
    final currentUserModel = await firestore
        .collection('doctors')
        .doc(currentUser!.uid)
        .get()
        .then((value) => DoctorModel.fromJson(value.data()!));

    final currentPatientModel = await firestore
        .collection('patients')
        .doc(recipient)
        .get()
        .then((value) => UserModel.fromJson(value.data()!));

    try {
      var newMessage = ChatMessageModel(
        authorUid: auth.currentUser!.uid,
        message: message,
        authorImage: '',
        authorName: currentUserModel.name,
        doctorName: currentUserModel.name,
        doctorUid: currentUserModel.uid,
        patientName: currentPatientModel.name,
        patientUid: recipient,
        createdAt: Timestamp.now(),
      ).json;

      var thisUser = auth.currentUser!.uid;
      String chatroom = generateRoomId(recipient);

      firstMessageText(chatroom, recipient, thisUser, newMessage);
    } catch (e) {
      debugPrint('Error sending first message: $e');
    }
  }

  //----------------- FIRST MESSAGE TEXT ----------------

  Future<void> firstMessageText(String chatroom, String recipient,
      String thisUser, Map<String, dynamic> newMessage) async {
    await firestore.collection('consultation-chatrooms').doc(chatroom).set({
      'chatroom': chatroom,
      'members': FieldValue.arrayUnion([recipient, thisUser])
    }).then(
      (snap) => {
        firestore
            .collection('consultation-chatrooms')
            .doc(chatroom)
            .collection('messages')
            .add(newMessage)
            .then(
              (value) => {
                firestore
                    .collection('doctors')
                    .doc(auth.currentUser!.uid)
                    .update({
                  'chatrooms': FieldValue.arrayUnion([chatroom])
                }).then(
                  (value) => {
                    firestore.collection('patients').doc(recipient).update(
                      {
                        'chatrooms': FieldValue.arrayUnion([chatroom]),
                      },
                    ),
                    subscribe(),
                  },
                ),
              },
            ),
      },
    );
  }

  //----------------- SEND MESSAGE ----------------
  Future sendMessage({
    String message = '',
    required String recipient,
  }) async {
    var thisUser = auth.currentUser!.uid;
    return await sendMessageText(recipient, message, thisUser);
  }

  //----------------- SEND MESSAGE TEXT ----------------

  Future<DocumentReference<Map<String, dynamic>>> sendMessageText(
      String recipient, String message, String thisUser) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firestore.collection('patients').doc(recipient).get();
      String patientName = docSnapshot.data()?['name'] ?? 'Unknown';

      if (chatroom == null || doctor == null) {
        throw Exception('Chatroom or doctor information is missing.');
      }

      return await firestore
          .collection('consultation-chatrooms')
          .doc(chatroom)
          .collection('messages')
          .add(ChatMessageModel(
            authorUid: auth.currentUser!.uid,
            authorImage: '',
            authorName: doctor!.name,
            patientName: patientName,
            patientUid: recipient,
            doctorName: doctor!.name,
            doctorUid: doctor!.uid,
            message: message,
            createdAt: Timestamp.now(),
          ).json);
    } catch (e) {
      debugPrint('Error sending message: $e');
      rethrow;
    }
  }
}
