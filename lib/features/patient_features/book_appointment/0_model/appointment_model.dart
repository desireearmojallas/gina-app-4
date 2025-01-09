// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  final String? appointmentUid;
  final String? patientName;
  final String? patientUid;
  final String? doctorName;
  final String? doctorUid;
  final String? doctorClinicAddress;
  String? appointmentDate;
  final String? appointmentTime;
  final int? modeOfAppointment;
  int? appointmentStatus;
  final List<String>? prescriptionImages;
  final bool hasVisitedConsultationRoom;

  AppointmentModel({
    this.appointmentUid,
    this.patientName,
    this.patientUid,
    this.doctorName,
    this.doctorUid,
    this.doctorClinicAddress,
    this.appointmentDate,
    this.appointmentTime,
    this.modeOfAppointment,
    this.appointmentStatus = 0,
    this.prescriptionImages,
    this.hasVisitedConsultationRoom = false,
  });

  static AppointmentModel fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return AppointmentModel(
      appointmentUid: snap.id,
      patientName: json['patientName'] ?? '',
      patientUid: json['patientUid'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorUid: json['doctorUid'] ?? '',
      doctorClinicAddress: json['doctorClinicAddress'] ?? '',
      appointmentDate: json['appointmentDate'] ?? '',
      appointmentTime: json['appointmentTime'] ?? '',
      modeOfAppointment: json['modeOfAppointment'] ?? 0,
      appointmentStatus: json['appointmentStatus'] ?? 0,
      prescriptionImages: List<String>.from(
        json['prescriptionImages'] ?? [],
      ),
      hasVisitedConsultationRoom: json['hasVisitedConsultationRoom'] ?? false,
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentUid: json['appointmentUid'],
      patientName: json['patientName'] ?? '',
      patientUid: json['patientUid'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorUid: json['doctorUid'] ?? '',
      doctorClinicAddress: json['doctorClinicAddress'] ?? '',
      appointmentDate: json['appointmentDate'] ?? '',
      appointmentTime: json['appointmentTime'] ?? '',
      modeOfAppointment: json['modeOfAppointment'] ?? 0,
      appointmentStatus: json['appointmentStatus'] ?? 0,
      prescriptionImages: List<String>.from(
        json['prescriptionImages'] ?? [],
      ),
      hasVisitedConsultationRoom: json['hasVisitedConsultationRoom'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentUid': appointmentUid,
      'patientName': patientName,
      'patientUid': patientUid,
      'doctorName': doctorName,
      'doctorUid': doctorUid,
      'doctorClinicAddress': doctorClinicAddress,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'modeOfAppointment': modeOfAppointment,
      'appointmentStatus': appointmentStatus,
      'prescriptionImages': prescriptionImages,
      'hasVisitedConsultationRoom': hasVisitedConsultationRoom,
    };
  }

  @override
  List<Object?> get props => [
        appointmentUid,
        patientName,
        patientUid,
        doctorName,
        doctorUid,
        doctorClinicAddress,
        appointmentDate,
        appointmentTime,
        modeOfAppointment,
        appointmentStatus,
        prescriptionImages,
        hasVisitedConsultationRoom,
      ];
}
