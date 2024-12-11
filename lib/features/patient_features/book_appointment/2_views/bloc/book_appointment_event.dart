part of 'book_appointment_bloc.dart';

abstract class BookAppointmentEvent extends Equatable {
  const BookAppointmentEvent();

  @override
  List<Object> get props => [];
}

class NavigateToReviewAppointmentEvent extends BookAppointmentEvent {}

class GetDoctorAvailabilityEvent extends BookAppointmentEvent {
  final String doctorId;

  const GetDoctorAvailabilityEvent({required this.doctorId});

  @override
  List<Object> get props => [doctorId];
}

class BookForAnAppointmentEvent extends BookAppointmentEvent {
  final String doctorId;
  final String doctorName;
  final String doctorClinicAddress;
  final String appointmentDate;
  final String appointmentTime;

  const BookForAnAppointmentEvent({
    required this.doctorId,
    required this.doctorName,
    required this.doctorClinicAddress,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  List<Object> get props => [
        doctorId,
        doctorName,
        doctorClinicAddress,
        appointmentDate,
        appointmentTime,
      ];
}

class SelectTimeEvent extends BookAppointmentEvent {
  final int index;
  final String startingTime;
  final String endingTime;

  const SelectTimeEvent({
    required this.index,
    required this.startingTime,
    required this.endingTime,
  });

  @override
  List<Object> get props => [index];
}

class SelectedModeOfAppointmentEvent extends BookAppointmentEvent {
  final int index;
  final String modeOfAppointment;

  const SelectedModeOfAppointmentEvent({
    required this.index,
    required this.modeOfAppointment,
  });

  @override
  List<Object> get props => [index, modeOfAppointment];
}
