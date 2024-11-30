part of 'admin_dashboard_bloc.dart';

abstract class AdminDashboardState extends Equatable {
  const AdminDashboardState();

  @override
  List<Object> get props => [];
}

abstract class AdminDashboardActionState extends AdminDashboardState {}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final List<DoctorModel> doctors;
  final List<UserModel> patients;

  const AdminDashboardLoaded({
    required this.doctors,
    required this.patients,
  });

  @override
  List<Object> get props => [doctors, patients];
}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardError extends AdminDashboardState {
  final String errorMessage;

  const AdminDashboardError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PendingDoctorVerificationListState extends AdminDashboardState {}

class ApprovedDoctorVerificationListState extends AdminDashboardState {}

class DeclinedDoctorVerificationListState extends AdminDashboardState {}

class NavigateToDoctorDetailsPendingState extends AdminDashboardState {
  final DoctorModel pendingDoctorDetails;
  final List<DoctorVerificationModel> doctorVerification;

  const NavigateToDoctorDetailsPendingState(
      {required this.pendingDoctorDetails, required this.doctorVerification});

  @override
  List<Object> get props => [pendingDoctorDetails, doctorVerification];
}

class NavigateToDoctorDetailsApprovedState extends AdminDashboardState {
  final DoctorModel approvedDoctorDetails;
  final List<DoctorVerificationModel> doctorVerification;

  const NavigateToDoctorDetailsApprovedState(
      {required this.approvedDoctorDetails, required this.doctorVerification});

  @override
  List<Object> get props => [approvedDoctorDetails, doctorVerification];
}

class NavigateToDoctorDetailsDeclinedState extends AdminDashboardState {
  final DoctorModel declinedDoctorDetails;
  final List<DoctorVerificationModel> doctorVerification;

  const NavigateToDoctorDetailsDeclinedState(
      {required this.declinedDoctorDetails, required this.doctorVerification});

  @override
  List<Object> get props => [declinedDoctorDetails, doctorVerification];
}

class AdminDashboardApproveState extends AdminDashboardState {}

class AdminDashboardDeclineState extends AdminDashboardState {}

class AdminDashboardApproveErrorState extends AdminDashboardActionState {
  final String errorMessage;

  AdminDashboardApproveErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AdminDashboardDeclineErrorState extends AdminDashboardActionState {
  final String errorMessage;

  AdminDashboardDeclineErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AdminDashboardApproveSuccessState extends AdminDashboardActionState {}

class AdminDashboardDeclineSuccessState extends AdminDashboardActionState {}

class NavigateToAppointmentsBookedList extends AdminDashboardState {
  final List<AppointmentModel> appointments;

  const NavigateToAppointmentsBookedList({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

class NavigateToPatientsList extends AdminDashboardState {
  final List<UserModel> patients;

  const NavigateToPatientsList({required this.patients});

  @override
  List<Object> get props => [patients];
}
