part of 'patient_payment_bloc.dart';

class PatientPaymentEvent {}

class SelectPaymentMethod extends PatientPaymentEvent {
  final PaymentMethod paymentMethod;

  SelectPaymentMethod(this.paymentMethod);
}
