// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DoctorVerificationModel extends Equatable {
  final String uid;
  final Timestamp dateSubmitted;
  final String doctorUid;
  final String medicalLicenseImage;
  final String medicalLicenseImageTitle;
  final int verificationStatus;
  String? declineReason;

  DoctorVerificationModel({
    required this.uid,
    required this.dateSubmitted,
    required this.doctorUid,
    required this.medicalLicenseImage,
    required this.medicalLicenseImageTitle,
    required this.verificationStatus,
    this.declineReason,
  });

  static DoctorVerificationModel fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return DoctorVerificationModel(
      uid: json['uid'] ?? '',
      dateSubmitted: json['dateSubmitted'] ?? Timestamp.now(),
      doctorUid: json['doctorUid'] ?? '',
      medicalLicenseImage: json['medicalLicenseImage'] ?? '',
      medicalLicenseImageTitle: json['medicalLicenseImageTitle'] ?? '',
      verificationStatus: json['verificationStatus'] ?? 0,
      declineReason: json['declineReason'] ?? '',
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'dateSubmitted': Timestamp.now(),
      'doctorUid': doctorUid,
      'medicalLicenseImage': medicalLicenseImage,
      'medicalLicenseImageTitle': medicalLicenseImageTitle,
      'verificationStatus': verificationStatus,
      'declineReason': declineReason,
    };
  }

  factory DoctorVerificationModel.fromJson(Map<String, dynamic> json) {
    return DoctorVerificationModel(
      uid: json['uid'] ?? '',
      dateSubmitted: json['dateSubmitted'] ?? Timestamp.now(),
      doctorUid: json['doctorUid'] ?? '',
      medicalLicenseImage: json['medicalLicenseImage'] ?? '',
      medicalLicenseImageTitle: json['medicalLicenseImageTitle'] ?? '',
      verificationStatus: json['verificationStatus'] ?? 0,
      declineReason: json['declineReason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'dateSubmitted': dateSubmitted,
      'doctorUid': doctorUid,
      'medicalLicenseImage': medicalLicenseImage,
      'medicalLicenseImageTitle': medicalLicenseImageTitle,
      'verificationStatus': verificationStatus,
      'declineReason': declineReason,
    };
  }

  @override
  List<Object?> get props => [
        uid,
        dateSubmitted,
        doctorUid,
        medicalLicenseImage,
        medicalLicenseImageTitle,
        verificationStatus,
        declineReason,
      ];
}
