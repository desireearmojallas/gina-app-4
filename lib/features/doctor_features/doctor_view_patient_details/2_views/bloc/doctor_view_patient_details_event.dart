part of 'doctor_view_patient_details_bloc.dart';

sealed class DoctorViewPatientDetailsEvent extends Equatable {
  const DoctorViewPatientDetailsEvent();

  @override
  List<Object> get props => [];
}

class DoctorViewPatientDetailsFetchRequestedEvent
    extends DoctorViewPatientDetailsEvent {}
