part of 'book_appointment_bloc.dart';

abstract class BookAppointmentState extends Equatable {
  const BookAppointmentState();

  @override
  List<Object> get props => [];
}

abstract class BookAppointmentActionState extends BookAppointmentState {}

class BookAppointmentInitial extends BookAppointmentState {}

class GetDoctorAvailabilityLoading extends BookAppointmentState {}

class GetDoctorAvailabilityLoaded extends BookAppointmentState {
  final DoctorAvailabilityModel doctorAvailabilityModel;
  final int? selectedTimeIndex;
  final int? selectedModeofAppointmentIndex;

  const GetDoctorAvailabilityLoaded({
    required this.doctorAvailabilityModel,
    required this.selectedTimeIndex,
    required this.selectedModeofAppointmentIndex,
  });

  @override
  List<Object> get props => [doctorAvailabilityModel];
}

class GetDoctorAvailabilityError extends BookAppointmentState {
  final String errorMessage;

  const GetDoctorAvailabilityError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ReviewAppointmentState extends BookAppointmentState {
  final AppointmentModel appointmentModel;

  const ReviewAppointmentState({required this.appointmentModel});

  @override
  List<Object> get props => [appointmentModel];
}

class BookAppointmentLoading extends BookAppointmentState {}

class BookAppointmentRequestLoading extends BookAppointmentActionState {}

class BookAppointmentSuccess extends BookAppointmentState {}

class BookAppointmentError extends BookAppointmentState {
  final String errorMessage;

  const BookAppointmentError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class SelectTimeState extends BookAppointmentState {
  final int index;
  final String startingTime;
  final String endingTime;

  const SelectTimeState({
    required this.index,
    required this.startingTime,
    required this.endingTime,
  });

  @override
  List<Object> get props => [index, startingTime, endingTime];
}

class SelectedModeOfAppointmentState extends BookAppointmentState {
  final int index;
  final String modeOfAppointment;

  const SelectedModeOfAppointmentState({
    required this.index,
    required this.modeOfAppointment,
  });

  @override
  List<Object> get props => [index, modeOfAppointment];
}
