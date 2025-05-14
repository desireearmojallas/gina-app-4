import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/1_controllers/patient_auth_controller.dart';

User? currentDoctor;
bool waitingForApproval = false;

class DoctorAuthenticationController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late StreamSubscription authStream;
  FirebaseAuthException? error;
  bool working = false;

  DoctorAuthenticationController() {
    authStream = auth.authStateChanges().listen((User? doctor) async {
      currentDoctor = doctor;
      currentPatient = null;
      notifyListeners();
    });
  }

  //----------Doctor Login----------
  Future<String> doctorLogin({
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
          .collection('doctors')
          .doc(result.user!.uid)
          .get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      String accountTypeFirebase = userData['accountType'] as String;

      // Perform account type check
      if (accountTypeFirebase != 'Doctor') {
        throw Exception('Invalid account type');
      }

      // Get the doctorVerificationStatus
      int doctorVerificationStatus =
          userData['doctorVerificationStatus'] as int;
      bool waitingForApprovalFromFirebase =
          userData['waitingForApproval'] as bool;

      waitingForApproval = waitingForApprovalFromFirebase;

      switch (doctorVerificationStatus) {
        case 0:
          return 'Pending';
        case 1:
          return 'Approved';
        case 2:
          return 'Declined';
        default:
          return 'Pending';
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      currentDoctor = null;
      error = e;
      notifyListeners();
      throw Exception(e.toString());
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      currentDoctor = null;
      error = FirebaseAuthException(
        code: 'unknown',
        message: e.toString(),
      );
      notifyListeners();
      if (error != null) {
        throw Exception(e.toString);
      } else {
        throw Exception('Unknown error occured');
      }
    }
  }

  //----------Doctor Registration----------
  Future<String> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String medicalSpecialty,
    required String medicalLicenseNumber,
    required String boardCertificationOrganization,
    required String boardCertificationDate,
    required String medicalSchool,
    required String medicalSchoolStartDate,
    required String medicalSchoolEndDate,
    required String residencyProgram,
    required String residencyProgramStartDate,
    required String residencyProgramGraduationYear,
    required String fellowShipProgram,
    required String fellowShipProgramStartDate,
    required String fellowShipProgramEndDate,
    required String officeAddress,
    required String officeMapsLocationAddress,
    required String officeLatLngAddress,
    required String officePhoneNumber,
  }) async {
    try {
      working = true;
      notifyListeners();
      UserCredential createDoctor = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (createDoctor.user != null) {
        DoctorModel doctorModel = DoctorModel(
          uid: createDoctor.user!.uid,
          accountType: 'Doctor',
          name: name,
          email: email,
          profileImage: '',
          medicalSpecialty: medicalSpecialty,
          medicalLicenseNumber: medicalLicenseNumber,
          boardCertificationOrganization: boardCertificationOrganization,
          boardCertificationDate: boardCertificationDate,
          medicalSchool: medicalSchool,
          medicalSchoolStartDate: medicalSchoolStartDate,
          medicalSchoolEndDate: medicalSchoolEndDate,
          residencyProgram: residencyProgram,
          residencyProgramStartDate: residencyProgramStartDate,
          residencyProgramGraduationYear: residencyProgramGraduationYear,
          fellowShipProgram: fellowShipProgram,
          fellowShipProgramStartDate: fellowShipProgramStartDate,
          fellowShipProgramEndDate: fellowShipProgramEndDate,
          officeAddress: officeAddress,
          officeMapsLocationAddress: officeMapsLocationAddress,
          officeLatLngAddress: officeLatLngAddress,
          officePhoneNumber: officePhoneNumber,
          created: Timestamp.now(),
          updated: Timestamp.now(),
          chatrooms: const [],
          verified: false,
          waitingForApproval: true,
          doctorRatingId: DoctorRating.newDoctor.index,
          doctorVerificationStatus: DoctorVerificationStatus.pending.index,
          showConsultationPrice: false,
        );

        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(doctorModel.uid)
            .set(doctorModel.json);

        working = false;
        currentDoctor = createDoctor.user;
        error = null;
        notifyListeners();
      }
      return createDoctor.user!.uid;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint(e.code);
      working = false;
      currentDoctor = null;
      error = e;
      notifyListeners();
      throw Exception(e.toString());
    } catch (e) {
      debugPrint(e.toString());
      working = false;
      currentDoctor = null;
      error = FirebaseAuthException(
        code: 'unknown',
        message: e.toString(),
      );
      notifyListeners();
      throw Exception(e.toString());
    }
  }

  //----------Doctor Logout----------
  Future<void> logout() async {
    await auth.signOut();
    currentDoctor = null;
    notifyListeners();
  }

  //----------Doctor Verification----------
  // Future<bool> submissionOfDoctorVerification({
  //   required String? doctorUid,
  //   required String medicalLicenseImageTitle,
  //   required File medicalLicenseImageFile,
  // }) async {
  //   try {
  //     DocumentReference<Map<String, dynamic>> snap = FirebaseFirestore.instance
  //         .collection('doctors')
  //         .doc(currentDoctor!.uid)
  //         .collection('doctorSubmittedDocuments')
  //         .doc();

  //     final ref = FirebaseStorage.instance
  //         .ref()
  //         .child('doctorMedicalLicenseImages')
  //         .child(doctorUid ?? currentDoctor!.uid)
  //         .child(medicalLicenseImageFile.path.split('/').last);

  //     await ref.putFile(medicalLicenseImageFile);

  //     final uploadTask = ref.putFile(medicalLicenseImageFile);
  //     final taskSnapshot = await uploadTask.whenComplete(() => null);
  //     final medicalLicenseImageUrl = await taskSnapshot.ref.getDownloadURL();

  //     await FirebaseFirestore.instance
  //         .collection('doctors')
  //         .doc(doctorUid ?? currentDoctor!.uid)
  //         .update({
  //       'verifiedDate': Timestamp.now(),
  //       'doctorVerificationStatus': DoctorVerificationStatus.pending.index,
  //     });

  //     await FirebaseFirestore.instance
  //         .collection('doctors')
  //         .doc(doctorUid ?? currentDoctor!.uid)
  //         .collection('doctorSubmittedDocuments')
  //         .doc(snap.id)
  //         .set({
  //       'uid': snap.id,
  //       'dateSubmitted': Timestamp.now(),
  //       'doctorUid': doctorUid ?? currentDoctor!.uid,
  //       'medicalLicenseImage': medicalLicenseImageUrl,
  //       'medicalLicenseImageTitle': medicalLicenseImageTitle,
  //       'verificationStatus': DoctorVerificationStatus.pending.index,
  //     });

  //     return true;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  Future<bool> submissionOfDoctorVerification({
    required String? doctorUid,
    required String medicalLicenseImageTitle,
    required File medicalLicenseImageFile,
  }) async {
    debugPrint('STARTING submissionOfDoctorVerification');
    debugPrint(
        'Parameters: doctorUid=$doctorUid, title=$medicalLicenseImageTitle');
    debugPrint('currentDoctor=${currentDoctor?.uid ?? "NULL"}');

    try {
      if (currentDoctor == null) {
        debugPrint('ERROR: currentDoctor is null');
        return false;
      }

      debugPrint('Creating document reference...');
      DocumentReference<Map<String, dynamic>> snap = FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentDoctor!.uid)
          .collection('doctorSubmittedDocuments')
          .doc();
      debugPrint('Document reference created with ID: ${snap.id}');

      final String uidToUse = doctorUid ?? currentDoctor!.uid;
      debugPrint('Using UID: $uidToUse');

      debugPrint('Preparing storage reference...');
      final ref = FirebaseStorage.instance
          .ref()
          .child('doctorMedicalLicenseImages')
          .child(uidToUse)
          .child(medicalLicenseImageFile.path.split('/').last);
      debugPrint('Storage reference prepared');

      debugPrint('Starting file upload...');
      await ref.putFile(medicalLicenseImageFile);
      debugPrint('Initial file put completed');

      debugPrint('Starting upload task...');
      final uploadTask = ref.putFile(medicalLicenseImageFile);
      debugPrint('Waiting for upload to complete...');
      final taskSnapshot = await uploadTask
          .whenComplete(() => debugPrint('Upload task completed'));

      debugPrint('Getting download URL...');
      final medicalLicenseImageUrl = await taskSnapshot.ref.getDownloadURL();
      debugPrint('Got download URL: $medicalLicenseImageUrl');

      debugPrint('Updating doctor document...');
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(uidToUse)
          .update({
        'verifiedDate': Timestamp.now(),
        'doctorVerificationStatus': DoctorVerificationStatus.pending.index,
      });
      debugPrint('Doctor document updated');

      debugPrint('Creating submission document...');
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(uidToUse)
          .collection('doctorSubmittedDocuments')
          .doc(snap.id)
          .set({
        'uid': snap.id,
        'dateSubmitted': Timestamp.now(),
        'doctorUid': uidToUse,
        'medicalLicenseImage': medicalLicenseImageUrl,
        'medicalLicenseImageTitle': medicalLicenseImageTitle,
        'verificationStatus': DoctorVerificationStatus.pending.index,
      });
      debugPrint('Submission document created successfully');

      debugPrint('COMPLETED: submissionOfDoctorVerification');
      return true;
    } catch (e) {
      debugPrint('ERROR in submissionOfDoctorVerification: ${e.toString()}');
      if (e is FirebaseException) {
        debugPrint('Firebase Error Code: ${e.code}');
        debugPrint('Firebase Error Message: ${e.message}');
      }
      return false;
    }
  }

  //----------Change Waiting Approval Status----------
  Future<void> changeWaitingApprovalStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentDoctor!.uid)
          .update({'waitingForApproval': false});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //----------Doctor Get Decline Reason----------
  Future<String> getDeclineReason() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentDoctor!.uid)
          .collection('doctorSubmittedDocuments')
          .where('verificationStatus', isEqualTo: 2)
          .orderBy('dateSubmitted', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        if (doc.data().containsKey('declineReason') &&
            doc['declineReason'] != null) {
          return doc['declineReason'];
        }
        return 'No reason provided';
      }
      return 'No declined documents found';
    } catch (e) {
      debugPrint('Error getting decline reason: ${e.toString()}');
      return 'Unknown error occurred';
    }
  }
}
