import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_econsult_event.dart';
part 'doctor_econsult_state.dart';

String? selectedPatientAppointment;
bool isFromChatRoomLists = false;

class DoctorEconsultBloc
    extends Bloc<DoctorEconsultEvent, DoctorEconsultState> {
  DoctorEconsultBloc() : super(DoctorEconsultInitial()) {
    on<DoctorEconsultEvent>((event, emit) {});
  }
}
