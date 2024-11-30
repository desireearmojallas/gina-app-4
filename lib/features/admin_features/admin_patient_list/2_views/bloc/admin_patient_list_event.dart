part of 'admin_patient_list_bloc.dart';

abstract class AdminPatientListEvent extends Equatable {
  const AdminPatientListEvent();

  @override
  List<Object> get props => [];
}

class AdminPatientListInitialEvent extends AdminPatientListEvent {}

class AdminPatientListGetRequestedEvent extends AdminPatientListEvent {}

class AdminPatientDetailsEvent extends AdminPatientListEvent {
  final UserModel patientDetails;

  const AdminPatientDetailsEvent({required this.patientDetails});

  @override
  List<Object> get props => [patientDetails];
}

//! continue with patient list.