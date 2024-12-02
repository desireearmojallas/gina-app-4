import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';

class DoctorProfileController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorProfileController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<String> getCurrentDoctorName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection('doctors').doc(currentUser!.uid).get();

      DoctorModel userModel = DoctorModel.fromJson(userSnapshot.data()!);

      return userModel.name;
    } catch (e) {
      throw Exception('Failed to get current user\'s name: ${e.toString()}');
    }
  }

  Future<Either<Exception, DoctorModel>> getDoctorProfile() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection('doctors').doc(currentUser!.uid).get();

      DoctorModel userModel = DoctorModel.fromJson(userSnapshot.data()!);

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  Future<void> editDoctorData({
    required String name,
    required String phoneNumber,
    required String address,
  }) async {
    try {
      working = true;
      notifyListeners();

      await firestore.collection('doctors').doc(currentUser!.uid).update({
        'name': name,
        'officePhoneNumber': phoneNumber,
        'officeAddress': address,
        'updated': Timestamp.now(),
      });
      working = false;
      notifyListeners();
      error = null;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      working = false;
      error = e;
      notifyListeners();
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Error editing doctor data: $e');
      working = false;
      error = FirebaseAuthException(
        code: 'Unknown',
        message: e.toString(),
      );
    }
  }
}
