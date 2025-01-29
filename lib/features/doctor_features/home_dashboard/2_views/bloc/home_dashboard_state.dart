part of 'home_dashboard_bloc.dart';

sealed class HomeDashboardState extends Equatable {
  const HomeDashboardState();

  @override
  List<Object> get props => [];
}

abstract class HomeDashboardActionState extends HomeDashboardState {}

// class HomeDashboardInitial extends HomeDashboardState {
//   final int pendingAppointments;
//   final int confirmedAppointments;

//   const HomeDashboardInitial({
//     required this.pendingAppointments,
//     required this.confirmedAppointments,
//   });

//   @override
//   List<Object> get props => [
//         pendingAppointments,
//         confirmedAppointments,
//       ];
// }

class HomeDashboardInitial extends HomeDashboardState {
  final int pendingAppointments;
  final int confirmedAppointments;
  final String doctorName;
  final AppointmentModel? upcomingAppointment;
  final AppointmentModel? pendingAppointmentLatest;
  final AppointmentModel? selectedAppointment;
  final UserModel? patientData;
  final Map<DateTime, List<AppointmentModel>>? completedAppointmentList;

  const HomeDashboardInitial({
    required this.pendingAppointments,
    required this.confirmedAppointments,
    required this.doctorName,
    this.upcomingAppointment,
    this.pendingAppointmentLatest,
    this.patientData,
    this.completedAppointmentList,
    this.selectedAppointment,
  });

  @override
  List<Object> get props => [
        pendingAppointments,
        confirmedAppointments,
        doctorName,
        upcomingAppointment ?? Object(),
        pendingAppointmentLatest ?? Object(),
        patientData ?? Object(),
        completedAppointmentList ?? Object(),
        selectedAppointment ?? Object(),
      ];
}

class HomeDashboardNavigateToFindDoctorActionState extends HomeDashboardState {}

class GetDoctorNameState extends HomeDashboardState {
  final String doctorName;

  const GetDoctorNameState({required this.doctorName});

  @override
  List<Object> get props => [doctorName];
}
