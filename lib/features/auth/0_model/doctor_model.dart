// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geodesy/geodesy.dart';

class DoctorModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String profileImage;
  final String accountType;
  final String medicalSpecialty;
  final String medicalLicenseNumber;
  final String boardCertificationOrganization;
  final String boardCertificationDate;
  final String medicalSchool;
  final String medicalSchoolStartDate;
  final String medicalSchoolEndDate;
  final String residencyProgram;
  final String residencyProgramStartDate;
  final String residencyProgramGraduationYear;
  final String fellowShipProgram;
  final String fellowShipProgramStartDate;
  final String fellowShipProgramEndDate;
  final String officeAddress;
  final String officeMapsLocationAddress;
  final String officeLatLngAddress;
  final int doctorRatingId;
  final int doctorVerificationStatus;
  LatLng? officeLatLng;
  final String officePhoneNumber;
  Timestamp? created, updated;
  Timestamp? verifiedDate;
  List<String> chatrooms;
  bool? verified;
  bool? waitingForApproval;
  bool? showConsultationPrice;
  double? f2fInitialConsultationPrice;
  double? olInitialConsultationPrice;
  double? f2fFollowUpConsultationPrice;
  double? olFollowUpConsultationPrice;
  List<String>? createdPosts;
  List<String>? repliedPosts;

  DoctorModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.accountType,
    required this.medicalSpecialty,
    required this.medicalLicenseNumber,
    required this.boardCertificationOrganization,
    required this.boardCertificationDate,
    required this.medicalSchool,
    required this.medicalSchoolStartDate,
    required this.medicalSchoolEndDate,
    required this.residencyProgram,
    required this.residencyProgramStartDate,
    required this.residencyProgramGraduationYear,
    required this.fellowShipProgram,
    required this.fellowShipProgramStartDate,
    required this.fellowShipProgramEndDate,
    required this.officeAddress,
    required this.officeMapsLocationAddress,
    required this.officeLatLngAddress,
    required this.doctorRatingId,
    required this.doctorVerificationStatus,
    this.officeLatLng,
    required this.officePhoneNumber,
    this.created,
    this.updated,
    this.verifiedDate,
    required this.chatrooms,
    this.verified,
    this.waitingForApproval,
    this.showConsultationPrice,
    this.f2fInitialConsultationPrice,
    this.olInitialConsultationPrice,
    this.f2fFollowUpConsultationPrice,
    this.olFollowUpConsultationPrice,
    this.createdPosts,
    this.repliedPosts,
  });

  static DoctorModel fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};
    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }
    return DoctorModel(
      uid: snap.id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      accountType: json['accountType'] ?? '',
      medicalSpecialty: json['medicalSpecialty'] ?? '',
      medicalLicenseNumber: json['medicalLicenseNumber'] ?? '',
      boardCertificationOrganization:
          json['boardCertificationOrganization'] ?? '',
      boardCertificationDate: json['boardCertificationDate'] ?? '',
      medicalSchool: json['medicalSchool'] ?? '',
      medicalSchoolStartDate: json['medicalSchoolStartDate'] ?? '',
      medicalSchoolEndDate: json['medicalSchoolEndDate'] ?? '',
      residencyProgram: json['residencyProgram'] ?? '',
      residencyProgramStartDate: json['residencyProgramStartDate'] ?? '',
      residencyProgramGraduationYear:
          json['residencyProgramGraduationYear'] ?? '',
      fellowShipProgram: json['fellowShipProgram'] ?? '',
      fellowShipProgramStartDate: json['fellowShipProgramStartDate'] ?? '',
      fellowShipProgramEndDate: json['fellowShipProgramEndDate'] ?? '',
      officeAddress: json['officeAddress'] ?? '',
      officeMapsLocationAddress: json['officeMapsLocationAddress'] ?? '',
      officeLatLngAddress: json['officeLatLngAddress'] ?? '',
      officePhoneNumber: json['officePhoneNumber'] ?? '',
      officeLatLng: json['officeLatLng'],
      doctorVerificationStatus: json['doctorVerificationStatus'] ?? 0,
      created: json['created'] ?? Timestamp.now(),
      updated: json['updated'] ?? Timestamp.now(),
      chatrooms: json['chatrooms'] != null
          ? List<String>.from(json['chatrooms'])
          : <String>[],
      verified: json['verified'] ?? false,
      waitingForApproval: json['waitingForApproval'] ?? false,
      doctorRatingId: json['doctorRatingId'] ?? 0,
      verifiedDate: json['verifiedDate'],
      showConsultationPrice: json['showConsultationPrice'] ?? false,
      f2fInitialConsultationPrice: json['f2fInitialConsultationPrice'],
      f2fFollowUpConsultationPrice: json['f2fFollowUpConsultationPrice'],
      olInitialConsultationPrice: json['olInitialConsultationPrice'],
      olFollowUpConsultationPrice: json['olFollowUpConsultationPrice'],
      createdPosts: json['createdPosts'] != null
          ? List<String>.from(json['createdPosts'])
          : <String>[],
      repliedPosts: json['repliedPosts'] != null
          ? List<String>.from(json['repliedPosts'])
          : <String>[],
    );
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      accountType: json['accountType'] ?? '',
      medicalSpecialty: json['medicalSpecialty'] ?? '',
      medicalLicenseNumber: json['medicalLicenseNumber'] ?? '',
      boardCertificationOrganization:
          json['boardCertificationOrganization'] ?? '',
      boardCertificationDate: json['boardCertificationDate'] ?? '',
      medicalSchool: json['medicalSchool'] ?? '',
      medicalSchoolStartDate: json['medicalSchoolStartDate'] ?? '',
      medicalSchoolEndDate: json['medicalSchoolEndDate'] ?? '',
      residencyProgram: json['residencyProgram'] ?? '',
      residencyProgramStartDate: json['residencyProgramStartDate'] ?? '',
      residencyProgramGraduationYear:
          json['residencyProgramGraduationYear'] ?? '',
      fellowShipProgram: json['fellowShipProgram'] ?? '',
      fellowShipProgramStartDate: json['fellowShipProgramStartDate'] ?? '',
      fellowShipProgramEndDate: json['fellowShipProgramEndDate'] ?? '',
      officeAddress: json['officeAddress'] ?? '',
      officeMapsLocationAddress: json['officeMapsLocationAddress'] ?? '',
      officeLatLngAddress: json['officeLatLngAddress'] ?? '',
      officePhoneNumber: json['officePhoneNumber'] ?? '',
      officeLatLng: json['officeLatLng'],
      doctorVerificationStatus: json['doctorVerificationStatus'] ?? 0,
      created: json['created'] ?? Timestamp.now(),
      updated: json['updated'] ?? Timestamp.now(),
      chatrooms: json['chatrooms'] != null
          ? List<String>.from(json['chatrooms'])
          : <String>[],
      verified: json['verified'] ?? false,
      waitingForApproval: json['waitingForApproval'] ?? false,
      doctorRatingId: json['doctorRatingId'] ?? 0,
      verifiedDate: json['verifiedDate'],
      showConsultationPrice: json['showConsultationPrice'] ?? false,
      f2fInitialConsultationPrice: json['f2fInitialConsultationPrice'],
      f2fFollowUpConsultationPrice: json['f2fFollowUpConsultationPrice'],
      olInitialConsultationPrice: json['olInitialConsultationPrice'],
      olFollowUpConsultationPrice: json['olFollowUpConsultationPrice'],
      createdPosts: json['createdPosts'] != null
          ? List<String>.from(json['createdPosts'])
          : <String>[],
      repliedPosts: json['repliedPosts'] != null
          ? List<String>.from(json['repliedPosts'])
          : <String>[],
    );
  }

  static Future<DoctorModel> fromUid({required String uid}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
    return DoctorModel.fromDocumentSnap(snap);
  }

  Map<String, dynamic> get json => {
        'uid': uid,
        'name': name,
        'email': email,
        'profileImage': profileImage,
        'accountType': accountType,
        'medicalSpecialty': medicalSpecialty,
        'medicalLicenseNumber': medicalLicenseNumber,
        'boardCertificationOrganization': boardCertificationOrganization,
        'boardCertificationDate': boardCertificationDate,
        'medicalSchool': medicalSchool,
        'medicalSchoolStartDate': medicalSchoolStartDate,
        'medicalSchoolEndDate': medicalSchoolEndDate,
        'residencyProgram': residencyProgram,
        'residencyProgramStartDate': residencyProgramStartDate,
        'residencyProgramGraduationYear': residencyProgramGraduationYear,
        'fellowShipProgram': fellowShipProgram,
        'fellowShipProgramStartDate': fellowShipProgramStartDate,
        'fellowShipProgramEndDate': fellowShipProgramEndDate,
        'officeAddress': officeAddress,
        'officeMapsLocationAddress': officeMapsLocationAddress,
        'officeLatLngAddress': officeLatLngAddress,
        'officePhoneNumber': officePhoneNumber,
        'officeLatLng': officeLatLng,
        'doctorVerificationStatus': doctorVerificationStatus,
        'created': created,
        'updated': updated,
        'chatrooms': chatrooms,
        'verified': verified,
        'waitingForApproval': waitingForApproval,
        'doctorRatingId': doctorRatingId,
        'verifiedDate': verifiedDate,
        'showConsultationPrice': showConsultationPrice,
        'f2fInitialConsultationPrice': f2fInitialConsultationPrice,
        'f2fFollowUpConsultationPrice': f2fFollowUpConsultationPrice,
        'olInitialConsultationPrice': olInitialConsultationPrice,
        'olFollowUpConsultationPrice': olFollowUpConsultationPrice,
        'createdPosts': createdPosts,
        'repliedPosts': repliedPosts,
      };

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        profileImage,
        medicalSpecialty,
        medicalLicenseNumber,
        boardCertificationOrganization,
        boardCertificationDate,
        medicalSchool,
        medicalSchoolStartDate,
        medicalSchoolEndDate,
        residencyProgram,
        residencyProgramStartDate,
        residencyProgramGraduationYear,
        fellowShipProgram,
        fellowShipProgramStartDate,
        fellowShipProgramEndDate,
        officeAddress,
        officeMapsLocationAddress,
        officeLatLngAddress,
        officePhoneNumber,
        doctorVerificationStatus,
        doctorRatingId,
        verifiedDate,
        showConsultationPrice,
        f2fInitialConsultationPrice,
        f2fFollowUpConsultationPrice,
        olInitialConsultationPrice,
        olFollowUpConsultationPrice,
        createdPosts,
        repliedPosts
      ];
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:geodesy/geodesy.dart';

// class DoctorModel extends Equatable {
//   final String uid;
//   final String name;
//   final String email;
//   final String profileImage;
//   final String accountType;
//   final String medicalSpecialty;
//   final String medicalLicenseNumber;
//   final String boardCertificationOrganization;
//   final String boardCertificationDate;
//   final String medicalSchool;
//   final String medicalSchoolStartDate;
//   final String medicalSchoolEndDate;
//   final String residencyProgram;
//   final String residencyProgramStartDate;
//   final String residencyProgramGraduationYear;
//   final String fellowShipProgram;
//   final String fellowShipProgramStartDate;
//   final String fellowShipProgramEndDate;
//   final String officeAddress;
//   final String officeMapsLocationAddress;
//   final String officeLatLngAddress;
//   final int doctorRatingId;
//   final int doctorVerificationStatus;
//   LatLng? officeLatLng;
//   final String officePhoneNumber;
//   final String? officeReadableAddress; // Added new variable
//   Timestamp? created, updated;
//   Timestamp? verifiedDate;
//   List<String> chatrooms;
//   bool? verified;
//   bool? waitingForApproval;
//   bool? showConsultationPrice;
//   double? f2fInitialConsultationPrice;
//   double? olInitialConsultationPrice;
//   double? f2fFollowUpConsultationPrice;
//   double? olFollowUpConsultationPrice;
//   List<String>? createdPosts;
//   List<String>? repliedPosts;

//   DoctorModel({
//     required this.uid,
//     required this.name,
//     required this.email,
//     required this.profileImage,
//     required this.accountType,
//     required this.medicalSpecialty,
//     required this.medicalLicenseNumber,
//     required this.boardCertificationOrganization,
//     required this.boardCertificationDate,
//     required this.medicalSchool,
//     required this.medicalSchoolStartDate,
//     required this.medicalSchoolEndDate,
//     required this.residencyProgram,
//     required this.residencyProgramStartDate,
//     required this.residencyProgramGraduationYear,
//     required this.fellowShipProgram,
//     required this.fellowShipProgramStartDate,
//     required this.fellowShipProgramEndDate,
//     required this.officeAddress,
//     required this.officeMapsLocationAddress,
//     required this.officeLatLngAddress,
//     required this.doctorRatingId,
//     required this.doctorVerificationStatus,
//     this.officeLatLng,
//     required this.officePhoneNumber,
//     this.officeReadableAddress, // Initialize new variable
//     this.created,
//     this.updated,
//     this.verifiedDate,
//     required this.chatrooms,
//     this.verified,
//     this.waitingForApproval,
//     this.showConsultationPrice,
//     this.f2fInitialConsultationPrice,
//     this.olInitialConsultationPrice,
//     this.f2fFollowUpConsultationPrice,
//     this.olFollowUpConsultationPrice,
//     this.createdPosts,
//     this.repliedPosts,
//   });

//   // Add copyWith method
//   DoctorModel copyWith({
//     String? uid,
//     String? name,
//     String? email,
//     String? profileImage,
//     String? accountType,
//     String? medicalSpecialty,
//     String? medicalLicenseNumber,
//     String? boardCertificationOrganization,
//     String? boardCertificationDate,
//     String? medicalSchool,
//     String? medicalSchoolStartDate,
//     String? medicalSchoolEndDate,
//     String? residencyProgram,
//     String? residencyProgramStartDate,
//     String? residencyProgramGraduationYear,
//     String? fellowShipProgram,
//     String? fellowShipProgramStartDate,
//     String? fellowShipProgramEndDate,
//     String? officeAddress,
//     String? officeMapsLocationAddress,
//     String? officeLatLngAddress,
//     int? doctorRatingId,
//     int? doctorVerificationStatus,
//     LatLng? officeLatLng,
//     String? officePhoneNumber,
//     String? officeReadableAddress, // Include new variable
//     Timestamp? created,
//     Timestamp? updated,
//     Timestamp? verifiedDate,
//     List<String>? chatrooms,
//     bool? verified,
//     bool? waitingForApproval,
//     bool? showConsultationPrice,
//     double? f2fInitialConsultationPrice,
//     double? olInitialConsultationPrice,
//     double? f2fFollowUpConsultationPrice,
//     double? olFollowUpConsultationPrice,
//     List<String>? createdPosts,
//     List<String>? repliedPosts,
//   }) {
//     return DoctorModel(
//       uid: uid ?? this.uid,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       profileImage: profileImage ?? this.profileImage,
//       accountType: accountType ?? this.accountType,
//       medicalSpecialty: medicalSpecialty ?? this.medicalSpecialty,
//       medicalLicenseNumber: medicalLicenseNumber ?? this.medicalLicenseNumber,
//       boardCertificationOrganization:
//           boardCertificationOrganization ?? this.boardCertificationOrganization,
//       boardCertificationDate:
//           boardCertificationDate ?? this.boardCertificationDate,
//       medicalSchool: medicalSchool ?? this.medicalSchool,
//       medicalSchoolStartDate:
//           medicalSchoolStartDate ?? this.medicalSchoolStartDate,
//       medicalSchoolEndDate: medicalSchoolEndDate ?? this.medicalSchoolEndDate,
//       residencyProgram: residencyProgram ?? this.residencyProgram,
//       residencyProgramStartDate:
//           residencyProgramStartDate ?? this.residencyProgramStartDate,
//       residencyProgramGraduationYear:
//           residencyProgramGraduationYear ?? this.residencyProgramGraduationYear,
//       fellowShipProgram: fellowShipProgram ?? this.fellowShipProgram,
//       fellowShipProgramStartDate:
//           fellowShipProgramStartDate ?? this.fellowShipProgramStartDate,
//       fellowShipProgramEndDate:
//           fellowShipProgramEndDate ?? this.fellowShipProgramEndDate,
//       officeAddress: officeAddress ?? this.officeAddress,
//       officeMapsLocationAddress:
//           officeMapsLocationAddress ?? this.officeMapsLocationAddress,
//       officeLatLngAddress: officeLatLngAddress ?? this.officeLatLngAddress,
//       doctorRatingId: doctorRatingId ?? this.doctorRatingId,
//       doctorVerificationStatus:
//           doctorVerificationStatus ?? this.doctorVerificationStatus,
//       officeLatLng: officeLatLng ?? this.officeLatLng,
//       officePhoneNumber: officePhoneNumber ?? this.officePhoneNumber,
//       officeReadableAddress:
//           officeReadableAddress ?? this.officeReadableAddress, // New variable
//       created: created ?? this.created,
//       updated: updated ?? this.updated,
//       verifiedDate: verifiedDate ?? this.verifiedDate,
//       chatrooms: chatrooms ?? this.chatrooms,
//       verified: verified ?? this.verified,
//       waitingForApproval: waitingForApproval ?? this.waitingForApproval,
//       showConsultationPrice:
//           showConsultationPrice ?? this.showConsultationPrice,
//       f2fInitialConsultationPrice:
//           f2fInitialConsultationPrice ?? this.f2fInitialConsultationPrice,
//       olInitialConsultationPrice:
//           olInitialConsultationPrice ?? this.olInitialConsultationPrice,
//       f2fFollowUpConsultationPrice:
//           f2fFollowUpConsultationPrice ?? this.f2fFollowUpConsultationPrice,
//       olFollowUpConsultationPrice:
//           olFollowUpConsultationPrice ?? this.olFollowUpConsultationPrice,
//       createdPosts: createdPosts ?? this.createdPosts,
//       repliedPosts: repliedPosts ?? this.repliedPosts,
//     );
//   }

//   static DoctorModel fromDocumentSnap(DocumentSnapshot snap) {
//     Map<String, dynamic> json = {};
//     if (snap.data() != null) {
//       json = snap.data() as Map<String, dynamic>;
//     }
//     return DoctorModel(
//       uid: snap.id,
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       profileImage: json['profileImage'] ?? '',
//       accountType: json['accountType'] ?? '',
//       medicalSpecialty: json['medicalSpecialty'] ?? '',
//       medicalLicenseNumber: json['medicalLicenseNumber'] ?? '',
//       boardCertificationOrganization:
//           json['boardCertificationOrganization'] ?? '',
//       boardCertificationDate: json['boardCertificationDate'] ?? '',
//       medicalSchool: json['medicalSchool'] ?? '',
//       medicalSchoolStartDate: json['medicalSchoolStartDate'] ?? '',
//       medicalSchoolEndDate: json['medicalSchoolEndDate'] ?? '',
//       residencyProgram: json['residencyProgram'] ?? '',
//       residencyProgramStartDate: json['residencyProgramStartDate'] ?? '',
//       residencyProgramGraduationYear:
//           json['residencyProgramGraduationYear'] ?? '',
//       fellowShipProgram: json['fellowShipProgram'] ?? '',
//       fellowShipProgramStartDate: json['fellowShipProgramStartDate'] ?? '',
//       fellowShipProgramEndDate: json['fellowShipProgramEndDate'] ?? '',
//       officeAddress: json['officeAddress'] ?? '',
//       officeMapsLocationAddress: json['officeMapsLocationAddress'] ?? '',
//       officeLatLngAddress: json['officeLatLngAddress'] ?? '',
//       officeReadableAddress:
//           json['officeReadableAddress'] ?? '', // Include new variable
//       officePhoneNumber: json['officePhoneNumber'] ?? '',
//       officeLatLng: json['officeLatLng'] ?? '',
//       doctorVerificationStatus: json['doctorVerificationStatus'] ?? 0,
//       created: json['created'] ?? Timestamp.now(),
//       updated: json['updated'] ?? Timestamp.now(),
//       chatrooms: json['chatrooms'] != null
//           ? List<String>.from(json['chatrooms'])
//           : <String>[],
//       verified: json['verified'] ?? false,
//       waitingForApproval: json['waitingForApproval'] ?? false,
//       doctorRatingId: json['doctorRatingId'] ?? 0,
//       verifiedDate: json['verifiedDate'],
//       showConsultationPrice: json['showConsultationPrice'] ?? false,
//       f2fInitialConsultationPrice: json['f2fInitialConsultationPrice'],
//       f2fFollowUpConsultationPrice: json['f2fFollowUpConsultationPrice'],
//       olInitialConsultationPrice: json['olInitialConsultationPrice'],
//       olFollowUpConsultationPrice: json['olFollowUpConsultationPrice'],
//       createdPosts: json['createdPosts'] != null
//           ? List<String>.from(json['createdPosts'])
//           : <String>[],
//       repliedPosts: json['repliedPosts'] != null
//           ? List<String>.from(json['repliedPosts'])
//           : <String>[],
//     );
//   }

//   factory DoctorModel.fromJson(Map<String, dynamic> json) {
//     return DoctorModel(
//       uid: json['uid'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       profileImage: json['profileImage'] ?? '',
//       accountType: json['accountType'] ?? '',
//       medicalSpecialty: json['medicalSpecialty'] ?? '',
//       medicalLicenseNumber: json['medicalLicenseNumber'] ?? '',
//       boardCertificationOrganization:
//           json['boardCertificationOrganization'] ?? '',
//       boardCertificationDate: json['boardCertificationDate'] ?? '',
//       medicalSchool: json['medicalSchool'] ?? '',
//       medicalSchoolStartDate: json['medicalSchoolStartDate'] ?? '',
//       medicalSchoolEndDate: json['medicalSchoolEndDate'] ?? '',
//       residencyProgram: json['residencyProgram'] ?? '',
//       residencyProgramStartDate: json['residencyProgramStartDate'] ?? '',
//       residencyProgramGraduationYear:
//           json['residencyProgramGraduationYear'] ?? '',
//       fellowShipProgram: json['fellowShipProgram'] ?? '',
//       fellowShipProgramStartDate: json['fellowShipProgramStartDate'] ?? '',
//       fellowShipProgramEndDate: json['fellowShipProgramEndDate'] ?? '',
//       officeAddress: json['officeAddress'] ?? '',
//       officeMapsLocationAddress: json['officeMapsLocationAddress'] ?? '',
//       officeLatLngAddress: json['officeLatLngAddress'] ?? '',
//       officeReadableAddress:
//           json['officeReadableAddress'] ?? '', // Include new variable
//       officePhoneNumber: json['officePhoneNumber'] ?? '',
//       officeLatLng: json['officeLatLng'],
//       doctorVerificationStatus: json['doctorVerificationStatus'] ?? 0,
//       created: json['created'] ?? Timestamp.now(),
//       updated: json['updated'] ?? Timestamp.now(),
//       chatrooms: json['chatrooms'] != null
//           ? List<String>.from(json['chatrooms'])
//           : <String>[],
//       verified: json['verified'] ?? false,
//       waitingForApproval: json['waitingForApproval'] ?? false,
//       doctorRatingId: json['doctorRatingId'] ?? 0,
//       verifiedDate: json['verifiedDate'],
//       showConsultationPrice: json['showConsultationPrice'] ?? false,
//       f2fInitialConsultationPrice: json['f2fInitialConsultationPrice'],
//       f2fFollowUpConsultationPrice: json['f2fFollowUpConsultationPrice'],
//       olInitialConsultationPrice: json['olInitialConsultationPrice'],
//       olFollowUpConsultationPrice: json['olFollowUpConsultationPrice'],
//       createdPosts: json['createdPosts'] != null
//           ? List<String>.from(json['createdPosts'])
//           : <String>[],
//       repliedPosts: json['repliedPosts'] != null
//           ? List<String>.from(json['repliedPosts'])
//           : <String>[],
//     );
//   }

//   static Future<DoctorModel> fromUid({required String uid}) async {
//     DocumentSnapshot snap =
//         await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
//     return DoctorModel.fromDocumentSnap(snap);
//   }

//   Map<String, dynamic> get json => {
//         'uid': uid,
//         'name': name,
//         'email': email,
//         'profileImage': profileImage,
//         'accountType': accountType,
//         'medicalSpecialty': medicalSpecialty,
//         'medicalLicenseNumber': medicalLicenseNumber,
//         'boardCertificationOrganization': boardCertificationOrganization,
//         'boardCertificationDate': boardCertificationDate,
//         'medicalSchool': medicalSchool,
//         'medicalSchoolStartDate': medicalSchoolStartDate,
//         'medicalSchoolEndDate': medicalSchoolEndDate,
//         'residencyProgram': residencyProgram,
//         'residencyProgramStartDate': residencyProgramStartDate,
//         'residencyProgramGraduationYear': residencyProgramGraduationYear,
//         'fellowShipProgram': fellowShipProgram,
//         'fellowShipProgramStartDate': fellowShipProgramStartDate,
//         'fellowShipProgramEndDate': fellowShipProgramEndDate,
//         'officeAddress': officeAddress,
//         'officeMapsLocationAddress': officeMapsLocationAddress,
//         'officeLatLngAddress': officeLatLngAddress,
//         'officeReadableAddress': officeReadableAddress, // Include new variable
//         'officePhoneNumber': officePhoneNumber,
//         'officeLatLng': officeLatLng,
//         'doctorVerificationStatus': doctorVerificationStatus,
//         'created': created,
//         'updated': updated,
//         'chatrooms': chatrooms,
//         'verified': verified,
//         'waitingForApproval': waitingForApproval,
//         'doctorRatingId': doctorRatingId,
//         'verifiedDate': verifiedDate,
//         'showConsultationPrice': showConsultationPrice,
//         'f2fInitialConsultationPrice': f2fInitialConsultationPrice,
//         'f2fFollowUpConsultationPrice': f2fFollowUpConsultationPrice,
//         'olInitialConsultationPrice': olInitialConsultationPrice,
//         'olFollowUpConsultationPrice': olFollowUpConsultationPrice,
//         'createdPosts': createdPosts,
//         'repliedPosts': repliedPosts,
//       };

//   @override
//   List<Object?> get props => [
//         uid,
//         name,
//         email,
//         profileImage,
//         accountType,
//         medicalSpecialty,
//         medicalLicenseNumber,
//         boardCertificationOrganization,
//         boardCertificationDate,
//         medicalSchool,
//         medicalSchoolStartDate,
//         medicalSchoolEndDate,
//         residencyProgram,
//         residencyProgramStartDate,
//         residencyProgramGraduationYear,
//         fellowShipProgram,
//         fellowShipProgramStartDate,
//         fellowShipProgramEndDate,
//         officeAddress,
//         officeMapsLocationAddress,
//         officeLatLngAddress,
//         officePhoneNumber,
//         officeReadableAddress, // Include new variable in props
//         doctorRatingId,
//         doctorVerificationStatus,
//         officeLatLng,
//         verified,
//         waitingForApproval,
//         showConsultationPrice,
//         f2fInitialConsultationPrice,
//         olInitialConsultationPrice,
//         f2fFollowUpConsultationPrice,
//         olFollowUpConsultationPrice,
//         createdPosts,
//         repliedPosts,
//         created,
//         updated,
//         verifiedDate,
//         chatrooms,
//       ];
// }
