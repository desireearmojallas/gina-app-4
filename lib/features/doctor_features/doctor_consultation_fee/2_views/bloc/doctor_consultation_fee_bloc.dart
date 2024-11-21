import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_consultation_fee_event.dart';
part 'doctor_consultation_fee_state.dart';

class DoctorConsultationFeeBloc
    extends Bloc<DoctorConsultationFeeEvent, DoctorConsultationFeeState> {
  DoctorConsultationFeeBloc() : super(DoctorConsultationFeeInitial()) {
    on<DoctorConsultationFeeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
