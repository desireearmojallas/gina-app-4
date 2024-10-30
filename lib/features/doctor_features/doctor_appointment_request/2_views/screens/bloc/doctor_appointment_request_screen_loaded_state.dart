part of 'doctor_appointment_request_screen_loaded_bloc.dart';

abstract class DoctorAppointmentRequestScreenLoadedState extends Equatable {
  final int currentIndex;
  final Widget selectedScreen;
  final Color backgroundColor;
  const DoctorAppointmentRequestScreenLoadedState({
    required this.currentIndex,
    required this.selectedScreen,
    required this.backgroundColor,
  });

  @override
  List<Object> get props => [currentIndex];
}

final class DoctorAppointmentRequestScreenLoadedInitial
    extends DoctorAppointmentRequestScreenLoadedState {
  const DoctorAppointmentRequestScreenLoadedInitial({
    required super.currentIndex,
    required super.selectedScreen,
    required super.backgroundColor,
  });

  @override
  List<Object> get props => [currentIndex];
}
