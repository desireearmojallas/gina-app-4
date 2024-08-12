import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/auth/1_controllers/doctor_auth_controller.dart';

User? currentPatient;

class AuthenticationController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late StreamSubscription authStream;
  FirebaseAuthException? error;
  bool working = false;

  AuthenticationController() {
    authStream = auth.authStateChanges().listen((User? patient) async {
      currentPatient = patient;
      currentDoctor = null;
      notifyListeners();
    });
  }

  Future<String?> getAccountType(String uid) async {
    DocumentSnapshot patientSnapshot =
        await FirebaseFirestore.instance.collection('patients').doc(uid).get();

    if (patientSnapshot.exists) {
      Map<String, dynamic> userData =
          patientSnapshot.data() as Map<String, dynamic>;

      if (userData.containsKey('accountType')) {
        String accountTypeFirebase = userData['accountType'] as String;
        return accountTypeFirebase;
      } else {
        return null;
      }
    } else {
      DocumentSnapshot doctorSnapshot =
          await FirebaseFirestore.instance.collection('doctors').doc(uid).get();

      if (doctorSnapshot.exists) {
        Map<String, dynamic> doctorData =
            doctorSnapshot.data() as Map<String, dynamic>;

        if (doctorData.containsKey('accountType')) {
          String accountTypeFirebase = doctorData['accountType'] as String;
          return accountTypeFirebase;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  //----------Patient Login----------
  Future<void> patientLogin({
    required String email,
    required String password,
    required String accountType,
  }) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw Exception('Login failed');
      }
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(result.user!.uid)
          .get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      String accountTypeFirebase = userData['accountType'] as String;

      // Perform account type check
      if (accountTypeFirebase != 'Patient') {
        throw Exception('Invalid account type');
      }
      working = false;
      currentPatient = result.user;
      error = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      currentPatient = null;
      error = e;
      notifyListeners();
      throw Exception(e.toString());
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      currentPatient = null;
      error = FirebaseAuthException(
        code: 'unknown',
        message: e.toString(),
      );

      notifyListeners();

      if (error != null) {
        throw Exception(e.toString());
      } else {
        throw Exception('Unknown error occured');
      }
    }
  }

  //----------Patient Register----------
  Future registerPatient({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String dateOfBirth,
    required String address,
  }) async {
    try {
      working = true;
      notifyListeners();
      UserCredential createdUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (createdUser.user != null) {
        UserModel userModel = UserModel(
          uid: createdUser.user!.uid,
          name: name,
          email: email,
          gender: gender,
          dateOfBirth: dateOfBirth,
          profileImage: '',
          headerImage: '',
          address: address,
          created: Timestamp.now(),
          updated: Timestamp.now(),
          accountType: 'Patient',
          appointmentsBooked: const [],
          chatrooms: const [],
        );

        await FirebaseFirestore.instance
            .collection('patients')
            .doc(userModel.uid)
            .set(userModel.json);

        working = false;
        currentPatient = createdUser.user;
        error = null;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      currentPatient = null;
      error = e;
      notifyListeners();
      throw Exception(e.message);
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      currentPatient = null;
      error = FirebaseAuthException(
        code: 'unknown',
        message: e.toString(),
      );
      notifyListeners();
      throw Exception(e.toString());
    }
  }

  //----------Patient Logout----------
  Future<void> logout() async {}

  Future<bool> checkEmailVerified() async {
    User? user = auth.currentUser;
    if (user == null) {
      // User is not logged in
      return false;
    } else {
      // User is logged in, check if email is verified
      await user.reload();
      user = auth.currentUser;
      return user!.emailVerified;
    }
  }
}
