import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EmergencyAnnouncementModel extends Equatable {
  final String emergencyId;
  final String appointmentUid;
  final List<String> appointmentUids;
  final String doctorUid;
  final List<String> patientUids;
  final List<String> patientNames;
  final String message;
  final String createdBy;
  final String profileImage;
  final Timestamp createdAt;

  const EmergencyAnnouncementModel({
    required this.emergencyId,
    required this.appointmentUid,
    required this.appointmentUids,
    required this.doctorUid,
    required this.patientUids,
    required this.patientNames,
    required this.message,
    required this.createdBy,
    required this.profileImage,
    required this.createdAt,
  });

  static EmergencyAnnouncementModel empty = EmergencyAnnouncementModel(
      emergencyId: '',
      appointmentUid: '',
      appointmentUids: const [],
      doctorUid: '',
      patientUids: const [],
      patientNames: const [],
      message: '',
      createdBy: '',
      profileImage: '',
      createdAt: Timestamp.now());

  factory EmergencyAnnouncementModel.fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};

    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }

    // Handle both old format (single patient) and new format (multiple patients)
    List<String> patientUids = [];
    List<String> patientNames = [];
    List<String> appointmentUids = [];

    if (json['patientUid'] != null) {
      // Old format - single patient
      patientUids = [json['patientUid'] ?? ''];
      patientNames = [json['patientName'] ?? ''];
      appointmentUids = [json['appointmentUid'] ?? ''];
    } else {
      // New format - multiple patients
      patientUids = List<String>.from(json['patientUids'] ?? []);
      patientNames = List<String>.from(json['patientNames'] ?? []);

      // Handle appointmentUids if it exists, otherwise use the single appointmentUid
      if (json['appointmentUids'] != null) {
        appointmentUids = List<String>.from(json['appointmentUids'] ?? []);
      } else {
        appointmentUids = [json['appointmentUid'] ?? ''];
      }
    }

    return EmergencyAnnouncementModel(
      emergencyId: snap.id,
      appointmentUid: json['appointmentUid'] ?? '',
      appointmentUids: appointmentUids,
      doctorUid: json['doctorUid'] ?? '',
      patientUids: patientUids,
      patientNames: patientNames,
      message: json['message'] ?? '',
      createdBy: json['createdBy'] ?? '',
      profileImage: json['profileImage'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  factory EmergencyAnnouncementModel.fromJson(Map<String, dynamic> json) {
    // Handle both old format (single patient) and new format (multiple patients)
    List<String> patientUids = [];
    List<String> patientNames = [];
    List<String> appointmentUids = [];

    if (json['patientUid'] != null) {
      // Old format - single patient
      patientUids = [json['patientUid'] ?? ''];
      patientNames = [json['patientName'] ?? ''];
      appointmentUids = [json['appointmentUid'] ?? ''];
    } else {
      // New format - multiple patients
      patientUids = List<String>.from(json['patientUids'] ?? []);
      patientNames = List<String>.from(json['patientNames'] ?? []);

      // Handle appointmentUids if it exists, otherwise use the single appointmentUid
      if (json['appointmentUids'] != null) {
        appointmentUids = List<String>.from(json['appointmentUids'] ?? []);
      } else {
        appointmentUids = [json['appointmentUid'] ?? ''];
      }
    }

    return EmergencyAnnouncementModel(
      emergencyId: json['id'],
      appointmentUid: json['appointmentUid'] ?? '',
      appointmentUids: appointmentUids,
      doctorUid: json['doctorUid'] ?? '',
      patientUids: patientUids,
      patientNames: patientNames,
      message: json['message'] ?? '',
      createdBy: json['createdBy'] ?? '',
      profileImage: json['profileImage'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': emergencyId,
      'appointmentUid': appointmentUid,
      'appointmentUids': appointmentUids,
      'doctorUid': doctorUid,
      'patientUids': patientUids,
      'patientNames': patientNames,
      'message': message,
      'createdBy': createdBy,
      'profileImage': profileImage,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object> get props => [
        emergencyId,
        appointmentUid,
        appointmentUids,
        doctorUid,
        patientUids,
        patientNames,
        message,
        createdBy,
        profileImage,
        createdAt,
      ];
}
