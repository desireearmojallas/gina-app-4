import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:intl/intl.dart';

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
  Map<String, List<ChatMessageModel>> appointmentMessages = {};
  Map<String, Map<String, dynamic>> appointmentTimes = {};

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
    monitorAppointmentStatus(selectedPatientAppointmentModel!.appointmentUid!);
  }

  void getChatRoom(String room, String currentRecipient) {
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
    }).catchError((error) {
      // Handle any errors that occur during the async operation
      debugPrint('Error getting chat room: $error');
      controller.add('error');
    });
  }

  Future<String?> initChatRoom(String room, String currentRecipient) {
    if (_isDisposed) return Future.value(null);
    debugPrint(
        'initChatRoom called with room: $room, recipient: $currentRecipient');
    return DoctorModel.fromUid(uid: auth.currentUser!.uid).then((value) {
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
    }).catchError((error) {
      // Handle any errors that occur during the async operation
      debugPrint('Error initializing chat room: $error');
      return null;
    });
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

  chatUpdateHandler(List<ChatMessageModel> update) async {
    if (_isDisposed) return;
    debugPrint('Handling chat update');
    Map<String, List<ChatMessageModel>> allMessages = {};
    Map<String, Map<String, dynamic>> allTimes = {};

    // Fetch all appointments for the current chatroom
    QuerySnapshot<Map<String, dynamic>> appointmentsSnapshot = await firestore
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('appointments')
        .get();

    if (_isDisposed) return;

    for (var appointmentDoc in appointmentsSnapshot.docs) {
      String appointmentId = appointmentDoc.id;
      Map<String, dynamic> appointmentData = appointmentDoc.data();

      // Fetch messages for each appointment
      QuerySnapshot<Map<String, dynamic>> messagesSnapshot = await firestore
          .collection('consultation-chatrooms')
          .doc(chatroom)
          .collection('appointments')
          .doc(appointmentId)
          .collection('messages')
          .orderBy('createdAt')
          .get();

      if (_isDisposed) return;

      List<ChatMessageModel> messages = messagesSnapshot.docs.map((doc) {
        ChatMessageModel message = ChatMessageModel.fromDocumentSnap(doc);
        debugPrint('Fetched message with uid: ${message.uid}');
        return message;
      }).toList();

      // Update seen status for messages
      for (ChatMessageModel message in messages) {
        if (message.hasNotSeenMessage(auth.currentUser!.uid)) {
          try {
            await message.individualUpdateSeen(
                auth.currentUser!.uid, chatroom!, appointmentId);
            debugPrint('Updated seenBy for message: ${message.uid}');
          } catch (e) {
            debugPrint(
                'Failed to update seenBy for message: ${message.uid}, error: $e');
          }
        }
      }

      // Fetch the appointment status from the top-level collection
      DocumentSnapshot<Map<String, dynamic>> appointmentStatusSnapshot =
          await firestore.collection('appointments').doc(appointmentId).get();

      if (_isDisposed) return;

      bool isCompleted = appointmentStatusSnapshot.exists &&
          appointmentStatusSnapshot.data()?['appointmentStatus'] ==
              AppointmentStatus.completed.index;

      allMessages[appointmentId] = messages;
      allTimes[appointmentId] = {
        'startTime': appointmentData['startTime'],
        'scheduledEndTime': appointmentData['scheduledEndTime'],
        'lastMessageTime':
            isCompleted && messages.isNotEmpty ? messages.last.createdAt : null,
      };
    }

    // Sort the appointments by startTime
    var sortedEntries = allTimes.entries.toList()
      ..sort((a, b) {
        Timestamp? startTimeA = a.value['startTime'] as Timestamp?;
        Timestamp? startTimeB = b.value['startTime'] as Timestamp?;
        if (startTimeA == null && startTimeB == null) return 0;
        if (startTimeA == null) return 1;
        if (startTimeB == null) return -1;
        return startTimeA.compareTo(startTimeB);
      });

    // Create sorted maps
    Map<String, List<ChatMessageModel>> sortedMessages = {};
    Map<String, Map<String, dynamic>> sortedTimes = {};

    for (var entry in sortedEntries) {
      String appointmentId = entry.key;
      sortedMessages[appointmentId] = allMessages[appointmentId]!;
      sortedTimes[appointmentId] = allTimes[appointmentId]!;
    }

    if (_isDisposed) return;

    appointmentMessages = sortedMessages;
    appointmentTimes = sortedTimes;
    notifyListeners();
  }
  //------------------------Send First Message------------------------

  sendFirstMessage({
    required String message,
    required String recipient,
    required AppointmentModel appointment,
  }) async {
    if (_isDisposed) return;
    debugPrint('Sending first message to recipient: $recipient');
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
        authorName: currentUserModel.name,
        patientName: currentPatientModel.name,
        patientUid: recipient,
        doctorName: currentUserModel.name,
        doctorUid: currentUserModel.uid,
        createdAt: Timestamp.now(),
        appointmentId: appointment.appointmentUid!,
      ).json;

      var thisUser = auth.currentUser!.uid;
      String chatroom = generateRoomId(recipient);

      await firstMessageText(
          chatroom, recipient, thisUser, newMessage, appointment);
      debugPrint('First message sent');
    } catch (e) {
      debugPrint('Error sending first message: $e');
    }
  }

  Future<void> firstMessageText(
      String chatroom,
      String recipient,
      String thisUser,
      Map<String, dynamic> newMessage,
      AppointmentModel appointment) async {
    if (_isDisposed) return;
    debugPrint('Sending first message text to chatroom: $chatroom');
    await firestore.collection('consultation-chatrooms').doc(chatroom).set({
      'chatroom': chatroom,
      'members': FieldValue.arrayUnion([
        recipient,
        thisUser,
      ])
    }).then(
      (snap) async {
        // Ensure the appointment document exists
        String appointmentId = appointment.appointmentUid!;
        DocumentReference<Map<String, dynamic>> appointmentDocRef = firestore
            .collection('consultation-chatrooms')
            .doc(chatroom)
            .collection('appointments')
            .doc(appointmentId);

        // Handle appointment timing logic
        await _handleAppointmentTiming(appointmentId, appointment);

        DocumentSnapshot<Map<String, dynamic>> appointmentDoc =
            await appointmentDocRef.get();
        if (!appointmentDoc.exists) {
          // Create appointment document if it doesn't exist
          debugPrint('Creating appointment document');
          await appointmentDocRef.set({'createdAt': Timestamp.now()});
        }

        // Add the message
        debugPrint('Adding message to Firestore');
        await firestore
            .collection('consultation-chatrooms')
            .doc(chatroom)
            .collection('appointments')
            .doc(appointmentId)
            .collection('messages')
            .add(newMessage)
            .then(
          (value) async {
            await firestore
                .collection('doctors')
                .doc(auth.currentUser!.uid)
                .update({
              'chatrooms': FieldValue.arrayUnion([chatroom])
            }).then(
              (value) async {
                await firestore.collection('patients').doc(recipient).update(
                  {
                    'chatrooms': FieldValue.arrayUnion([chatroom])
                  },
                );
                subscribe();
              },
            );
          },
        );
      },
    );
  }

  //------------------------Send Message------------------------
  Future<void> sendMessage({
    String message = '',
    required String recipient,
    required AppointmentModel appointment,
  }) async {
    if (_isDisposed) return;
    debugPrint('Sending message to recipient: $recipient');
    var thisUser = auth.currentUser!.uid;
    await sendMessageText(recipient, message, thisUser, appointment);
    monitorAppointmentStatus(appointment.appointmentUid!); // Add this line
  }

  Future<DocumentReference<Map<String, dynamic>>> sendMessageText(
    String recipient,
    String message,
    String thisUser,
    AppointmentModel appointment,
  ) async {
    if (_isDisposed) return Future.error('Controller is disposed');
    debugPrint('Sending message text to recipient: $recipient');
    // Fetch the patients's details
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await firestore.collection('patients').doc(recipient).get();

    String patientName = docSnapshot.data()?['name'] ?? 'Unknown Doctor';

    // Define the structure with appointmentUid
    String appointmentId = appointment.appointmentUid!;
    debugPrint('Appointment ID: $appointmentId');

    // Handle appointment timing logic
    await _handleAppointmentTiming(appointmentId, appointment);

    if (chatroom == null || chatroom!.isEmpty) {
      throw Exception('Chatroom ID is not set');
    }

    // Ensure the chatroom document exists
    DocumentReference<Map<String, dynamic>> chatroomDocRef =
        firestore.collection('consultation-chatrooms').doc(chatroom);

    DocumentSnapshot<Map<String, dynamic>> chatroomDoc =
        await chatroomDocRef.get();
    if (!chatroomDoc.exists) {
      // Create chatroom document if it doesn't exist
      debugPrint('Creating chatroom document');
      await chatroomDocRef.set({'createdAt': Timestamp.now()});
    }

    // Ensure the appointment document exists
    DocumentReference<Map<String, dynamic>> appointmentDocRef = firestore
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('appointments')
        .doc(appointmentId);

    DocumentSnapshot<Map<String, dynamic>> appointmentDoc =
        await appointmentDocRef.get();
    if (!appointmentDoc.exists) {
      // Create appointment document if it doesn't exist
      debugPrint('Creating appointment document');
      await appointmentDocRef.set({'createdAt': Timestamp.now()});
    }

    // Add the message
    debugPrint('Adding message to Firestore');
    DocumentReference<Map<String, dynamic>> messageRef = await firestore
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('appointments')
        .doc(appointmentId)
        .collection('messages')
        .add(ChatMessageModel(
          authorUid: auth.currentUser!.uid,
          authorName: doctor!.name,
          patientName: patientName,
          patientUid: recipient,
          doctorName: doctor!.name,
          doctorUid: doctor!.uid,
          message: message,
          createdAt: Timestamp.now(),
          appointmentId: appointmentId,
        ).json);

    return messageRef;
  }

  Future<void> _handleAppointmentTiming(
    String appointmentId,
    AppointmentModel appointment,
  ) async {
    debugPrint(
        'Handling appointment timing for appointment ID: $appointmentId');
    if (chatroom == null) {
      throw Exception('Chatroom is not set');
    }

    DocumentReference<Map<String, dynamic>> appointmentDocRef = firestore
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('appointments')
        .doc(appointmentId);

    DocumentSnapshot<Map<String, dynamic>> appointmentDoc =
        await appointmentDocRef.get();

    if (_isDisposed) return;

    Map<String, dynamic>? appointmentData = appointmentDoc.data();
    Timestamp currentTimestamp = Timestamp.now();
    bool isCompleted =
        appointment.appointmentStatus == AppointmentStatus.completed.index;

    if (appointmentData == null) {
      // First message, set startTime
      debugPrint('Setting startTime for appointment');
      await appointmentDocRef
          .set({'startTime': currentTimestamp}, SetOptions(merge: true));
      debugPrint('startTime set to $currentTimestamp');
    } else {
      // Update the document with the new data
      Map<String, dynamic> updateData = {};
      if (isCompleted) {
        updateData['actualEndTime'] = currentTimestamp;
        debugPrint('actualEndTime set to $currentTimestamp');
      }
      if (updateData.isNotEmpty) {
        debugPrint('Updating appointment document with $updateData');
        await appointmentDocRef.set(updateData, SetOptions(merge: true));
      }
    }
  }

  //------------------------Monitor Appointment Status------------------------
  void monitorAppointmentStatus(String appointmentId) {
    if (_isDisposed) return;
    debugPrint(
        'Monitoring appointment status for appointment ID: $appointmentId');
    firestore
        .collection('appointments') // Top-level collection
        .doc(appointmentId) // Appointment document
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        var data = snapshot.data()!;
        debugPrint('Appointment data: $data');
        // Check if the status matches "completed"
        if (data['appointmentStatus'] == AppointmentStatus.completed.index) {
          debugPrint('Appointment status is completed');
          await _updateEndTime(
              appointmentId, data['appointmentDate'], data['appointmentTime']);
        }
      } else {
        debugPrint('Appointment document does not exist');
      }
    });
  }

  Future<void> _updateEndTime(String appointmentId, String appointmentDate,
      String appointmentTime) async {
    if (_isDisposed) return;
    debugPrint('Updating endTime for appointment: $appointmentId');

    DocumentReference<Map<String, dynamic>> appointmentDocRef = firestore
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('appointments')
        .doc(appointmentId);

    // Fetch the last message's timestamp
    QuerySnapshot<Map<String, dynamic>> lastMessageSnapshot = await firestore
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('appointments')
        .doc(appointmentId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    Timestamp lastMessageTime;

    if (lastMessageSnapshot.docs.isNotEmpty) {
      // Use the last message's timestamp
      lastMessageTime = lastMessageSnapshot.docs.first.data()['createdAt'];
    } else {
      // Use current timestamp as fallback
      lastMessageTime = Timestamp.now();
    }

    // Extract the scheduled end time from the appointmentDate and appointmentTime strings
    DateFormat dateFormat =
        DateFormat('MMMM d, yyyy'); // Adjust the format as needed
    DateFormat timeFormat =
        DateFormat('hh:mm a'); // Adjust the format as needed
    final DateTime date = dateFormat.parse(appointmentDate.trim());
    final DateTime endTime =
        timeFormat.parse(appointmentTime.split(' - ')[1].trim());
    final DateTime scheduledEndDateTime =
        DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
    Timestamp scheduledEndTime = Timestamp.fromDate(scheduledEndDateTime);

    // Update the appointment document
    await appointmentDocRef.set({
      'lastMessageTime': lastMessageTime,
      'scheduledEndTime': scheduledEndTime,
      'actualEndTime': Timestamp.now()
    }, SetOptions(merge: true));
    debugPrint('lastMessageTime updated successfully to $lastMessageTime');
    debugPrint('scheduledEndTime updated successfully to $scheduledEndTime');
    debugPrint('actualEndTime updated successfully to ${Timestamp.now()}');
  }

  Stream<AppointmentModel> getAppointmentStatusStream(String appointmentId) {
    if (_isDisposed) return Stream.empty();
    debugPrint('Starting appointment status stream for ID: $appointmentId');

    return firestore
        .collection('appointments')
        .doc(appointmentId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        debugPrint('Appointment not found in stream: $appointmentId');
        throw Exception('Appointment not found');
      }

      var data = snapshot.data()!;
      debugPrint(
          'Real-time appointment update received: Status=${data['appointmentStatus']}');

      return AppointmentModel.fromDocumentSnap(snapshot);
    });
  }
}
