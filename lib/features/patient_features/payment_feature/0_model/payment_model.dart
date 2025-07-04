import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  final String? refundStatus;
  final String? refundId;
  final DateTime? refundInitiatedAt;
  final DateTime? refundUpdatedAt;
  final double? refundAmount;
  final String? transferId;
  final String? transferStatus;

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
    this.refundStatus,
    this.refundId,
    this.refundInitiatedAt,
    this.refundUpdatedAt,
    this.refundAmount,
    this.transferId,
    this.transferStatus,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseAppointmentDate(String dateStr) {
      try {
        // First try parsing as ISO format
        return DateTime.parse(dateStr);
      } catch (e) {
        try {
          // Try parsing the format "Friday, 11 of April 2025"
          final dateFormat = DateFormat("EEEE, d 'of' MMMM y");
          return dateFormat.parse(dateStr);
        } catch (e) {
          // If both fail, try parsing as Timestamp
          if (dateStr is Timestamp) {
            return (dateStr as Timestamp).toDate();
          }
          throw FormatException('Invalid date format: $dateStr');
        }
      }
    }

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
          : parseAppointmentDate(map['appointmentDate'] as String),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isLinkedToAppointment: map['isLinkedToAppointment'] ?? false,
      linkedAt: map['linkedAt'] != null
          ? (map['linkedAt'] as Timestamp).toDate()
          : null,
      paymentMethod: map['paymentMethod'] ?? 'Xendit',
      refundStatus: map['refundStatus'],
      refundId: map['refundId'],
      refundInitiatedAt: map['refundInitiatedAt'] != null
          ? (map['refundInitiatedAt'] as Timestamp).toDate()
          : null,
      refundUpdatedAt: map['refundUpdatedAt'] != null
          ? (map['refundUpdatedAt'] as Timestamp).toDate()
          : null,
      refundAmount: map['refundAmount']?.toDouble(),
      transferId: map['transferId'],
      transferStatus: map['transferStatus'],
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
      'createdAt': Timestamp.fromDate(createdAt),
      'isLinkedToAppointment': isLinkedToAppointment,
      'linkedAt': linkedAt != null ? Timestamp.fromDate(linkedAt!) : null,
      'paymentMethod': paymentMethod,
      'refundStatus': refundStatus,
      'refundId': refundId,
      'refundInitiatedAt': refundInitiatedAt != null
          ? Timestamp.fromDate(refundInitiatedAt!)
          : null,
      'refundUpdatedAt': refundUpdatedAt != null
          ? Timestamp.fromDate(refundUpdatedAt!)
          : null,
      'refundAmount': refundAmount,
      'transferId': transferId,
      'transferStatus': transferStatus,
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
    String? refundStatus,
    String? refundId,
    DateTime? refundInitiatedAt,
    DateTime? refundUpdatedAt,
    double? refundAmount,
    String? transferId,
    String? transferStatus,
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
      refundStatus: refundStatus ?? this.refundStatus,
      refundId: refundId ?? this.refundId,
      refundInitiatedAt: refundInitiatedAt ?? this.refundInitiatedAt,
      refundUpdatedAt: refundUpdatedAt ?? this.refundUpdatedAt,
      refundAmount: refundAmount ?? this.refundAmount,
      transferId: transferId ?? this.transferId,
      transferStatus: transferStatus ?? this.transferStatus,
    );
  }
} 