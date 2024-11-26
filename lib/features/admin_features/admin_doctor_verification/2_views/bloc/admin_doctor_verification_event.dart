part of 'admin_doctor_verification_bloc.dart';

abstract class AdminDoctorVerificationEvent extends Equatable {
  const AdminDoctorVerificationEvent();

  @override
  List<Object> get props => [];
}

class AdminDoctorVerificationGetRequestedEvent
    extends AdminDoctorVerificationEvent {}

class AdminVerificationPendingDoctorVerificationListEvent
    extends AdminDoctorVerificationEvent {}

class AdminVerificationApprovedDoctorVerificationListEvent
    extends AdminDoctorVerificationEvent {}

class AdminVerificationDeclinedDoctorVerificationListEvent
    extends AdminDoctorVerificationEvent {}

class NavigateToAdminDoctorDetailsPendingEvent
    extends AdminDoctorVerificationEvent {
  final DoctorModel pendingDoctorDetails;

  const NavigateToAdminDoctorDetailsPendingEvent(
      {required this.pendingDoctorDetails});

  @override
  List<Object> get props => [pendingDoctorDetails];
}

class NavigateToAdminDoctorDetailsApprovedEvent
    extends AdminDoctorVerificationEvent {
  final DoctorModel approvedDoctorDetails;

  const NavigateToAdminDoctorDetailsApprovedEvent(
      {required this.approvedDoctorDetails});

  @override
  List<Object> get props => [approvedDoctorDetails];
}

class NavigateToAdminDoctorDetailsDeclinedEvent
    extends AdminDoctorVerificationEvent {
  final DoctorModel declinedDoctorDetails;

  const NavigateToAdminDoctorDetailsDeclinedEvent(
      {required this.declinedDoctorDetails});

  @override
  List<Object> get props => [declinedDoctorDetails];
}

class AdminDoctorVerificationApproveEvent extends AdminDoctorVerificationEvent {
  final String doctorId;
  final String doctorVerificationId;

  const AdminDoctorVerificationApproveEvent({
    required this.doctorId,
    required this.doctorVerificationId,
  });

  @override
  List<Object> get props => [doctorId, doctorVerificationId];
}

class AdminDoctorVerificationDeclineEvent extends AdminDoctorVerificationEvent {
  final String doctorId;
  final String doctorVerificationId;
  final String declinedReason;

  const AdminDoctorVerificationDeclineEvent(
      {required this.doctorId,
      required this.doctorVerificationId,
      required this.declinedReason});

  @override
  List<Object> get props => [doctorId, doctorVerificationId];
}
