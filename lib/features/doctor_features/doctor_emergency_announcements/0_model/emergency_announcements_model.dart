import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EmergencyAnnouncementModel extends Equatable {
  final String emergencyId;
  final String appointmentUid;
  final String doctorUid;
  final String patientUid;
  final String patientName;
  final String message;
  final String createdBy;
  final String profileImage;
  final Timestamp createdAt;

  const EmergencyAnnouncementModel({
    required this.emergencyId,
    required this.appointmentUid,
    required this.doctorUid,
    required this.patientUid,
    required this.patientName,
    required this.message,
    required this.createdBy,
    required this.profileImage,
    required this.createdAt,
  });

  static EmergencyAnnouncementModel empty = EmergencyAnnouncementModel(
      emergencyId: '',
      appointmentUid: '',
      doctorUid: '',
      patientUid: '',
      patientName: '',
      message: '',
      createdBy: '',
      profileImage: '',
      createdAt: Timestamp.now());

  factory EmergencyAnnouncementModel.fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};

    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }

    return EmergencyAnnouncementModel(
      emergencyId: snap.id,
      appointmentUid: json['appointmentUid'] ?? '',
      doctorUid: json['doctorUid'] ?? '',
      patientUid: json['patientUid'] ?? '',
      patientName: json['patientName'] ?? '',
      message: json['message'] ?? '',
      createdBy: json['createdBy'] ?? '',
      profileImage: json['profileImage'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  factory EmergencyAnnouncementModel.fromJson(Map<String, dynamic> json) {
    return EmergencyAnnouncementModel(
      emergencyId: json['id'],
      appointmentUid: json['appointmentUid'] ?? '',
      doctorUid: json['doctorUid'] ?? '',
      patientUid: json['patientUid'] ?? '',
      patientName: json['patientName'] ?? '',
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
      'doctorUid': doctorUid,
      'patientUid': patientUid,
      'patientName': patientName,
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
        doctorUid,
        patientUid,
        patientName,
        message,
        createdBy,
        profileImage,
        createdAt,
      ];
}
