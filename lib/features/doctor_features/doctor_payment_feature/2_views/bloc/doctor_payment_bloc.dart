import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'doctor_payment_event.dart';
part 'doctor_payment_state.dart';

class DoctorPaymentBloc extends Bloc<DoctorPaymentEvent, DoctorPaymentState> {
  DoctorPaymentBloc() : super(DoctorPaymentInitial()) {
    on<DoctorPaymentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
