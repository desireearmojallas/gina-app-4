import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class AdminDashboardController {
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
      error = FirebaseAuthException(code: 'error', message: e.toString());
      return Left(Exception(e.toString()));
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(code: 'error', message: e.toString());
      return Left(Exception(e.toString()));
    }
  }

  //--------------- GET ALL PATIENTS -------------------

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
      error = FirebaseAuthException(code: 'error', message: e.toString());
      return Left(Exception(e.toString()));
    }
  }

  //--------------- GET ALL APPOINTMENTS -------------------

  Future<Either<Exception, List<AppointmentModel>>> getAllAppointments() async {
    try {
      final appointmentSnapshot =
          await firestore.collection('appointments').get();

      if (appointmentSnapshot.docs.isNotEmpty) {
        final appointmentList = appointmentSnapshot.docs
            .map((appointment) => AppointmentModel.fromJson(appointment.data()))
            .toList();

        appointmentList.sort((a, b) => DateFormat('MMMM d, yyyy')
            .parse(a.appointmentDate!)
            .compareTo(DateFormat('MMMM d, yyyy').parse(b.appointmentDate!)));

        return Right(appointmentList);
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
      error = FirebaseAuthException(code: 'error', message: e.toString());
      return Left(Exception(e.toString()));
    }
  }

  //--------------- GET ALL DOCTOR APPOINTMENTS DRAFT -------------------

  Future<Either<Exception, List<AppointmentModel>>>
      getCurrentDoctorAppointment({
    required doctorUid,
  }) async {
    try {
      final snapshot = await firestore
          .collection('appointments')
          .where('doctorUid', isEqualTo: doctorUid)
          .get();

      List<AppointmentModel> appointments = [];

      for (var element in snapshot.docs) {
        appointments.add(AppointmentModel.fromDocumentSnap(element));
      }

      appointments.sort((a, b) {
        var aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
        var bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
        return aDate.compareTo(bDate);
      });

      return Right(appointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

  //--------------- LOGOUT ADMIN -------------------

  Future<void> logoutAdmin() async {
    try {
      await auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      error = FirebaseAuthException(code: 'error', message: e.toString());
    }
  }
}
