part of 'admin_doctor_verification_bloc.dart';

abstract class AdminDoctorVerificationState extends Equatable {
  const AdminDoctorVerificationState();

  @override
  List<Object> get props => [];
}

abstract class AdminDoctorVerificationActionState
    extends AdminDoctorVerificationState {}

class AdminDoctorVerificationInitial extends AdminDoctorVerificationState {}

class AdminDoctorVerificationLoaded extends AdminDoctorVerificationState {
  final List<DoctorModel> doctors;

  const AdminDoctorVerificationLoaded({required this.doctors});

  @override
  List<Object> get props => [doctors];
}

class AdminDoctorVerificationLoading extends AdminDoctorVerificationState {}

class AdminDoctorVerificationError extends AdminDoctorVerificationState {
  final String errorMessage;

  const AdminDoctorVerificationError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AdminVerificationPendingDoctorVerificationListState
    extends AdminDoctorVerificationState {}

class AdminVerificationApprovedDoctorVerificationListState
    extends AdminDoctorVerificationState {}

class AdminVerificationDeclinedDoctorVerificationListState
    extends AdminDoctorVerificationState {}

class NavigateToAdminDoctorDetailsPendingState
    extends AdminDoctorVerificationState {
  final DoctorModel pendingDoctorDetails;
  final List<DoctorVerificationModel> doctorVerification;

  const NavigateToAdminDoctorDetailsPendingState({
    required this.pendingDoctorDetails,
    required this.doctorVerification,
  });

  @override
  List<Object> get props => [pendingDoctorDetails, doctorVerification];
}

class NavigateToAdminDoctorDetailsApprovedState
    extends AdminDoctorVerificationState {
  final DoctorModel approvedDoctorDetails;
  final List<DoctorVerificationModel> doctorVerification;

  const NavigateToAdminDoctorDetailsApprovedState(
      {required this.approvedDoctorDetails, required this.doctorVerification});

  @override
  List<Object> get props => [approvedDoctorDetails, doctorVerification];
}

class NavigateToAdminDoctorDetailsDeclinedState
    extends AdminDoctorVerificationState {
  final DoctorModel declinedDoctorDetails;
  final List<DoctorVerificationModel> doctorVerification;

  const NavigateToAdminDoctorDetailsDeclinedState(
      {required this.declinedDoctorDetails, required this.doctorVerification});

  @override
  List<Object> get props => [declinedDoctorDetails, doctorVerification];
}

class AdminDoctorVerificationApproveState
    extends AdminDoctorVerificationActionState {}

class AdminDoctorVerificationDeclineState
    extends AdminDoctorVerificationActionState {}

class AdminDoctorVerificationApproveError
    extends AdminDoctorVerificationActionState {
  final String errorMessage;

  AdminDoctorVerificationApproveError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AdminDoctorVerificationDeclineError
    extends AdminDoctorVerificationActionState {
  final String errorMessage;

  AdminDoctorVerificationDeclineError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AdminDoctorVerificationDeclineSuccess
    extends AdminDoctorVerificationActionState {}
