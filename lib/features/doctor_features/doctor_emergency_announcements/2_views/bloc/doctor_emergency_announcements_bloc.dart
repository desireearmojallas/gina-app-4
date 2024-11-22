import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'doctor_emergency_announcements_event.dart';
part 'doctor_emergency_announcements_state.dart';

class DoctorEmergencyAnnouncementsBloc extends Bloc<DoctorEmergencyAnnouncementsEvent, DoctorEmergencyAnnouncementsState> {
  DoctorEmergencyAnnouncementsBloc() : super(DoctorEmergencyAnnouncementsInitial()) {
    on<DoctorEmergencyAnnouncementsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
