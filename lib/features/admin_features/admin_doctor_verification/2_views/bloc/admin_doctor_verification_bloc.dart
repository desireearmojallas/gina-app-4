import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_doctor_verification_event.dart';
part 'admin_doctor_verification_state.dart';

class AdminDoctorVerificationBloc extends Bloc<AdminDoctorVerificationEvent, AdminDoctorVerificationState> {
  AdminDoctorVerificationBloc() : super(AdminDoctorVerificationInitial()) {
    on<AdminDoctorVerificationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
