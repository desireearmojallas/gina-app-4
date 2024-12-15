import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';

class ChatMessageController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription chatSub;
  late StreamSubscription authStream;
  User? currentUser;
  UserModel? patient;
  final StreamController<String?> controller = StreamController();
  Stream<String?> get stream => controller.stream;
  String? chatroom;
  late String recipient;
  List<ChatMessageModel> messages = [];

  ChatMessageController() {
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
    UserModel.fromUid(uid: auth.currentUser!.uid).then((value) {
      recipient = currentRecipient;
      patient = value;
      if (patient != null && patient!.chatrooms.contains(room)) {
        subscribe();
      } else {
        controller.add('empty');
      }
      chatroom = room;
    });
  }

  // Initial chat room
  Future<String?> initChatRoom(String room, String currentRecipient) {
    UserModel.fromUid(uid: auth.currentUser!.uid).then((value) {
      recipient = currentRecipient;
      patient = value;
      if (patient != null && patient!.chatrooms.contains(room)) {
        subscribe();
      } else {
        controller.add('empty');
      }
      chatroom = room;
      return chatroom;
    });
    return Future.value(chatroom);
  }

  generateRoomId(String recipientUid) {
    String currentPatientUid = auth.currentUser!.uid;

    if (currentPatientUid.codeUnits[0] >= recipientUid.codeUnits[0]) {
      if (currentPatientUid.codeUnits[1] == recipientUid.codeUnits[1]) {
        return chatroom = recipientUid + currentPatientUid;
      }
      return chatroom = currentPatientUid + recipientUid;
    }
    return chatroom = recipientUid + currentPatientUid;
  }

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

  //----------Send First Message----------
  sendFirstMessage({
    required String message,
    required String recipient,
  }) async {
    final currentUserModel = await firestore
        .collection('patients')
        .doc(currentUser!.uid)
        .get()
        .then((value) => UserModel.fromJson(value.data()!));

    final currentDoctorModel = await firestore
        .collection('doctors')
        .doc(recipient)
        .get()
        .then((value) => DoctorModel.fromJson(value.data()!));

    try {
      var newMessage = ChatMessageModel(
        authorUid: auth.currentUser!.uid,
        message: message,
        authorName: currentUserModel.name,
        patientName: currentUserModel.name,
        patientUid: currentUserModel.uid,
        doctorName: currentDoctorModel.name,
        doctorUid: recipient,
        createdAt: Timestamp.now(),
      ).json;

      var thisUser = auth.currentUser!.uid;
      String chatroom = generateRoomId(recipient);

      firstMessageText(chatroom, recipient, thisUser, newMessage);
      debugPrint('First message text');
    } catch (e) {
      debugPrint('Error sending first message: $e');
    }
  }

  Future<void> firstMessageText(String chatroom, String recipient,
      String thisUser, Map<String, dynamic> newMessage) async {
    await firestore.collection('consultation-chatrooms').doc(chatroom).set({
      'chatroom': chatroom,
      'members': FieldValue.arrayUnion([recipient, thisUser])
    }).then((snap) => {
          firestore
              .collection('consultation-chatrooms')
              .doc(chatroom)
              .collection('messages')
              .add(newMessage)
              .then((value) => {
                    firestore
                        .collection('patients')
                        .doc(auth.currentUser!.uid)
                        .update({
                      'chatrooms': FieldValue.arrayUnion([chatroom])
                    }).then((value) => {
                              firestore
                                  .collection('doctors')
                                  .doc(recipient)
                                  .update({
                                'chatrooms': FieldValue.arrayUnion([chatroom])
                              }),
                              subscribe(),
                            })
                  })
        });
  }

  //----------Send Message----------

  Future sendMessage({
    String message = '',
    required String recipient,
  }) async {
    var thisUser = auth.currentUser!.uid;
    return await sendMessageText(recipient, message, thisUser);
  }

  Future<DocumentReference<Map<String, dynamic>>> sendMessageText(
    String recipient,
    String message,
    String thisUser,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await firestore.collection('doctors').doc(recipient).get();

    String doctorName = docSnapshot.data()!['name'];

    return await firestore
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('messages')
        .add(ChatMessageModel(
          authorUid: auth.currentUser!.uid,
          authorName: patient!.name,
          patientName: patient!.name,
          patientUid: patient!.uid,
          doctorName: doctorName,
          doctorUid: recipient,
          message: message,
          createdAt: Timestamp.now(),
        ).json);
  }

  //----------Get start and end date and time----------

  Future<Timestamp?> getFirstMessageTime() async {
    debugPrint('Getting first message time for chatroom $chatroom');

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('messages')
        .orderBy('createdAt')
        .limit(1)
        .get();

    debugPrint('Got ${querySnapshot.docs.length} documents');

    if (querySnapshot.docs.isNotEmpty) {
      Timestamp? timestamp = querySnapshot.docs.first.data()['createdAt'];
      debugPrint('First message time: $timestamp');
      return timestamp;
    } else {
      debugPrint('No documents found');
      return null;
    }
  }

  Future<Timestamp?> getLastMessageTime() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data()['createdAt'];
    } else {
      return null;
    }
  }
}
