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
  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final String doctorClinicAddress;
  final String appointmentDate;
  final String appointmentTime;
  final String reasonForAppointment;

  const BookForAnAppointmentEvent({
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorClinicAddress,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.reasonForAppointment,
  });

  @override
  List<Object> get props => [
        appointmentId,
        doctorId,
        doctorName,
        doctorClinicAddress,
        appointmentDate,
        appointmentTime,
        reasonForAppointment,
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
