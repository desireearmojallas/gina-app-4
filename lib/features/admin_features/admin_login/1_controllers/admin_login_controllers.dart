import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User? currentAdmin;

class AdminLoginControllers with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late StreamSubscription authStream;
  FirebaseAuthException? error;
  bool working = false;

  AdminLoginControllers() {
    authStream = auth.authStateChanges().listen((User? admin) async {
      currentAdmin = admin;

      notifyListeners();
    });
  }

  Future<void> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential adminCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? admin = adminCredential.user;
      if (admin != null) {
        final CollectionReference adminCollection =
            FirebaseFirestore.instance.collection('admin');
        DocumentSnapshot adminSnapshot =
            await adminCollection.doc(admin.uid).get();
        if (adminSnapshot.exists &&
            (adminSnapshot.data() as Map<String, dynamic>)['isAdmin'] == true) {
          working = true;
          currentAdmin = admin;
          error = null;
          notifyListeners();
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      currentAdmin = null;
      working = false;
      error = e;
      notifyListeners();
      throw Exception(e.toString());
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      currentAdmin = null;
      error = FirebaseAuthException(
        code: 'Invalid Credentials',
        message: 'You are not authorized to access this page.',
      );
      notifyListeners();
      if (error != null) {
        throw Exception(e.toString());
      } else {
        throw Exception('You are not authorized to access this page.');
      }
    }
  }

  Future<void> adminLogout() async {
    try {
      await auth.signOut();
      currentAdmin = null;
      working = false;
      error = null;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(
        code: 'error',
        message: e.toString(),
      );
      notifyListeners();
    }
  }
}
