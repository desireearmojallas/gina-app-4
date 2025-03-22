part of 'doctor_payment_bloc.dart';

sealed class DoctorPaymentState extends Equatable {
  const DoctorPaymentState();
  
  @override
  List<Object> get props => [];
}

final class DoctorPaymentInitial extends DoctorPaymentState {}
