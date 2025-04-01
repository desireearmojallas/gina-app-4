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
  final bool f2fAppointmentStarted;
  final bool f2fAppointmentConcluded;
  final Timestamp? f2fAppointmentStartedTime;
  final Timestamp? f2fAppointmentConcludedTime;
  final Timestamp? onlineAppointmentCompletedTime;
  final String? paymentStatus;
  final String? xenditInvoiceId;
  final double? amountPaid;
  final double? amount;
  final String? consultationType;

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
    this.f2fAppointmentStarted = false,
    this.f2fAppointmentConcluded = false,
    this.f2fAppointmentStartedTime,
    this.f2fAppointmentConcludedTime,
    this.onlineAppointmentCompletedTime,
    this.paymentStatus,
    this.xenditInvoiceId,
    this.amountPaid,
    this.amount,
    this.consultationType,
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
      f2fAppointmentStarted: json['f2fAppointmentStarted'] ?? false,
      f2fAppointmentConcluded: json['f2fAppointmentConcluded'] ?? false,
      f2fAppointmentStartedTime: json['f2fAppointmentStartedTime'],
      f2fAppointmentConcludedTime: json['f2fAppointmentConcludedTime'],
      onlineAppointmentCompletedTime: json['onlineAppointmentCompletedTime'],
      paymentStatus: json['paymentStatus'],
      xenditInvoiceId: json['xenditInvoiceId'],
      amountPaid: json['amountPaid']?.toDouble(),
      amount: json['amount']?.toDouble(),
      consultationType: json['consultationType'],
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
      f2fAppointmentStarted: json['f2fAppointmentStarted'] ?? false,
      f2fAppointmentConcluded: json['f2fAppointmentConcluded'] ?? false,
      f2fAppointmentStartedTime: json['f2fAppointmentStartedTime'],
      f2fAppointmentConcludedTime: json['f2fAppointmentConcludedTime'],
      onlineAppointmentCompletedTime: json['onlineAppointmentCompletedTime'],
      paymentStatus: json['paymentStatus'],
      xenditInvoiceId: json['xenditInvoiceId'],
      amountPaid: json['amountPaid']?.toDouble(),
      amount: json['amount']?.toDouble(),
      consultationType: json['consultationType'],
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
      'f2fAppointmentStarted': f2fAppointmentStarted,
      'f2fAppointmentConcluded': f2fAppointmentConcluded,
      'f2fAppointmentStartedTime': f2fAppointmentStartedTime,
      'f2fAppointmentConcludedTime': f2fAppointmentConcludedTime,
      'onlineAppointmentCompletedTime': onlineAppointmentCompletedTime,
      'paymentStatus': paymentStatus,
      'xenditInvoiceId': xenditInvoiceId,
      'amountPaid': amountPaid,
      'amount': amount,
      'consultationType': consultationType,
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
        f2fAppointmentStarted,
        f2fAppointmentConcluded,
        f2fAppointmentStartedTime,
        f2fAppointmentConcludedTime,
        onlineAppointmentCompletedTime,
        paymentStatus,
        xenditInvoiceId,
        amountPaid,
        amount,
        consultationType,
      ];
}
