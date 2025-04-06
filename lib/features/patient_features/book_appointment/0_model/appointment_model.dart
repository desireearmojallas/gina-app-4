// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/0_model/payment_model.dart';

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
  final DateTime? paymentUpdatedAt;
  final List<PaymentModel>? payments;
  final String? refundStatus;
  final String? refundId;
  final DateTime? refundInitiatedAt;
  final DateTime? refundUpdatedAt;
  final double? refundAmount;

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
    this.paymentUpdatedAt,
    this.payments,
    this.refundStatus,
    this.refundId,
    this.refundInitiatedAt,
    this.refundUpdatedAt,
    this.refundAmount,
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
      paymentUpdatedAt: json['paymentUpdatedAt'] != null
          ? (json['paymentUpdatedAt'] as Timestamp).toDate()
          : null,
      payments: json['payments'] != null
          ? (json['payments'] as List)
              .map((payment) => PaymentModel.fromMap(
                  payment as Map<String, dynamic>, payment['paymentId'] ?? ''))
              .toList()
          : null,
      refundStatus: json['refundStatus'],
      refundId: json['refundId'],
      refundInitiatedAt: json['refundInitiatedAt'] != null
          ? (json['refundInitiatedAt'] as Timestamp).toDate()
          : null,
      refundUpdatedAt: json['refundUpdatedAt'] != null
          ? (json['refundUpdatedAt'] as Timestamp).toDate()
          : null,
      refundAmount: json['refundAmount']?.toDouble(),
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
      paymentUpdatedAt: json['paymentUpdatedAt'] != null
          ? (json['paymentUpdatedAt'] as Timestamp).toDate()
          : null,
      payments: json['payments'] != null
          ? (json['payments'] as List)
              .map((payment) => PaymentModel.fromMap(
                  payment as Map<String, dynamic>, payment['paymentId'] ?? ''))
              .toList()
          : null,
      refundStatus: json['refundStatus'],
      refundId: json['refundId'],
      refundInitiatedAt: json['refundInitiatedAt'] != null
          ? (json['refundInitiatedAt'] as Timestamp).toDate()
          : null,
      refundUpdatedAt: json['refundUpdatedAt'] != null
          ? (json['refundUpdatedAt'] as Timestamp).toDate()
          : null,
      refundAmount: json['refundAmount']?.toDouble(),
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
      'paymentUpdatedAt': paymentUpdatedAt != null
          ? Timestamp.fromDate(paymentUpdatedAt!)
          : null,
      'payments': payments?.map((payment) => payment.toMap()).toList(),
      'refundStatus': refundStatus,
      'refundId': refundId,
      'refundInitiatedAt': refundInitiatedAt != null
          ? Timestamp.fromDate(refundInitiatedAt!)
          : null,
      'refundUpdatedAt': refundUpdatedAt != null
          ? Timestamp.fromDate(refundUpdatedAt!)
          : null,
      'refundAmount': refundAmount,
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
        paymentUpdatedAt,
        payments,
        refundStatus,
        refundId,
        refundInitiatedAt,
        refundUpdatedAt,
        refundAmount,
      ];

  AppointmentModel copyWith({
    String? appointmentUid,
    String? patientName,
    String? patientUid,
    String? doctorName,
    String? doctorUid,
    String? doctorClinicAddress,
    String? appointmentDate,
    String? appointmentTime,
    int? modeOfAppointment,
    int? appointmentStatus,
    List<String>? prescriptionImages,
    bool? hasVisitedConsultationRoom,
    bool? f2fAppointmentStarted,
    bool? f2fAppointmentConcluded,
    Timestamp? f2fAppointmentStartedTime,
    Timestamp? f2fAppointmentConcludedTime,
    Timestamp? onlineAppointmentCompletedTime,
    String? paymentStatus,
    String? xenditInvoiceId,
    double? amountPaid,
    double? amount,
    String? consultationType,
    DateTime? paymentUpdatedAt,
    List<PaymentModel>? payments,
    String? refundStatus,
    String? refundId,
    DateTime? refundInitiatedAt,
    DateTime? refundUpdatedAt,
    double? refundAmount,
  }) {
    return AppointmentModel(
      appointmentUid: appointmentUid ?? this.appointmentUid,
      patientName: patientName ?? this.patientName,
      patientUid: patientUid ?? this.patientUid,
      doctorName: doctorName ?? this.doctorName,
      doctorUid: doctorUid ?? this.doctorUid,
      doctorClinicAddress: doctorClinicAddress ?? this.doctorClinicAddress,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      modeOfAppointment: modeOfAppointment ?? this.modeOfAppointment,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      prescriptionImages: prescriptionImages ?? this.prescriptionImages,
      hasVisitedConsultationRoom:
          hasVisitedConsultationRoom ?? this.hasVisitedConsultationRoom,
      f2fAppointmentStarted:
          f2fAppointmentStarted ?? this.f2fAppointmentStarted,
      f2fAppointmentConcluded:
          f2fAppointmentConcluded ?? this.f2fAppointmentConcluded,
      f2fAppointmentStartedTime:
          f2fAppointmentStartedTime ?? this.f2fAppointmentStartedTime,
      f2fAppointmentConcludedTime:
          f2fAppointmentConcludedTime ?? this.f2fAppointmentConcludedTime,
      onlineAppointmentCompletedTime:
          onlineAppointmentCompletedTime ?? this.onlineAppointmentCompletedTime,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      xenditInvoiceId: xenditInvoiceId ?? this.xenditInvoiceId,
      amountPaid: amountPaid ?? this.amountPaid,
      amount: amount ?? this.amount,
      consultationType: consultationType ?? this.consultationType,
      paymentUpdatedAt: paymentUpdatedAt ?? this.paymentUpdatedAt,
      payments: payments ?? this.payments,
      refundStatus: refundStatus ?? this.refundStatus,
      refundId: refundId ?? this.refundId,
      refundInitiatedAt: refundInitiatedAt ?? this.refundInitiatedAt,
      refundUpdatedAt: refundUpdatedAt ?? this.refundUpdatedAt,
      refundAmount: refundAmount ?? this.refundAmount,
    );
  }
}
