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

  const HomeDashboardInitial({
    required this.pendingAppointments,
    required this.confirmedAppointments,
    required this.doctorName,
  });

  @override
  List<Object> get props => [
        pendingAppointments,
        confirmedAppointments,
        doctorName,
      ];
}

class HomeDashboardNavigateToFindDoctorActionState extends HomeDashboardState {}

class GetDoctorNameState extends HomeDashboardState {
  final String doctorName;

  const GetDoctorNameState({required this.doctorName});

  @override
  List<Object> get props => [doctorName];
}
