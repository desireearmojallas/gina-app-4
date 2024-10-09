import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';

class ProfileController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  ProfileController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<String> getCurrentPatientName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(currentUser!.uid)
              .get();

      UserModel userModel = UserModel.fromJson(userSnapshot.data()!);

      return userModel.name;
    } catch (e) {
      throw Exception('Failed to get current user\'s name: ${e.toString()}');
    }
  }

  Future<Either<Exception, UserModel>> getPatientProfile() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(currentUser!.uid)
              .get();

      UserModel userModel = UserModel.fromJson(userSnapshot.data()!);

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  Future<void> editPatientData({
    required String name,
    required String dateOfBirth,
    required String address,
  }) async {
    try {
      working = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentUser!.uid)
          .update({
        'name': name,
        'dateOfBirth': dateOfBirth,
        'address': address,
        'updated': Timestamp.now(),
      });
      working = false;
      notifyListeners();
      error = null;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      working = false;
      error = e;
      notifyListeners();
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Error editing patient data: $e');
      working = false;
      error = FirebaseAuthException(
        code: 'unknown',
        message: e.toString(),
      );
      notifyListeners();
      throw Exception(e.toString());
    }
  }
}
