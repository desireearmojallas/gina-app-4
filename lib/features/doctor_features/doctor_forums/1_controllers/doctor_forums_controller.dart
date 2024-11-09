import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/0_models/doctor_forum_models.dart';
import 'package:gina_app_4/features/patient_features/forums/0_models/forums_model.dart';

class DoctorForumsController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = false;

  DoctorForumsController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<Either<Exception, ForumModel>> getListOfForumsPost() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('forums')
              .doc(currentUser!.uid)
              .get();

      ForumModel doctorForumModel = ForumModel.fromJson(userSnapshot.data()!);

      return Right(doctorForumModel);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //-------------------CREATE FORUM POSTS-------------------
  Future<Either<Exception, bool>> createForumPost({
    required String title,
    required String content,
    required Timestamp postedAt,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> snap = FirebaseFirestore.instance
          .collection('forums')
          .doc(currentUser!.uid)
          .collection('createdPosts')
          .doc();

      final currentUserModel = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentUser!.uid)
          .get()
          .then((value) => DoctorModel.fromJson(value.data()!));

      await FirebaseFirestore.instance.collection('forums').doc(snap.id).set(
        {
          'id': snap.id,
          'title': title,
          'content': content,
          'postedBy': currentUserModel.name,
          'posterUid': currentUser!.uid,
          // 'profileImage': currentUserModel.profileImage,
          'postedAt': postedAt,
          'isDoctor': true,
          'doctorRatingId': 2,
          'replies': [],
        },
        SetOptions(merge: true),
      );

      final docRef = FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentUser!.uid);

      await docRef.update({
        'createdPosts': FieldValue.arrayUnion([snap.id]),
        //TODO: KEEP IN MIND THIS PART OF FORUMS THE DOCTOR RATING ID IN CASE THIS CAUSES BUGS
        'doctorRatingId': 2,
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //-------------------GET ALL CREATED POSTS-------------------
  Future<Either<Exception, List<ForumModel>>> getForumPosts() async {
    try {
      final forumSnapshot = await firestore
          .collection('forums')
          .orderBy('postedAt', descending: true)
          .get();

      if (forumSnapshot.docs.isNotEmpty) {
        final allPosts = forumSnapshot.docs
            .map((doc) => ForumModel.fromJson(doc.data()))
            .toList();

        return Right(allPosts);
      } else {
        return const Right([]);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //-------------------GET DOCTOR RATING IDS-------------------
  Future<Either<Exception, List<int>>> getDoctorRatingIds() async {
    try {
      final forumSnapshot = await firestore
          .collection('forums')
          .orderBy('postedAt', descending: true)
          .get();

      if (forumSnapshot.docs.isNotEmpty) {
        final allPosts = forumSnapshot.docs
            .map((doc) => ForumModel.fromJson(doc.data()))
            .toList();

        List<int> doctorRatingIds = [];

        for (var post in allPosts.where((post) => post.posterUid.isNotEmpty)) {
          String posterUid = post.posterUid.replaceAll('"', '').trim();

          final doctorSnapshot =
              await firestore.collection('doctors').doc(posterUid).get();

          if (doctorSnapshot.exists) {
            doctorRatingIds.add(doctorSnapshot.data()!['doctorRatingId']);
          } else {
            doctorRatingIds.add(0);
          }
        }
        return Right(doctorRatingIds);
      } else {
        return const Right([]);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //-------------------GET ALL REPLIES FOR A SPECIFIC POST-------------------
  Future<Either<Exception, List<ForumModel>>> getRepliesPost({
    required String postId,
  }) async {
    try {
      final forumDoc = await firestore.collection('forums').doc(postId).get();

      if (forumDoc.exists) {
        final forumData = forumDoc.data();
        if (forumData != null && forumData.containsKey('replies')) {
          final List<dynamic> repliesData = forumData['replies'];
          final allReplies = repliesData
              .map(
                  (reply) => ForumModel.fromJson(reply as Map<String, dynamic>))
              .toList();
          return Right(allReplies);
        } else {
          return const Right([]);
        }
      } else {
        return const Right([]);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //-------------------GET DOCTOR RATING FOR FETCHED POST-------------------
  Future<Either<Exception, int>> getDoctorRating({
    required String doctorUid,
  }) async {
    try {
      String posterUid = doctorUid.replaceAll('"', '').trim();
      final doctorRatingDoc =
          await firestore.collection('doctors').doc(posterUid).get();

      if (doctorRatingDoc.exists) {
        final doctorRatingData = doctorRatingDoc.data();
        if (doctorRatingData != null &&
            doctorRatingData.containsKey('doctorRatingId')) {
          final int doctorRating = doctorRatingData['doctorRatingId'];
          return Right(doctorRating);
        } else {
          return const Right(0);
        }
      } else {
        return const Right(0);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //-------------------CREATE REPLY-------------------
  Future<Either<Exception, bool>> addReplyToPost({
    required ForumModel forumPost,
    required String replyContent,
    required Timestamp repliedAt,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> snap = FirebaseFirestore.instance
          .collection('forums')
          .doc(forumPost.postId)
          .collection('replies')
          .doc();

      final currentUserModel = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentUser!.uid)
          .get()
          .then((value) => DoctorModel.fromJson(value.data()!));

      final DoctorForumModel replyModel = DoctorForumModel(
        postId: snap.id,
        posterUid: currentUser!.uid,
        title: '',
        content: replyContent,
        postedBy: currentUserModel.name,
        profileImage: '',
        postedAt: repliedAt,
        isDoctor: true,
        doctorRatingId: currentUserModel.doctorRatingId,
        replies: const [],
      );

      final Map<String, dynamic> replyJson = replyModel.toJson();
      await FirebaseFirestore.instance
          .collection('forums')
          .doc(forumPost.postId)
          .update({
        'replies': FieldValue.arrayUnion([replyJson]),
      });

      final docRef = FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentUser!.uid);

      await docRef.update({
        'repliedPosts': FieldValue.arrayUnion([forumPost.postId]),
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }
}
