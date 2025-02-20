import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:intl/intl.dart';

class AppointmentController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  late StreamSubscription authStream;
  User? currentPatient;
  FirebaseAuthException? error;
  bool working = false;

  // Data for ongoing appointment
  AppointmentModel? ongoingAppointment;
  DoctorModel? associatedDoctor;
  bool hasOngoingAppointment = false;

  AppointmentController() {
    authStream = auth.authStateChanges().listen((User? user) {
      currentPatient = user;
      notifyListeners();
    });
  }

//-------REQUEST AN APPOINTMENT-------
  Future<Either<Exception, String>> requestAnAppointment({
    required String doctorId,
    required String doctorName,
    required String doctorClinicAddress,
    required String appointmentDate,
    required String appointmentTime,
    required int modeOfAppointment,
  }) async {
    try {
      debugPrint('Fetching current user model');
      final currentUserModel = await firestore
          .collection('patients')
          .doc(currentPatient!.uid)
          .get()
          .then((value) => UserModel.fromJson(value.data()!));

      debugPrint('Creating appointment document');
      DocumentReference<Map<String, dynamic>> snap =
          firestore.collection('appointments').doc();

      debugPrint('Setting appointment data');
      await snap.set({
        'appointmentUid': snap.id,
        'patientUid': currentPatient!.uid,
        'patientName': currentUserModel.name,
        'doctorName': doctorName,
        'doctorClinicAddress': doctorClinicAddress,
        'doctorUid': doctorId,
        'appointmentDate': appointmentDate,
        'appointmentTime': appointmentTime,
        'modeOfAppointment': modeOfAppointment,
        'appointmentStatus': 0,
        'hasVisitedConsultationRoom': false,
      });

      debugPrint('Updating patient document');
      final docRef = firestore.collection('patients').doc(currentPatient!.uid);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        List<String> doctorsBookedForAppt = List<String>.from(
            docSnapshot.data()!['doctorsBookedForAppt'] ?? []);

        if (!doctorsBookedForAppt.contains(doctorId)) {
          await docRef.update({
            'doctorsBookedForAppt': FieldValue.arrayUnion([doctorId])
          });
        }

        List<String> appointments =
            List<String>.from(docSnapshot.data()!['appointments'] ?? []);
        if (!appointments.contains(snap.id)) {
          await docRef.update({
            'appointmentsBooked': FieldValue.arrayUnion([snap.id])
          });
        }
      }

      debugPrint('Appointment successfully created with ID: ${snap.id}');
      return Right(snap.id);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return Left(Exception(e.toString()));
    }
  }

//-------GET CURRENT PATIENT APPOINTMENTS-------
  Future<Either<Exception, List<AppointmentModel>>>
      getCurrentPatientAppointment() async {
    try {
      final snapshot = await firestore
          .collection('appointments')
          .where('patientUid', isEqualTo: currentPatient!.uid)
          .get();

      List<AppointmentModel> appointments = [];

      for (var element in snapshot.docs) {
        appointments.add(AppointmentModel.fromDocumentSnap(element));
      }

      await updateMissedAppointments(appointments);
      await updateCompletedAppointments(appointments);
      await updatePendingAppointmentsToDeclined(appointments);

      appointments.sort((a, b) {
        final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
        final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
        return aDate.compareTo(bDate);
      });

      return Right(appointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //-------GET LATEST UPCOMING APPOINTMENTS FROM SPECIFIC DOCTOR-------

  //-------UPDATE PENDING APPOINTMENTS TO DECLINED WHEN EXCEEDS NOW DATE-------
  Future<void> updatePendingAppointmentsToDeclined(
      List<AppointmentModel> appointments) async {
    final now = DateTime.now();

    for (var appointment in appointments) {
      final appointmentDate =
          DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
      final appointmentTimes = appointment.appointmentTime!.split(' - ');
      final appointmentEndTime =
          DateFormat('hh:mm a').parse(appointmentTimes[1]);

      final appointmentEndDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        appointmentEndTime.hour,
        appointmentEndTime.minute,
      );

      if (appointmentEndDateTime.isBefore(now) &&
          appointment.appointmentStatus == AppointmentStatus.pending.index) {
        await firestore
            .collection('appointments')
            .doc(appointment.appointmentUid)
            .update({
          'appointmentStatus': AppointmentStatus.declined.index,
        });

        appointment.appointmentStatus = AppointmentStatus.declined.index;
      }
    }
  }

  //-------UPDATE COMPLETED APPOINTMENTS-------
  Future<void> updateCompletedAppointments(
      List<AppointmentModel> appointments) async {
    final now = DateTime.now();

    for (var appointment in appointments) {
      final appointmentDate =
          DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
      final appointmentTimes = appointment.appointmentTime!.split(' - ');
      final appointmentEndTime =
          DateFormat('hh:mm a').parse(appointmentTimes[1]);

      final appointmentEndDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        appointmentEndTime.hour,
        appointmentEndTime.minute,
      );

      if (appointmentEndDateTime.isBefore(now) &&
          appointment.hasVisitedConsultationRoom &&
          appointment.appointmentStatus == AppointmentStatus.confirmed.index) {
        await firestore
            .collection('appointments')
            .doc(appointment.appointmentUid)
            .update({
          'appointmentStatus': AppointmentStatus.completed.index,
        });

        appointment.appointmentStatus = AppointmentStatus.completed.index;
      }
    }
  }

  //-------UPDATE MISSED APPOINTMENTS-------
  Future<void> markAsVisitedConsultationRoom(String appointmentUid) async {
    try {
      final docRef = firestore.collection('appointments').doc(appointmentUid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({
          'hasVisitedConsultationRoom': true,
        });
        debugPrint('Document updated successfully');
      } else {
        debugPrint('Document does not exist');
      }
    } catch (e) {
      debugPrint('Error updating document: $e');
    }
  }

  Future<AppointmentModel?> getAppointmentDetailsNew(
      String appointmentUid) async {
    final doc =
        await firestore.collection('appointments').doc(appointmentUid).get();
    if (doc.exists) {
      return AppointmentModel.fromDocumentSnap(doc);
    }
    return null;
  }

  Future<void> updateMissedAppointments(
      List<AppointmentModel> appointments) async {
    final now = DateTime.now();

    for (var appointment in appointments) {
      final appointmentDate =
          DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
      final appointmentTimes = appointment.appointmentTime!.split(' - ');
      final appointmentStartTime =
          DateFormat('hh:mm a').parse(appointmentTimes[0]);
      final appointmentEndTime =
          DateFormat('hh:mm a').parse(appointmentTimes[1]);

      final appointmentStartDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        appointmentStartTime.hour,
        appointmentStartTime.minute,
      );

      final appointmentEndDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        appointmentEndTime.hour,
        appointmentEndTime.minute,
      );

      if (appointmentEndDateTime.isBefore(now) &&
          appointment.appointmentStatus == AppointmentStatus.confirmed.index &&
          !appointment.hasVisitedConsultationRoom) {
        await firestore
            .collection('appointments')
            .doc(appointment.appointmentUid)
            .update({
          'appointmentStatus': AppointmentStatus.missed.index,
        });

        appointment.appointmentStatus = AppointmentStatus.missed.index;
      }
    }
  }

  //-------GET RECENT PATIENT APPOINTMENTS-------
  //GET Recent Patient Pending/Cancelled/Completed/Declined Appointment For the Appointment Details in Doctor Details Screen
  Future<Either<Exception, AppointmentModel>> getRecentPatientAppointment({
    required String doctorUid,
  }) async {
    try {
      // Debugging statements for currentPatient.uid and doctorUid
      debugPrint('currentPatient.uid: ${currentPatient!.uid}');
      debugPrint('doctorUid: $doctorUid');

      final snapshot = await firestore
          .collection('appointments')
          .where('patientUid', isEqualTo: currentPatient!.uid)
          .where('doctorUid', isEqualTo: doctorUid)
          .where('appointmentStatus', isNotEqualTo: 2)
          .get();

      if (snapshot.docs.isEmpty) {
        return Right(AppointmentModel());
      }

      final docs = snapshot.docs.map((doc) {
        final model = AppointmentModel.fromDocumentSnap(doc);
        model.appointmentDate = DateFormat('MMMM d, yyyy')
            .format(DateFormat('MMMM d, yyyy').parse(model.appointmentDate!));
        return model;
      }).toList();

      docs.sort((a, b) => a.appointmentDate!.compareTo(b.appointmentDate!));
      return Right(docs.first);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return Left(Exception(e.toString()));
    }
  }

//-------GET RECENT PATIENT APPOINTMENTS DETAILS-------
  Future<Either<Exception, AppointmentModel>> getAppointmentDetails({
    required String appointmentUid,
  }) async {
    try {
      final snapshot =
          await firestore.collection('appointments').doc(appointmentUid).get();

      final appointmentDetails = AppointmentModel.fromDocumentSnap(snapshot);

      return Right(appointmentDetails);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

//-------GET COMPLETED APPOINTMENT BY APPT ID for consultation history-------
  Future<Either<Exception, AppointmentModel>> getCompletedAppointmentByApptId({
    required String appointmentUid,
  }) async {
    try {
      final snapshot =
          await firestore.collection('appointments').doc(appointmentUid).get();

      final appointmentModel = AppointmentModel.fromDocumentSnap(snapshot);

      return Right(appointmentModel);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

  //-------GET ALL COMPLETED APPOINTMENTS-------
  Future<Either<Exception, List<AppointmentModel>>>
      getAllCompletedAppointments() async {
    try {
      final snapshot = await firestore
          .collection('appointments')
          .where('patientUid', isEqualTo: currentPatient!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.completed.index)
          .get();

      List<AppointmentModel> appointments = [];

      for (var element in snapshot.docs) {
        appointments.add(AppointmentModel.fromDocumentSnap(element));
      }

      appointments.sort((a, b) {
        final aDate = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
        final bDate = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
        return bDate.compareTo(aDate);
      });

      return Right(appointments);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

//-------CANCEL APPOINTMENT-------
  Future<Either<Exception, bool>> cancelAppointment({
    required String appointmentUid,
  }) async {
    try {
      await firestore.collection('appointments').doc(appointmentUid).update({
        'appointmentStatus': 3,
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

//-------RESCHEDULE APPOINTMENT-------
  Future<Either<Exception, bool>> rescheduleAppointment({
    required String appointmentUid,
    required String appointmentDate,
    required String appointmentTime,
    required int modeOfAppointment,
  }) async {
    try {
      await firestore.collection('appointments').doc(appointmentUid).update({
        'appointmentDate': appointmentDate,
        'appointmentTime': appointmentTime,
        'modeOfAppointment': modeOfAppointment,
        'appointmentStatus': 0,
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      notifyListeners();
      return Left(Exception(e.message));
    }
  }

//-------GET DOCTOR DETAILS BY DOCTOR UID-------
  Future<Either<Exception, DoctorModel>> getDoctorDetail({
    required String doctorUid,
  }) async {
    try {
      final doctorSnapshot =
          await firestore.collection('doctors').doc(doctorUid).get();

      final doctorModel = DoctorModel.fromJson(doctorSnapshot.data()!);

      return Right(doctorModel);
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

//-------UPLOAD PRESCRIPTION IMAGES-------
  Future<Either<Exception, List<String>>> uploadPrescriptionImages({
    required String appointmentUid,
    required List<File> images,
  }) async {
    List<String> downloadUrls = [];

    try {
      for (var image in images) {
        final ref = storage
            .ref()
            .child('prescriptionImages')
            .child(appointmentUid)
            .child(image.path.split('/').last);

        await ref.putFile(image);

        final uploadTask = ref.putFile(image);
        final taskSnapshot = await uploadTask.whenComplete(() => null);
        final downloadUrl = await taskSnapshot.ref.getDownloadURL();

        downloadUrls.add(downloadUrl);

        if (downloadUrls.isEmpty) {
          return const Right([]);
        }

        await firestore.collection('appointments').doc(appointmentUid).update({
          'prescriptionImages': FieldValue.arrayUnion([downloadUrl]),
        });
      }

      return Right(downloadUrls);
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

//-------GET APPOINTMENT PRESCRIPTION IMAGES-------
  Future<Either<Exception, List<String>>> getPrescriptionImages({
    required String appointmentUid,
  }) async {
    try {
      final snapshot =
          await firestore.collection('appointments').doc(appointmentUid).get();

      if (snapshot.data() == null ||
          snapshot.data()!['prescriptionImages'] == null ||
          (snapshot.data()!['prescriptionImages'] as List).isEmpty) {
        return const Right([]);
      }

      final List<String> images =
          List<String>.from(snapshot.data()!['prescriptionImages']);

      return Right(images);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      return Left(Exception(e.message));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Exception(e.toString()));
    }
  }

  //-------GET PATIENT CHATROOMS AND MESSAGES-------
  Future<Either<Exception, List<ChatMessageModel>>>
      getPatientChatroomsAndMessages() async {
    try {
      QuerySnapshot<Map<String, dynamic>> chatroomSnapshot = await firestore
          .collection('consultation-chatrooms')
          .where('members', arrayContains: currentPatient!.uid)
          .get();

      var chatroomDocs = chatroomSnapshot.docs;
      List<Future<ChatMessageModel?>> chatroomMessagesFutures =
          chatroomDocs.map((chatroomDoc) async {
        QuerySnapshot<Map<String, dynamic>> appointmentsSnapshot =
            await firestore
                .collection('consultation-chatrooms')
                .doc(chatroomDoc.id)
                .collection('appointments')
                .get();

        var appointmentDocs = appointmentsSnapshot.docs;

        appointmentDocs.sort((a, b) {
          DateTime startTimeA;
          DateTime startTimeB;

          if (a.data().containsKey('startTime') &&
              b.data().containsKey('startTime')) {
            startTimeA = a['startTime'].toDate();
            startTimeB = b['startTime'].toDate();
          } else {
            // Handle the case where 'startTime' does not exist
            debugPrint(
                'Field "startTime" does not exist in one of the documents');
            return 0; // Keep the original order if 'startTime' is missing
          }

          return startTimeB.compareTo(startTimeA);
        });

        List<Future<ChatMessageModel?>> appointmentMessagesFutures =
            appointmentDocs.map((appointmentDoc) async {
          QuerySnapshot<Map<String, dynamic>> messagesSnapshot = await firestore
              .collection('consultation-chatrooms')
              .doc(chatroomDoc.id)
              .collection('appointments')
              .doc(appointmentDoc.id)
              .collection('messages')
              .orderBy('createdAt', descending: true)
              .get();

          List<ChatMessageModel> messages = messagesSnapshot.docs
              .map((doc) => ChatMessageModel.fromJson(doc.data()))
              .toList();

          return messages.isNotEmpty ? messages.first : null;
        }).toList();

        List<ChatMessageModel> appointmentMessages =
            (await Future.wait(appointmentMessagesFutures))
                .whereType<ChatMessageModel>()
                .toList();

        return appointmentMessages.isNotEmpty
            ? appointmentMessages.first
            : null;
      }).toList();

      List<ChatMessageModel> chatroomMessages =
          (await Future.wait(chatroomMessagesFutures))
              .whereType<ChatMessageModel>()
              .toList();

      chatroomMessages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      return Right(chatroomMessages);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      debugPrint('FirebaseAuthException code: ${e.code}');
      error = e;
      return Left(Exception(e.message));
    }
  }

//-------CHECK ONGOING APPOINTMENT-------

// This method checks ongoing appointments one time and returns the result.
  Future<Either<Exception, AppointmentModel?>> checkOngoingAppointment() async {
    try {
      debugPrint(
          'Checking ongoing appointments for patient: ${currentPatient?.uid}');

      // Similar to what you had before for the one-time fetch
      final snapshotStream = firestore
          .collection('appointments')
          .where('patientUid', isEqualTo: currentPatient!.uid)
          .where('appointmentStatus',
              isEqualTo: AppointmentStatus.confirmed.index)
          .snapshots();

      // Since we're only checking one-time, listen to the snapshot and process it
      final snapshot = await snapshotStream
          .first; // Use `first` to only listen to the first fetch

      debugPrint('Fetched ${snapshot.docs.length} appointments for patient.');

      final today = DateFormat('MMMM d, yyyy').format(DateTime.now());
      debugPrint('Today\'s date: $today');

      bool ongoingAppointmentFound = false;

      // Same filtering and logic as before
      for (var doc in snapshot.docs) {
        final data = doc.data();
        debugPrint(
            'Checking appointment: ${data['appointmentDate']} at ${data['appointmentTime']}');

        final appointmentDate = data['appointmentDate'] as String;
        final appointmentTime = data['appointmentTime'] as String;

        if (appointmentDate != today) continue;

        final times = appointmentTime.split(' - ');
        if (times.length != 2) continue;

        final startTime = DateFormat('h:mm a').parse(times[0]);
        final endTime = DateFormat('h:mm a').parse(times[1]);

        final appointmentStartDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          startTime.hour,
          startTime.minute,
        );
        final appointmentEndDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          endTime.hour,
          endTime.minute,
        );

        final now = DateTime.now();
        if (now.isAfter(appointmentStartDateTime) &&
            now.isBefore(appointmentEndDateTime)) {
          ongoingAppointment = AppointmentModel.fromDocumentSnap(doc);
          ongoingAppointmentFound = true;
          break;
        }
      }

      // Return the result after processing the snapshot
      if (ongoingAppointmentFound) {
        return Right(ongoingAppointment);
      } else {
        return const Right(null);
      }
    } catch (e) {
      debugPrint('Error checking ongoing appointments: $e');
      return Left(Exception('Error checking ongoing appointments'));
    }
  }

  Stream<AppointmentModel?> checkOngoingAppointmentStream() {
    return firestore
        .collection('appointments')
        .where('patientUid', isEqualTo: currentPatient!.uid)
        .where('appointmentStatus',
            isEqualTo: AppointmentStatus.confirmed.index)
        .snapshots()
        .map((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final appointmentDate = data['appointmentDate'] as String;
        final appointmentTime = data['appointmentTime'] as String;
        final modeOfAppointment = data['modeOfAppointment'] as int;

        final today = DateFormat('MMMM d, yyyy').format(DateTime.now());
        if (appointmentDate != today) continue;

        final times = appointmentTime.split(' - ');
        if (times.length != 2) continue;

        final startTime = DateFormat('h:mm a').parse(times[0]);
        final endTime = DateFormat('h:mm a').parse(times[1]);

        final appointmentStartDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          startTime.hour,
          startTime.minute,
        );
        final appointmentEndDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          endTime.hour,
          endTime.minute,
        );

        final now = DateTime.now();

        if (modeOfAppointment == 1) {
          // Face-to-face consultation
          if (now.isBefore(appointmentEndDateTime)) {
            return AppointmentModel.fromDocumentSnap(doc);
          }
        } else {
          // Online consultation
          if (now.isAfter(appointmentStartDateTime) &&
              now.isBefore(appointmentEndDateTime)) {
            return AppointmentModel.fromDocumentSnap(doc);
          }
        }
      }
      return null; // If no ongoing appointment is found
    });
  }

  void resetOnGoingAppointment({
    bool clearDoctor = true,
    bool clearAppointment = true,
    bool notify = true,
  }) {
    debugPrint('Resetting ongoing appointment data...');

    if (clearAppointment) {
      debugPrint('Clearing ongoing appointment details...');
      ongoingAppointment = null;
    }

    if (clearDoctor) {
      debugPrint('Clearing associated doctor details...');
      associatedDoctor = null;
    }

    hasOngoingAppointment = false;

    if (notify) {
      debugPrint('Notifying listeners about reset...');
      notifyListeners();
    }

    debugPrint('Ongoing appointment data reset completed.');
  }
}
