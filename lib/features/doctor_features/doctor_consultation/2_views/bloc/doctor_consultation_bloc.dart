import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_consultation_event.dart';
part 'doctor_consultation_state.dart';

String? doctorChatRoom;
String? selectedPatientUid;
String? selectedPatientName;

class DoctorConsultationBloc
    extends Bloc<DoctorConsultationEvent, DoctorConsultationState> {
  DoctorConsultationBloc() : super(DoctorConsultationInitial()) {
    on<DoctorConsultationEvent>((event, emit) {});
  }
}
