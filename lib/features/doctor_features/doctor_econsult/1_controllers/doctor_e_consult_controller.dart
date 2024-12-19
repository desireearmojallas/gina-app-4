import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:intl/intl.dart';

class DoctorEConsultController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentDoctor;
  FirebaseAuthException? error;
  bool working = false;

  DoctorEConsultController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentDoctor = user;
    });
  }

  //------------- GET UPCOMING DOCTOR APPOINTMENTS ----------------

  Future<Either<Exception, AppointmentModel>>
      getUpcomingDoctorAppointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentDoctor!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.confirmed.index)
          .where('modeOfAppointment',
              isEqualTo: ModeOfAppointmentId.onlineConsultation.index)
          .get();

      var patientAppointment = appointmentSnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) {
          final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
          final bDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);

          return aDate
              .difference(DateTime.now())
              .abs()
              .compareTo(bDate.difference(DateTime.now()).abs());
        });

      if (patientAppointment.isNotEmpty) {
        return Right(patientAppointment.first);
      } else {
        return Right(AppointmentModel());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

  //------------- GET UPCOMING DOCTOR APPOINTMENTS LIST ----------------

  Future<Either<Exception, List<AppointmentModel>>>
      getUpcomingDoctorAppointmentsList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: currentDoctor!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.confirmed.index)
          .get();

      var patientAppointments = appointmentSnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) {
          final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
          final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);

          return aDate
              .difference(DateTime.now())
              .abs()
              .compareTo(bDate.difference(DateTime.now()).abs());
        });

      return Right(patientAppointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

  //------------- GET DOCTOR CHATROOMS AND MESSAGES ----------------

  Future<Either<Exception, List<ChatMessageModel>>>
      getDoctorChatroomsAndMessages() async {
    try {
      QuerySnapshot<Map<String, dynamic>> chatroomSnapshot = await firestore
          .collection('consultation-chatrooms')
          .where('members', arrayContains: currentDoctor!.uid)
          .get();

      var chatroomDocs = chatroomSnapshot.docs;
      List<Future<ChatMessageModel?>> chatroomMessagesFutures =
          chatroomDocs.map((chatroomDoc) async {
        QuerySnapshot<Map<String, dynamic>> messagesSnapshot = await firestore
            .collection('consultation-chatrooms')
            .doc(chatroomDoc.id)
            .collection('messages')
            .orderBy('createdAt', descending: true)
            .get();

        List<ChatMessageModel> messages = messagesSnapshot.docs
            .map((doc) => ChatMessageModel.fromJson(doc.data()))
            .toList();

        return messages.isNotEmpty ? messages.first : null;
      }).toList();

      List<ChatMessageModel> chatroomMessages =
          (await Future.wait(chatroomMessagesFutures))
              .whereType<ChatMessageModel>()
              .toList();

      return Right(chatroomMessages);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }
}
