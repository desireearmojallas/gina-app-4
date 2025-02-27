import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';

class DoctorForumBadgeController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentDoctor;
  FirebaseAuthException? error;
  bool working = false;

  DoctorForumBadgeController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentDoctor = user;
      notifyListeners();
    });
  }

  Future<void> deletePostsNumberIfFirstDayOfMonth() async {
    final DateTime now = DateTime.now();

    if (now.day == 1) {
      try {
        final QuerySnapshot<Map<String, dynamic>> doctorsSnapshot =
            await firestore.collection('doctors').get();

        for (final doc in doctorsSnapshot.docs) {
          await firestore.collection('doctors').doc(doc.id).update({
            'createdPosts': FieldValue.delete(),
            'repliedPosts': FieldValue.delete(),
          });
        }
      } catch (e) {
        debugPrint('Failed to delete posts: $e');
      }
    }
  }

  Future<void> getDoctorPostsCount() async {
    try {
      await deletePostsNumberIfFirstDayOfMonth();

      DocumentSnapshot<Map<String, dynamic>> doctorSnapshot =
          await firestore.collection('doctors').doc(currentDoctor!.uid).get();

      if (doctorSnapshot.exists) {
        final doctorData = doctorSnapshot.data();

        final createdPosts = doctorData!['createdPosts'] != null
            ? List<String>.from(doctorData['createdPosts'])
            : <String>[];

        final repliedPosts = doctorData['repliedPosts'] != null
            ? List<String>.from(doctorData['repliedPosts'])
            : <String>[];

        final postsCount = createdPosts.length + repliedPosts.length;

        DoctorRating newRating;

        if (postsCount >= 50) {
          newRating = DoctorRating.topDoctor;
        } else if (postsCount >= 10) {
          newRating = DoctorRating.activeDoctor;
        } else if (postsCount >= 1) {
          newRating = DoctorRating.contributingDoctor;
        } else {
          newRating = DoctorRating.inactiveDoctor;
        }

        await firestore
            .collection('doctors')
            .doc(currentDoctor!.uid)
            .update({'doctorRatingId': newRating.index});
      }
    } catch (e) {
      debugPrint('Failed to get doctor posts count: $e');
    }
  }
}
