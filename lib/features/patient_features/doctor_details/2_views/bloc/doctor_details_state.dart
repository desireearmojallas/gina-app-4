part of 'doctor_details_bloc.dart';

abstract class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object> get props => [];
}

abstract class DoctorDetailsActionState extends DoctorDetailsState {}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoading extends DoctorDetailsState {}

class DoctorDetailsError extends DoctorDetailsState {
  final String message;

  const DoctorDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

class DoctorDetailsLoaded extends DoctorDetailsState {
  final AppointmentModel appointment;

  const DoctorDetailsLoaded({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class DoctorDetailsNavigateToConsultationState
    extends DoctorDetailsActionState {}

class DoctorOfficeAddressMapViewState extends DoctorDetailsActionState {}
