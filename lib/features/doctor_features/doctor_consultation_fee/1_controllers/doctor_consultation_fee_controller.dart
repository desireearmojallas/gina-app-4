import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';

class DoctorConsultationFeeController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorConsultationFeeController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
    });
  }

  Future<Either<Exception, DoctorModel>> getCurrentDoctor() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection('doctors').doc(currentUser!.uid).get();

      DoctorModel doctorModel = DoctorModel.fromJson(userSnapshot.data()!);

      return Right(doctorModel);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

  Future<void> toggleDoctorConsultationPriceFee() async {
    try {
      await firestore
          .collection('doctors')
          .doc(currentUser!.uid)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> userSnapshot) async {
        bool currentShowConsultationPrice =
            userSnapshot.data()!['showConsultationPrice'];

        await firestore
            .collection('doctors')
            .doc(currentUser!.uid)
            .update({'showConsultationPrice': !currentShowConsultationPrice});
      });
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Error editing doctor data: $e');
      working = false;
      error = FirebaseAuthException(
        code: 'unknown',
        message: e.toString(),
      );
      throw Exception(e.toString());
    }
  }

  Future<void> updateDoctorConsultationFee({
    required double f2fInitialConsultationFee,
    required double f2fFollowUpConsultationFee,
    required double olInitialConsultationFee,
    required double olFollowUpConsultationFee,
  }) async {
    try {
      working = true;

      await firestore.collection('doctors').doc(currentUser!.uid).update({
        'f2fInitialConsultationFee': f2fInitialConsultationFee,
        'f2fFollowUpConsultationFee': f2fFollowUpConsultationFee,
        'olInitialConsultationFee': olInitialConsultationFee,
        'olFollowUpConsultationFee': olFollowUpConsultationFee,
      });

      working = false;
      error = null;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      working = false;
      error = e;
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Error editing doctor data: $e');
      working = false;
      error = FirebaseAuthException(
        code: 'unknown',
        message: e.toString(),
      );
      throw Exception(e.toString());
    }
  }
}
