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
  final String? appointmentId;
  final String? doctorName;
  final String? consultationType;
  final double? amount;
  final DateTime? appointmentDate;

  const GetDoctorAvailabilityLoaded({
    required this.doctorAvailabilityModel,
    required this.selectedTimeIndex,
    required this.selectedModeofAppointmentIndex,
    this.appointmentId,
    this.doctorName,
    this.consultationType,
    this.amount,
    this.appointmentDate,
  });

  @override
  List<Object> get props => [
        doctorAvailabilityModel,
        selectedTimeIndex ?? -1,
        selectedModeofAppointmentIndex ?? -1,
        appointmentId ?? '',
        doctorName ?? '',
        consultationType ?? '',
        amount ?? 0.0,
        appointmentDate ?? DateTime(1970, 1, 1),
      ];
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
  List<Object> get props => [index];
}

class BookForAnAppointmentReview extends BookAppointmentState {
  final AppointmentModel appointmentModel;

  const BookForAnAppointmentReview({
    required this.appointmentModel,
  });

  @override
  List<Object> get props => [appointmentModel];
}
