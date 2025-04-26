import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/0_model/app_settings_model.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';

class AdminSettingsController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuthException? error;
  bool working = false;

  // Get all users of a specific type (patients or doctors)
  Future<Either<Exception, List<Map<String, dynamic>>>> getUsers(
      String userType) async {
    try {
      working = true;
      final collectionName = userType.toLowerCase();
      final snapshot = await firestore.collection(collectionName).get();

      if (snapshot.docs.isEmpty) {
        working = false;
        return const Right([]);
      }

      List<Map<String, dynamic>> users = [];

      if (collectionName == 'doctors') {
        final doctorList = snapshot.docs
            .map((doc) => DoctorModel.fromJson(doc.data()))
            .toList();

        users = doctorList.map((doctor) {
          final data = doctor.json;
          // Add necessary fields for UI
          data['id'] = doctor.uid;
          data['type'] = 'Doctor';
          return data;
        }).toList();
      } else if (collectionName == 'patients') {
        final patientList =
            snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();

        users = patientList.map((patient) {
          final data = patient.json;
          // Add necessary fields for UI
          data['id'] = patient.uid;
          data['type'] = 'Patient';
          return data;
        }).toList();
      }

      working = false;
      return Right(users);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      error = e;
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }

  // Search users by name for a specific type
  Future<Either<Exception, List<Map<String, dynamic>>>> searchUsers(
      String userType, String query) async {
    try {
      working = true;
      final collectionName = userType.toLowerCase();
      final queryLower = query.toLowerCase();

      // First get users of the specified type
      final usersResult = await getUsers(userType);

      // Return early if there was an error
      if (usersResult.isLeft()) {
        working = false;
        return usersResult;
      }

      // Extract the users list and filter by name
      final users = usersResult.getOrElse(() => []);
      final filteredUsers = users.where((user) {
        final name = (user['name'] as String?)?.toLowerCase() ?? '';
        return name.contains(queryLower);
      }).toList();

      working = false;
      return Right(filteredUsers);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      error = e;
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }

  Future<Either<Exception, bool>> deleteUser(
      String userId, String userType) async {
    try {
      working = true;

      String collectionName;
      if (userType.toLowerCase() == "patient") {
        collectionName = "patients";
      } else if (userType.toLowerCase() == "doctor") {
        collectionName = "doctors";
      } else {
        collectionName = userType.toLowerCase();
      }

      // Delete user data from Firestore only
      await firestore.collection(collectionName).doc(userId).delete();
      debugPrint(
          'User $userId deleted successfully from $collectionName collection');

      working = false;
      return const Right(true);
    } catch (e) {
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception(e.toString()));
    }
  }

  Future<Either<Exception, PlatformFees>> getPlatformFees() async {
    try {
      working = true;

      final docRef = firestore.collection('app-settings').doc('platform-fees');
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        final defaultFees = PlatformFees.defaultValues();

        await docRef.set(defaultFees.toJson());
        debugPrint('Created default platform fees: ${defaultFees.toJson()}');

        working = false;
        return Right(defaultFees);
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      final platformFees = PlatformFees.fromJson(data);
      debugPrint('Retrieved platform fees: ${platformFees.toJson()}');

      working = false;
      return Right(platformFees);
    } catch (e) {
      debugPrint('Error getting platform fees: $e');
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception('Failed to load platform fees: $e'));
    }
  }

  Future<Either<Exception, bool>> updatePlatformFees({
    required double onlinePercentage,
    required double f2fPercentage,
  }) async {
    try {
      working = true;

      // Validate values
      if (onlinePercentage <= 0 || onlinePercentage > 1) {
        working = false;
        return Left(Exception('Online percentage must be between 0 and 100%'));
      }

      if (f2fPercentage <= 0 || f2fPercentage > 1) {
        working = false;
        return Left(
            Exception('Face-to-face percentage must be between 0 and 100%'));
      }

      // Create the platform fees object with current timestamp
      final platformFees = PlatformFees(
        onlinePercentage: onlinePercentage,
        f2fPercentage: f2fPercentage,
        updatedAt: Timestamp.now(),
      );

      await firestore
          .collection('app-settings')
          .doc('platform-fees')
          .set(platformFees.toJson(), SetOptions(merge: true));

      debugPrint('Platform fees updated: ${platformFees.toJson()}');
      working = false;
      return const Right(true);
    } catch (e) {
      debugPrint('Error updating platform fees: $e');
      working = false;
      error = FirebaseAuthException(message: e.toString(), code: 'error');
      return Left(Exception('Failed to update platform fees: $e'));
    }
  }

  static Future<PlatformFees> getGlobalPlatformFees() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('app-settings').doc('platform-fees');
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        return PlatformFees.defaultValues();
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      return PlatformFees.fromJson(data);
    } catch (e) {
      debugPrint('Error getting global platform fees: $e');
      return PlatformFees.defaultValues();
    }
  }
}
