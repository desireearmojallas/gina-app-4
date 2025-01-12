import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
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

  bool _isDisposed = false;

  DoctorChatMessageController() {
    chatSub = const Stream.empty().listen((_) {});
    if (chatroom != null) {
      subscribe();
    } else {
      controller.add('empty');
    }

    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    debugPrint('DoctorChatMessageController dispose called');
    _isDisposed = true;
    chatSub.cancel();
    authStream.cancel();
    controller.close();
    super.dispose();
  }

  subscribe() {
    if (_isDisposed) return;
    chatSub = ChatMessageModel.individualCurrentChats(
            chatroom!, selectedPatientAppointmentModel!.appointmentUid!)
        .listen(chatUpdateHandler);
    controller.add('success');
  }

  getChatRoom(String room, String currentRecipient) {
    if (_isDisposed) return;
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
    if (_isDisposed) return Future.value(null);
    debugPrint(
        'initChatRoom called with room: $room, recipient: $currentRecipient');
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
      debugPrint('Chatroom initialized: $chatroom');
      return chatroom;
    });
    return Future.value(chatroom);
  }

  generateRoomId(String recipientUid) {
    String currentDoctorUid = FirebaseAuth.instance.currentUser!.uid;
    debugPrint(
        'Generating room ID for currentDoctorUid: $currentDoctorUid and recipientUid: $recipientUid');

    if (currentDoctorUid.codeUnits[0] >= recipientUid.codeUnits[0]) {
      if (currentDoctorUid.codeUnits[1] == recipientUid.codeUnits[1]) {
        chatroom = recipientUid + currentDoctorUid;
        debugPrint('Room ID generated (case 1): $chatroom');
        return chatroom;
      }
      chatroom = currentDoctorUid + recipientUid;
      debugPrint('Room ID generated (case 2): $chatroom');
      return chatroom;
    }
    chatroom = recipientUid + currentDoctorUid;
    debugPrint('Room ID generated (case 3): $chatroom');
    return chatroom;
  }

  chatUpdateHandler(List<ChatMessageModel> update) {
    if (_isDisposed) return;
    for (ChatMessageModel message in update) {
      if (chatroom == generateRoomId(recipient) &&
          message.hasNotSeenMessage(auth.currentUser!.uid)) {
        message.individualUpdateSeen(auth.currentUser!.uid, chatroom!,
            selectedPatientAppointmentModel!.appointmentUid!);
      }
    }

    messages = update;
    notifyListeners();
  }

  sendFirstMessage({
    required String message,
    required String recipient,
  }) async {
    if (_isDisposed) return;
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

  Future<void> firstMessageText(String chatroom, String recipient,
      String thisUser, Map<String, dynamic> newMessage) async {
    if (_isDisposed) return;
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

  Future sendMessage({
    String message = '',
    required String recipient,
  }) async {
    if (_isDisposed) return;
    var thisUser = auth.currentUser!.uid;
    return await sendMessageText(recipient, message, thisUser);
  }

  Future<DocumentReference<Map<String, dynamic>>> sendMessageText(
      String recipient, String message, String thisUser) async {
    if (_isDisposed) return Future.error('Controller is disposed');
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

  Future<Timestamp?> getFirstMessageTime() async {
    if (_isDisposed) return null;
    debugPrint('Getting first message time for chatroom $chatroom');

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
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
    if (_isDisposed) return null;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
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
