import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';

class DoctorChatMessageController with ChangeNotifier {
  late StreamSubscription chatSub;
  late StreamSubscription authStream;
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

    authStream = FirebaseAuth.instance.authStateChanges().listen((User? user) {
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

  String generateRoomIdAlternative(String recipientUid) {
    String currentDoctorUid = FirebaseAuth.instance.currentUser!.uid;

    List<String> sortedUids = [currentDoctorUid, recipientUid]..sort();

    return sortedUids.join();
  }
}
