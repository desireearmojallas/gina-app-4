import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';

class MyForumsController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  MyForumsController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<Either<Exception, List<ForumModel>>> getListOfMyForumsPost() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await firestore
          .collection('forums')
          .where('posterUid', isEqualTo: currentUser!.uid)
          .get();

      List<ForumModel> forumsPosts = [];

      for (var element in userSnapshot.docs) {
        forumsPosts.add(ForumModel.fromJson(element.data()));
      }

      forumsPosts.sort((a, b) => b.postedAt.compareTo(a.postedAt));

      return Right(forumsPosts);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  Future<Either<Exception, bool>> deleteMyForumsPost(String postId) async {
    try {
      await firestore.collection('forums').doc(postId).delete();
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }
}
