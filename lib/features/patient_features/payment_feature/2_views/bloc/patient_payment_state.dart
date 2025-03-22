part of 'patient_payment_bloc.dart';

abstract class PatientPaymentState {}

class PaymentInitial extends PatientPaymentState {}

class PaymentLoading extends PatientPaymentState {}

class PaymentSuccess extends PatientPaymentState {
  final String? invoiceUrl;

  PaymentSuccess({this.invoiceUrl});
}

class PaymentFailure extends PatientPaymentState {
  final String error;

  PaymentFailure({required this.error});
}
