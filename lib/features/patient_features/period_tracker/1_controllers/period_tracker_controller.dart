import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

class PeriodTrackerController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;
  List<PeriodTrackerModel> _periodDates = [];

  PeriodTrackerController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  List<PeriodTrackerModel> get periods => _periodDates;

  Future<void> fetchPeriods() async {
    if (currentUser == null) return;

    working = true;
    notifyListeners();

    try {
      final snapshot = await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('periods')
          .get();

      _periodDates = snapshot.docs
          .map((doc) => PeriodTrackerModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      error = FirebaseAuthException(code: 'unknown', message: e.toString());
    } finally {
      working = false;
      notifyListeners();
    }
  }

  Future<void> logPeriod(DateTime startDate, DateTime endDate) async {
    if (currentUser == null) return;

    try {
      await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('periods')
          .add({
        'startDate': startDate,
        'endDate': endDate,
      });
      await fetchPeriods();
    } catch (e) {
      error = FirebaseAuthException(message: e.toString(), code: 'unknown');
      notifyListeners();
    }
  }

  Future<void> deletePeriod(String id) async {
    if (currentUser == null) return;

    try {
      await firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .collection('periods')
          .doc(id)
          .delete();
      await fetchPeriods();
    } catch (e) {
      error = FirebaseAuthException(message: e.toString(), code: 'unknown');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    authStream.cancel();
    super.dispose();
  }
}
