import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String paymentId;
  final String appointmentId;
  final String invoiceId;
  final String invoiceUrl;
  final double amount;
  final String status;
  final String patientId;
  final String patientName;
  final String doctorName;
  final String consultationType;
  final DateTime appointmentDate;
  final DateTime createdAt;
  final bool isLinkedToAppointment;
  final DateTime? linkedAt;
  final String paymentMethod;

  PaymentModel({
    required this.paymentId,
    required this.appointmentId,
    required this.invoiceId,
    required this.invoiceUrl,
    required this.amount,
    required this.status,
    required this.patientId,
    required this.patientName,
    required this.doctorName,
    required this.consultationType,
    required this.appointmentDate,
    required this.createdAt,
    required this.isLinkedToAppointment,
    this.linkedAt,
    this.paymentMethod = 'Xendit',
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map, String id) {
    return PaymentModel(
      paymentId: id,
      appointmentId: map['appointmentId'] ?? '',
      invoiceId: map['invoiceId'] ?? '',
      invoiceUrl: map['invoiceUrl'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      doctorName: map['doctorName'] ?? '',
      consultationType: map['consultationType'] ?? '',
      appointmentDate: (map['appointmentDate'] is Timestamp)
          ? (map['appointmentDate'] as Timestamp).toDate()
          : DateTime.parse(map['appointmentDate'] as String),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isLinkedToAppointment: map['isLinkedToAppointment'] ?? false,
      linkedAt: map['linkedAt'] != null
          ? (map['linkedAt'] as Timestamp).toDate()
          : null,
      paymentMethod: map['paymentMethod'] ?? 'Xendit',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'invoiceId': invoiceId,
      'invoiceUrl': invoiceUrl,
      'amount': amount,
      'status': status,
      'patientId': patientId,
      'patientName': patientName,
      'doctorName': doctorName,
      'consultationType': consultationType,
      'appointmentDate': appointmentDate.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
      'isLinkedToAppointment': isLinkedToAppointment,
      'linkedAt': linkedAt != null ? FieldValue.serverTimestamp() : null,
      'paymentMethod': paymentMethod,
    };
  }

  PaymentModel copyWith({
    String? paymentId,
    String? appointmentId,
    String? invoiceId,
    String? invoiceUrl,
    double? amount,
    String? status,
    String? patientId,
    String? patientName,
    String? doctorName,
    String? consultationType,
    DateTime? appointmentDate,
    DateTime? createdAt,
    bool? isLinkedToAppointment,
    DateTime? linkedAt,
    String? paymentMethod,
  }) {
    return PaymentModel(
      paymentId: paymentId ?? this.paymentId,
      appointmentId: appointmentId ?? this.appointmentId,
      invoiceId: invoiceId ?? this.invoiceId,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      consultationType: consultationType ?? this.consultationType,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      createdAt: createdAt ?? this.createdAt,
      isLinkedToAppointment: isLinkedToAppointment ?? this.isLinkedToAppointment,
      linkedAt: linkedAt ?? this.linkedAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
} 