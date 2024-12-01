part of 'admin_patient_list_bloc.dart';

abstract class AdminPatientListState extends Equatable {
  const AdminPatientListState();

  @override
  List<Object> get props => [];
}

abstract class AdminPatientListActionState extends AdminPatientListState {}

class AdminPatientListInitial extends AdminPatientListState {}

class AdminPatientListLoadingState extends AdminPatientListActionState {}

class AdminPatientListLoadedState extends AdminPatientListState {
  final List<UserModel> patients;

  const AdminPatientListLoadedState({required this.patients});

  @override
  List<Object> get props => [patients];
}

class AdminPatientListErrorState extends AdminPatientListState {
  final String message;

  const AdminPatientListErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class AdminPatientListPatientDetailsState extends AdminPatientListState {
  final UserModel patientDetails;
  final List<AppointmentModel> appointmentDetails;

  const AdminPatientListPatientDetailsState(
      {required this.patientDetails, required this.appointmentDetails});

  @override
  List<Object> get props => [patientDetails];
}
