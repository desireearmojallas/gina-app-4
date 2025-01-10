part of 'appointment_details_bloc.dart';

abstract class AppointmentDetailsState extends Equatable {
  const AppointmentDetailsState();

  @override
  List<Object> get props => [];
}

abstract class AppointmentDetailsActionState extends AppointmentDetailsState {}

class AppointmentDetailsInitial extends AppointmentDetailsState {}

class AppointmentDetailsStatusState extends AppointmentDetailsState {
  final AppointmentModel appointment;

  const AppointmentDetailsStatusState({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

class AppointmentDetailsError extends AppointmentDetailsState {
  final String errorMessage;

  const AppointmentDetailsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AppointmentDetailsLoading extends AppointmentDetailsState {}

class CancelAppointmentState extends AppointmentDetailsActionState {}

class CancelAppointmentError extends AppointmentDetailsActionState {
  final String errorMessage;

  CancelAppointmentError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class CancelAppointmentLoading extends AppointmentDetailsActionState {}

class RescheduleAppointmentState extends AppointmentDetailsState {}

class RescheduleAppointmentError extends AppointmentDetailsActionState {
  final String errorMessage;

  RescheduleAppointmentError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class RescheduleAppointmentLoading extends AppointmentDetailsActionState {}

class NavigateToReviewRescheduledAppointmentState
    extends AppointmentDetailsState {
  final DoctorModel doctor;
  final UserModel patient;
  final AppointmentModel appointment;

  const NavigateToReviewRescheduledAppointmentState({
    required this.doctor,
    required this.patient,
    required this.appointment,
  });

  @override
  List<Object> get props => [
        doctor,
        patient,
        appointment,
      ];
}

class NavigateToReviewRescheduledLoadingState extends AppointmentDetailsState {}

class LatestAppointmentDetailsFetchedState extends AppointmentDetailsState {
  final AppointmentModel appointment;

  const LatestAppointmentDetailsFetchedState({required this.appointment});

  @override
  List<Object> get props => [appointment];
}
