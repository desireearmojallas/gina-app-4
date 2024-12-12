import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'doctor_upcoming_appointments_event.dart';
part 'doctor_upcoming_appointments_state.dart';

UserModel? patientDataFromDoctorUpcomingAppointmentsBloc;
AppointmentModel? appointmentDataFromDoctorUpcomingAppointmentsBloc;

class DoctorUpcomingAppointmentsBloc extends Bloc<
    DoctorUpcomingAppointmentsEvent, DoctorUpcomingAppointmentsState> {
  DoctorUpcomingAppointmentsBloc()
      : super(DoctorUpcomingAppointmentsInitial()) {}
}
