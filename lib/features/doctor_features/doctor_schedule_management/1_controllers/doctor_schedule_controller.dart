import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/doctor_features/doctor_schedule_management/0_models/doctor_schedule_management.dart';

class DoctorScheduleController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorScheduleController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<Either<Exception, ScheduleModel>> getDoctorSchedule() async {
    try {
      final doctorScheduleDoc =
          await firestore.collection('doctors').doc(currentUser!.uid).get();

      final data = doctorScheduleDoc.data();
      if (data != null) {
        final scheduleData = data['schedule'] ?? {};
        return Right(ScheduleModel.fromJson({
          'days': scheduleData['days'],
          'startTimes': scheduleData['startTimes'],
          'endTimes': scheduleData['endTimes'],
          'modeOfAppointment': scheduleData['modeOfAppointment'],
          'name': data['name'],
          'medicalSpecialty': data['medicalSpecialty'],
          'officeAddress': data['officeAddress'],
        }));
      } else {
        return Left(Exception('No schedule found'));
      }
    } catch (e) {
      debugPrint('Error retrieving schedule: $e');
      return Left(
        Exception('Error retrieving schedule: $e'),
      );
    }
  }
}
