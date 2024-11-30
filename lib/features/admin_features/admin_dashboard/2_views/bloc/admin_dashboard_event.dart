part of 'admin_dashboard_bloc.dart';

abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();

  @override
  List<Object> get props => [];
}

class AdminDashboardGetRequestedEvent extends AdminDashboardEvent {}

class PendingDoctorVerificationListEvent extends AdminDashboardEvent {}

class ApprovedDoctorVerificationListEvent extends AdminDashboardEvent {}

class DeclinedDoctorVerificationListEvent extends AdminDashboardEvent {}

class NavigateToDoctorDetailsPendingEvent extends AdminDashboardEvent {
  final DoctorModel pendingDoctorDetails;

  const NavigateToDoctorDetailsPendingEvent(
      {required this.pendingDoctorDetails});

  @override
  List<Object> get props => [pendingDoctorDetails];
}

class NavigateToDoctorDetailsApprovedEvent extends AdminDashboardEvent {
  final DoctorModel approvedDoctorDetails;

  const NavigateToDoctorDetailsApprovedEvent(
      {required this.approvedDoctorDetails});

  @override
  List<Object> get props => [approvedDoctorDetails];
}

class NavigateToDoctorDetailsDeclinedEvent extends AdminDashboardEvent {
  final DoctorModel declinedDoctorDetails;

  const NavigateToDoctorDetailsDeclinedEvent(
      {required this.declinedDoctorDetails});

  @override
  List<Object> get props => [declinedDoctorDetails];
}

class AdminDashboardApproveEvent extends AdminDashboardEvent {
  final String doctorId;
  final String doctorVerificationId;

  const AdminDashboardApproveEvent(
      {required this.doctorId, required this.doctorVerificationId});

  @override
  List<Object> get props => [doctorId, doctorVerificationId];
}

class AdminDashboardDeclineEvent extends AdminDashboardEvent {
  final String doctorId;
  final String doctorVerificationId;
  final String declinedReason;

  const AdminDashboardDeclineEvent(
      {required this.doctorId,
      required this.doctorVerificationId,
      required this.declinedReason});

  @override
  List<Object> get props => [doctorId, doctorVerificationId];
}

class AdminDashboardNavigateToListOfAllAppointmentsEvent
    extends AdminDashboardEvent {}

class AdminDashboardNavigateToListOfAllPatientsEvent
    extends AdminDashboardEvent {}
