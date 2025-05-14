import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EmergencyAnnouncementModel extends Equatable {
  final String emergencyId;
  final List<String> appointmentUids;
  final String doctorUid;
  final List<String> patientUids;
  final List<String> patientNames;
  final String message;
  final String createdBy;
  final String profileImage;
  final Timestamp createdAt;
  final Map<String, bool>
      clickedByPatients; // Map of patientUid -> clicked status
  final Map<String, String>
      patientToAppointmentMap; // Map of patientUid -> appointmentUid (now required)

  const EmergencyAnnouncementModel({
    required this.emergencyId,
    required this.appointmentUids,
    required this.doctorUid,
    required this.patientUids,
    required this.patientNames,
    required this.message,
    required this.createdBy,
    required this.profileImage,
    required this.createdAt,
    required this.clickedByPatients,
    required this.patientToAppointmentMap,
  });

  static EmergencyAnnouncementModel empty = EmergencyAnnouncementModel(
    emergencyId: '',
    appointmentUids: const [],
    doctorUid: '',
    patientUids: const [],
    patientNames: const [],
    message: '',
    createdBy: '',
    profileImage: '',
    createdAt: Timestamp.now(),
    clickedByPatients: const {},
    patientToAppointmentMap: const {}, // Empty but non-null
  );

  factory EmergencyAnnouncementModel.fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};

    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }

    // Handle both old format (single patient) and new format (multiple patients)
    List<String> patientUids = [];
    List<String> patientNames = [];
    List<String> appointmentUids = [];
    Map<String, bool> clickedByPatients = {};
    Map<String, String> patientToAppointmentMap =
        {}; // Initialize as empty non-null map

    if (json['patientUid'] != null) {
      // Old format - single patient
      String patientUid = json['patientUid'] ?? '';
      patientUids = [patientUid];
      patientNames = [json['patientName'] ?? ''];

      if (json['appointmentUid'] != null) {
        final appointmentUid = json['appointmentUid'] ?? '';
        appointmentUids = [appointmentUid];

        // Create a mapping for backward compatibility
        if (patientUid.isNotEmpty) {
          patientToAppointmentMap[patientUid] = appointmentUid;
        }
      }

      // Convert old boolean format to map format
      bool wasClicked = json['clickedByPatient'] ?? false;
      if (patientUid.isNotEmpty) {
        clickedByPatients[patientUid] = wasClicked;
      }
    } else {
      // New format - multiple patients
      patientUids = List<String>.from(json['patientUids'] ?? []);
      patientNames = List<String>.from(json['patientNames'] ?? []);
      appointmentUids = List<String>.from(json['appointmentUids'] ?? []);

      // Handle patient to appointment mapping if available
      if (json['patientToAppointmentMap'] is Map) {
        patientToAppointmentMap = Map<String, String>.from(
            json['patientToAppointmentMap'].map(
                (key, value) => MapEntry(key.toString(), value.toString())));
      }
      // If no mapping but we have matching lists, create one
      else if (patientUids.length == appointmentUids.length) {
        for (int i = 0; i < patientUids.length; i++) {
          patientToAppointmentMap[patientUids[i]] = appointmentUids[i];
        }
      }

      // Handle new map format or initialize empty
      if (json['clickedByPatients'] is Map) {
        final clickedMap = json['clickedByPatients'] as Map;
        clickedByPatients = Map<String, bool>.from(clickedMap
            .map((key, value) => MapEntry(key.toString(), value as bool)));
      }
    }

    return EmergencyAnnouncementModel(
      emergencyId: snap.id,
      appointmentUids: appointmentUids,
      doctorUid: json['doctorUid'] ?? '',
      patientUids: patientUids,
      patientNames: patientNames,
      message: json['message'] ?? '',
      createdBy: json['createdBy'] ?? '',
      profileImage: json['profileImage'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      clickedByPatients: clickedByPatients,
      patientToAppointmentMap: patientToAppointmentMap,
    );
  }

  factory EmergencyAnnouncementModel.fromJson(Map<String, dynamic> json) {
    // Handle both old format (single patient) and new format (multiple patients)
    List<String> patientUids = [];
    List<String> patientNames = [];
    List<String> appointmentUids = [];
    Map<String, bool> clickedByPatients = {};
    Map<String, String> patientToAppointmentMap =
        {}; // Initialize as empty non-null map

    if (json['patientUid'] != null) {
      // Old format - single patient
      String patientUid = json['patientUid'] ?? '';
      patientUids = [patientUid];
      patientNames = [json['patientName'] ?? ''];

      if (json['appointmentUid'] != null) {
        final appointmentUid = json['appointmentUid'] ?? '';
        appointmentUids = [appointmentUid];

        // Create a mapping for backward compatibility
        if (patientUid.isNotEmpty) {
          patientToAppointmentMap[patientUid] = appointmentUid;
        }
      }

      // Convert old boolean format to map format
      bool wasClicked = json['clickedByPatient'] ?? false;
      if (patientUid.isNotEmpty) {
        clickedByPatients[patientUid] = wasClicked;
      }
    } else {
      // New format - multiple patients
      patientUids = List<String>.from(json['patientUids'] ?? []);
      patientNames = List<String>.from(json['patientNames'] ?? []);
      appointmentUids = List<String>.from(json['appointmentUids'] ?? []);

      // Handle patient to appointment mapping if available
      if (json['patientToAppointmentMap'] is Map) {
        patientToAppointmentMap = Map<String, String>.from(
            json['patientToAppointmentMap'].map(
                (key, value) => MapEntry(key.toString(), value.toString())));
      }
      // If no mapping but we have matching lists, create one
      else if (patientUids.length == appointmentUids.length) {
        for (int i = 0; i < patientUids.length; i++) {
          patientToAppointmentMap[patientUids[i]] = appointmentUids[i];
        }
      }

      // Handle new map format or initialize empty
      if (json['clickedByPatients'] is Map) {
        final clickedMap = json['clickedByPatients'] as Map;
        clickedByPatients = Map<String, bool>.from(clickedMap
            .map((key, value) => MapEntry(key.toString(), value as bool)));
      }
    }

    return EmergencyAnnouncementModel(
      emergencyId: json['id'],
      appointmentUids: appointmentUids,
      doctorUid: json['doctorUid'] ?? '',
      patientUids: patientUids,
      patientNames: patientNames,
      message: json['message'] ?? '',
      createdBy: json['createdBy'] ?? '',
      profileImage: json['profileImage'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      clickedByPatients: clickedByPatients,
      patientToAppointmentMap: patientToAppointmentMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': emergencyId,
      'appointmentUids': appointmentUids,
      'doctorUid': doctorUid,
      'patientUids': patientUids,
      'patientNames': patientNames,
      'message': message,
      'createdBy': createdBy,
      'profileImage': profileImage,
      'createdAt': createdAt,
      'clickedByPatients': clickedByPatients,
      'patientToAppointmentMap': patientToAppointmentMap, // Always included now
    };
  }

  @override
  List<Object> get props => [
        emergencyId,
        appointmentUids,
        doctorUid,
        patientUids,
        patientNames,
        message,
        createdBy,
        profileImage,
        createdAt,
        clickedByPatients,
        patientToAppointmentMap,
      ];
}
