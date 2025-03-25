part of 'patient_payment_bloc.dart';

class PaymentSuccessData {
  final String refNumber;
  final String date;
  final String time;
  final String paymentMethod;
  final String senderName;
  final String receiverName;
  final double amount;

  PaymentSuccessData({
    required this.refNumber,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.senderName,
    required this.receiverName,
    required this.amount,
  });
}

class PatientPaymentState {
  final PaymentMethod? selectedPaymentMethod;
  final PaymentStatus status;
  final PaymentSuccessData? successData;
  final String? errorMessage;

  PatientPaymentState({
    this.selectedPaymentMethod,
    this.status = PaymentStatus.initial,
    this.successData,
    this.errorMessage,
  });

  PatientPaymentState copyWith({
    PaymentMethod? selectedPaymentMethod,
    PaymentStatus? status,
    PaymentSuccessData? successData,
    String? errorMessage,
  }) {
    return PatientPaymentState(
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      status: status ?? this.status,
      successData: successData ?? this.successData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
