import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';

class DoctorProfileController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
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
          await FirebaseFirestore.instance
              .collection('doctors')
              .doc(currentUser!.uid)
              .get();

      DoctorModel userModel = DoctorModel.fromJson(userSnapshot.data()!);

      return userModel.name;
    } catch (e) {
      throw Exception('Failed to get current user\'s name: ${e.toString()}');
    }
  }

  // TODO: FUTURE GET DOCTOR PROFILE
  // TODO: FUTURE VOID EDIT DOCTOR DATA
}
