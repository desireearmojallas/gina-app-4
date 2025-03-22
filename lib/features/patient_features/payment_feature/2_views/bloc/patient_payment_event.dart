part of 'patient_payment_bloc.dart';

abstract class PatientPaymentEvent {}

class CreatePayment extends PatientPaymentEvent {
  final String externalId;
  final int amount;
  final String payerEmail;
  final String description;

  CreatePayment({
    required this.externalId,
    required this.amount,
    required this.payerEmail,
    required this.description,
  });
}

class UpdatePayment extends PatientPaymentEvent {
  final String paymentId;
  final Map<String, dynamic> updatedData;

  UpdatePayment({required this.paymentId, required this.updatedData});
}

class DeletePayment extends PatientPaymentEvent {
  final String paymentId;

  DeletePayment({required this.paymentId});
}
