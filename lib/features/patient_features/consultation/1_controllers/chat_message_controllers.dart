import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat

class ChatMessageController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription chatSub;
  late StreamSubscription authStream;
  User? currentUser;
  UserModel? patient;
  // final StreamController<String?> controller = StreamController();
  final StreamController<String?> controller = StreamController.broadcast();
  Stream<String?> get stream => controller.stream;
  String? chatroom;
  late String recipient;
  List<ChatMessageModel> messages = [];
  Map<String, List<ChatMessageModel>> appointmentMessages = {};
  Map<String, Map<String, dynamic>> appointmentTimes = {};
  final StreamController<List<dynamic>> _messageStreamController =
      StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get messageStream => _messageStreamController.stream;
  StreamSubscription? _appointmentStatusSubscription;

  bool _isDisposed = false;

  ChatMessageController() {
    debugPrint('ChatMessageController initialized');
    chatSub = const Stream.empty().listen((_) {});
    if (chatroom != null) {
      subscribe();
    } else {
      controller.add('empty');
    }

    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      debugPrint('Auth state changed: $user');
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    debugPrint('Disposing ChatMessageController');
    _isDisposed = true;
    authStream.cancel();
    controller.close();
    chatSub.cancel();
    _messageStreamController.close();
    _appointmentStatusSubscription?.cancel();
    super.dispose();
  }

  subscribe() {
    if (_isDisposed) return;
    debugPrint('Subscribing to chat updates');
    chatSub = ChatMessageModel.individualCurrentChats(
            chatroom!, selectedDoctorAppointmentModel!.appointmentUid!)
        .listen(chatUpdateHandler);
    controller.add('success');
    monitorAppointmentStatus(selectedDoctorAppointmentModel!.appointmentUid!);
  }

  getChatRoom(String room, String currentRecipient) async {
    if (_isDisposed) return;
    debugPrint('Getting chat room: $room for recipient: $currentRecipient');

    // Set recipient and chatroom values
    recipient = currentRecipient;
    chatroom = room;

    try {
      // 1. Get patient model
      patient = await UserModel.fromUid(uid: auth.currentUser!.uid);

      // 2. First check if patient already has this chatroom
      if (patient != null && patient!.chatrooms.contains(room)) {
        debugPrint('Chatroom found in patient list, subscribing to updates');
        subscribe();
        return;
      }

      // 3. If not in patient list, check if it exists in Firestore
      DocumentSnapshot<Map<String, dynamic>> chatroomDoc =
          await firestore.collection('consultation-chatrooms').doc(room).get();

      if (chatroomDoc.exists) {
        debugPrint('Chatroom exists in Firestore but not in patient list!');

        // 4. Set up the listener for this room
        chatSub = firestore
            .collection('consultation-chatrooms')
            .doc(room)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            debugPrint('CRITICAL: Chatroom update detected!');
            // When chatroom changes, call chatUpdateHandler
            chatUpdateHandler([]);
          }
        });

        // 5. Run initial check immediately
        await chatUpdateHandler([]);

        // 6. Set initial state to empty (will be updated by chatUpdateHandler if messages exist)
        if (controller.hasListener) {
          controller.add('empty');
        }
      } else {
        // Chatroom doesn't exist yet
        debugPrint('Chatroom does not exist yet: $room');
        controller.add('empty');
      }
    } catch (e) {
      debugPrint('Error in getChatRoom: $e');
      controller.add(e.toString());
    }
  }

  Future<String?> initChatRoom(String room, String currentRecipient) async {
    if (_isDisposed) return Future.value(null);
    debugPrint(
        'Initializing chat room: $room for recipient: $currentRecipient');
    // recipient = currentRecipient;
    // patient = await UserModel.fromUid(uid: auth.currentUser!.uid);
    // if (patient != null && patient!.chatrooms.contains(room)) {
    //   chatroom = room;
    //   subscribe();
    //   monitorAppointmentStatus(
    //       selectedDoctorAppointmentModel!.appointmentUid!); // Add this line
    // } else {
    //   controller.add('empty');
    // }
    // return chatroom;

    UserModel.fromUid(uid: FirebaseAuth.instance.currentUser!.uid)
        .then((value) {
      recipient = currentRecipient;
      patient = value;
      if (patient != null && patient!.chatrooms.contains(room)) {
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
    debugPrint('Generating room ID for recipient: $recipientUid');
    String currentPatientUid = auth.currentUser!.uid;

    if (currentPatientUid.codeUnits[0] >= recipientUid.codeUnits[0]) {
      if (currentPatientUid.codeUnits[1] == recipientUid.codeUnits[1]) {
        return chatroom = recipientUid + currentPatientUid;
      }
      return chatroom = currentPatientUid + recipientUid;
    }
    return chatroom = recipientUid + currentPatientUid;
  }

  //! continue here... try to fix the seenby feature

  // chatUpdateHandler(List<ChatMessageModel> update) async {
  //   if (_isDisposed) return;
  //   debugPrint('Handling chat update');
  //   Map<String, List<ChatMessageModel>> allMessages = {};
  //   Map<String, Map<String, dynamic>> allTimes = {};

  //   // Fetch all appointments for the current chatroom
  //   QuerySnapshot<Map<String, dynamic>> appointmentsSnapshot = await firestore
  //       .collection('consultation-chatrooms')
  //       .doc(chatroom)
  //       .collection('appointments')
  //       .get();

  //   for (var appointmentDoc in appointmentsSnapshot.docs) {
  //     String appointmentId = appointmentDoc.id;
  //     Map<String, dynamic> appointmentData = appointmentDoc.data();

  //     // Fetch messages for each appointment
  //     QuerySnapshot<Map<String, dynamic>> messagesSnapshot = await firestore
  //         .collection('consultation-chatrooms')
  //         .doc(chatroom)
  //         .collection('appointments')
  //         .doc(appointmentId)
  //         .collection('messages')
  //         .orderBy('createdAt')
  //         .get();

  //     List<ChatMessageModel> messages = messagesSnapshot.docs.map((doc) {
  //       ChatMessageModel message = ChatMessageModel.fromDocumentSnap(doc);
  //       debugPrint('Fetched message with uid: ${message.uid}');
  //       return message;
  //     }).toList();

  //     // Update seen status for messages
  //     for (ChatMessageModel message in messages) {
  //       if (message.hasNotSeenMessage(auth.currentUser!.uid)) {
  //         try {
  //           await message.individualUpdateSeen(
  //               auth.currentUser!.uid, chatroom!, appointmentId);
  //           debugPrint('Updated seenBy for message: ${message.uid}');
  //         } catch (e) {
  //           debugPrint(
  //               'Failed to update seenBy for message: ${message.uid}, error: $e');
  //         }
  //       }
  //     }

  //     // Fetch the appointment status from the top-level collection
  //     DocumentSnapshot<Map<String, dynamic>> appointmentStatusSnapshot =
  //         await firestore.collection('appointments').doc(appointmentId).get();

  //     bool isCompleted = appointmentStatusSnapshot.exists &&
  //         appointmentStatusSnapshot.data()?['appointmentStatus'] ==
  //             AppointmentStatus.completed.index;

  //     allMessages[appointmentId] = messages;
  //     allTimes[appointmentId] = {
  //       'startTime': appointmentData['startTime'],
  //       'scheduledEndTime': appointmentData['scheduledEndTime'],
  //       'lastMessageTime':
  //           isCompleted && messages.isNotEmpty ? messages.last.createdAt : null,
  //     };
  //   }

  //   // Sort the appointments by startTime
  //   var sortedEntries = allTimes.entries.toList()
  //     ..sort((a, b) {
  //       Timestamp? startTimeA = a.value['startTime'];
  //       Timestamp? startTimeB = b.value['startTime'];

  //       if (startTimeA == null || startTimeB == null) {
  //         // Handle the case where either startTimeA or startTimeB is null
  //         return 0; // or any other logic you want to apply
  //       }

  //       return startTimeA.compareTo(startTimeB);
  //     });

  //   // Create sorted maps
  //   Map<String, List<ChatMessageModel>> sortedMessages = {};
  //   Map<String, Map<String, dynamic>> sortedTimes = {};

  //   for (var entry in sortedEntries) {
  //     String appointmentId = entry.key;
  //     sortedMessages[appointmentId] = allMessages[appointmentId]!;
  //     sortedTimes[appointmentId] = allTimes[appointmentId]!;
  //   }

  //   if (appointmentMessages.isNotEmpty) {
  //     String latestAppointmentId = sortedEntries.last.key;
  //     _messageStreamController
  //         .add(appointmentMessages[latestAppointmentId] ?? []);
  //   }

  //   appointmentMessages = sortedMessages;
  //   appointmentTimes = sortedTimes;
  //   notifyListeners();
  // }

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

    // Check if this is the first time the chatroom has been created
    bool isFirstTimeSetup =
        appointmentMessages.isEmpty && appointmentsSnapshot.docs.isNotEmpty;

    if (isFirstTimeSetup) {
      debugPrint(
          'First-time chatroom setup detected - Doctor may have sent first message');
    }

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
        Timestamp? startTimeA = a.value['startTime'];
        Timestamp? startTimeB = b.value['startTime'];

        if (startTimeA == null || startTimeB == null) {
          // Handle the case where either startTimeA or startTimeB is null
          return 0; // or any other logic you want to apply
        }

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

    // Handle initial setup or ongoing chats
    if (isFirstTimeSetup && sortedEntries.isNotEmpty) {
      String firstAppointmentId = sortedEntries.first.key;
      List<ChatMessageModel> firstMessages =
          allMessages[firstAppointmentId] ?? [];

      if (firstMessages.isNotEmpty) {
        debugPrint(
            'First-time setup: Found ${firstMessages.length} messages in new chatroom');

        // Check if any message is from the doctor
        bool doctorHasMessaged =
            firstMessages.any((msg) => msg.authorUid == recipient);

        if (doctorHasMessaged) {
          debugPrint(
              'CRITICAL: Doctor has sent the first message, transitioning to active chat');
          // More forceful state update
          controller.add('success'); // Update main controller state to success
          _messageStreamController
              .add(firstMessages); // Add messages to the stream

          // Force a notification to listeners
          notifyListeners();
        }
      }
    } else if (appointmentMessages.isNotEmpty && sortedEntries.isNotEmpty) {
      // Standard case for ongoing chats
      String latestAppointmentId = sortedEntries.last.key;
      _messageStreamController
          .add(appointmentMessages[latestAppointmentId] ?? []);
    }

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
        appointmentId: appointment.appointmentUid,
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
                .collection('patients')
                .doc(auth.currentUser!.uid)
                .update({
              'chatrooms': FieldValue.arrayUnion([chatroom])
            }).then(
              (value) async {
                await firestore.collection('doctors').doc(recipient).update(
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
    // Fetch the doctor's details
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await firestore.collection('doctors').doc(recipient).get();

    String doctorName = docSnapshot.data()?['name'] ?? 'Unknown Doctor';

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
          authorName: patient!.name,
          patientName: patient!.name,
          patientUid: patient!.uid,
          doctorName: doctorName,
          doctorUid: recipient,
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
    debugPrint('Monitoring appointment status for ID: $appointmentId');

    // Cancel any existing subscription
    _appointmentStatusSubscription?.cancel();

    _appointmentStatusSubscription = firestore
        .collection('appointments')
        .doc(appointmentId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        var data = snapshot.data()!;
        debugPrint('Appointment status update received: $data');

        // Check if the status matches "completed"
        if (data['appointmentStatus'] == AppointmentStatus.completed.index) {
          debugPrint('Appointment status changed to completed');
          isAppointmentFinished = true;
          notifyListeners(); // Notify listeners about the status change

          // Still update the end time as before
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

  Future<List<ChatMessageModel>> getMessagesForSpecificAppointment(
      String chatroom, String appointmentUid) async {
    if (_isDisposed) return [];
    debugPrint(
        'Fetching messages for appointment: $appointmentUid in chatroom: $chatroom');

    QuerySnapshot<Map<String, dynamic>> messagesSnapshot = await firestore
        .collection('consultation-chatrooms')
        .doc(chatroom)
        .collection('appointments')
        .doc(appointmentUid)
        .collection('messages')
        .orderBy('createdAt')
        .get();

    List<ChatMessageModel> messages = messagesSnapshot.docs.map((doc) {
      return ChatMessageModel.fromDocumentSnap(doc);
    }).toList();

    return messages;
  }

  // Add this method to the ChatMessageController class
  Stream<AppointmentModel> getAppointmentStatusStream(String appointmentId) {
    if (_isDisposed) return Stream.empty();
    debugPrint(
        'Patient: Starting appointment status stream for ID: $appointmentId');

    return firestore
        .collection('appointments')
        .doc(appointmentId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        debugPrint('Patient: Appointment not found in stream: $appointmentId');
        throw Exception('Appointment not found');
      }

      var data = snapshot.data()!;
      debugPrint(
          'Patient: Real-time appointment update received: Status=${data['appointmentStatus']}');

      return AppointmentModel.fromDocumentSnap(snapshot);
    });
  }

  Future<void> submitRating(int rating, AppointmentModel appointment,
      String selectedDoctorUid) async {
    try {
      debugPrint(
          'Submitting $rating star rating for doctor: $selectedDoctorUid');

      // 1. Update the appointment with the rating - using field name "doctorRating"
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.appointmentUid)
          .update({
        'doctorRating': rating, // Using your existing field name
        'ratedAt': FieldValue.serverTimestamp(),
      });

      // 2. Store rating in separate collection for analytics
      await FirebaseFirestore.instance.collection('doctor-ratings').add({
        'doctorUid': selectedDoctorUid,
        'patientUid': FirebaseAuth.instance.currentUser!.uid,
        'appointmentUid': appointment.appointmentUid,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 3. Update the doctor's document - using field name "doctorRating" (List)
      DocumentReference doctorRef = FirebaseFirestore.instance
          .collection('doctors')
          .doc(selectedDoctorUid);

      // Use a transaction to safely update the ratings array and average
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot doctorSnapshot = await transaction.get(doctorRef);

        if (!doctorSnapshot.exists) {
          throw Exception("Doctor document does not exist!");
        }

        // Get current data
        Map<String, dynamic> doctorData =
            doctorSnapshot.data() as Map<String, dynamic>;

        // Get existing ratings array or create new one - using your field name "doctorRating"
        List<dynamic> ratings =
            List<dynamic>.from(doctorData['doctorRating'] ?? []);

        // Add new rating
        ratings.add(rating);

        // Calculate new average (rounded to 1 decimal place)
        double average = ratings.reduce((a, b) => a + b) / ratings.length;
        // double roundedAverage = (average * 10).round() / 10;

        // Update the doctor document
        transaction.update(doctorRef, {
          'doctorRating': ratings, // Using your existing field name
          'averageRating': average, // Add calculated average for convenience
          'ratingsCount': ratings.length, // Add count for convenience
          'lastRatedAt': FieldValue.serverTimestamp(),
        });
      });

      debugPrint('Rating submitted successfully: $rating stars');
    } catch (e) {
      debugPrint('Error submitting rating: $e');
    }
  }
}
