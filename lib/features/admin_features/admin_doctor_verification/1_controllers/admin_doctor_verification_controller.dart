import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_verification_model.dart';

class AdminDoctorVerificationController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  FirebaseAuthException? error;
  bool working = false;

  //--------------- GET ALL DOCTORS -------------------

  Future<Either<Exception, List<DoctorModel>>> getAllDoctors() async {
    try {
      final doctorSnapshot = await firestore.collection('doctors').get();

      if (doctorSnapshot.docs.isNotEmpty) {
        final doctorList = doctorSnapshot.docs
            .map((doctor) => DoctorModel.fromJson(doctor.data()))
            .toList();

        return Right(doctorList);
      }

      return const Right([]);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      error = e;
      return Left(
        Exception(e.message),
      );
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }

  //---------- GET DOCTOR SUBMITTED MEDICAL LICENSE ---------------

  Future<Either<Exception, List<DoctorVerificationModel>>>
      getDoctorSubmittedMedicalLicense() {
    return Future.value(const Right([]));
  }

  //---------- APPROVE DOCTOR VERIFICATION ---------------

  Future<Either<Exception, bool>> approveDoctorVerification() {
    return Future.value(const Right(true));
  }

  //---------- DECLINE DOCTOR VERIFICATION ---------------

  Future<Either<Exception, bool>> declineDoctorVerification() {
    return Future.value(const Right(true));
  }
}
