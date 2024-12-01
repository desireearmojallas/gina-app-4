import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class AdminPatientListController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  FirebaseAuthException? error;
  bool working = false;

  Future<Either<Exception, List<UserModel>>> getAllPatients() async {
    try {
      final patientSnapshot = await firestore.collection('patients').get();

      if (patientSnapshot.docs.isNotEmpty) {
        final patientList = patientSnapshot.docs
            .map((patient) => UserModel.fromJson(patient.data()))
            .toList();
        return Right(patientList);
      }
      return const Right([]);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      error = e;
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }

  Future<Either<Exception, List<AppointmentModel>>>
      getCurrentPatientAppointment({
    required patientUid,
  }) async {
    try {
      final snapshot = await firestore
          .collection('appointments')
          .where('patientUid', isEqualTo: patientUid)
          .get();

      List<AppointmentModel> appointmentList = [];

      for (var element in snapshot.docs) {
        appointmentList.add(AppointmentModel.fromDocumentSnap(element));
      }

      appointmentList.sort((a, b) {
        var aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
        var bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
        return aDate.compareTo(bDate);
      });

      return Right(appointmentList);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }
}
