import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_payment_event.dart';
part 'doctor_payment_state.dart';

class DoctorPaymentBloc extends Bloc<DoctorPaymentEvent, DoctorPaymentState> {
  DoctorPaymentBloc() : super(DoctorPaymentInitial()) {
    on<DoctorPaymentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
