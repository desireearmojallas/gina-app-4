part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

abstract class AuthActionState extends AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthRegisterPatientSuccessState extends AuthActionState {}

class AuthLoginPatientSuccessState extends AuthActionState {}

class AuthLoginDoctorSuccessState extends AuthActionState {}

class AuthRegisterDoctorSuccessState extends AuthActionState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthLoginPatientFailureState extends AuthActionState {
  final String message;

  AuthLoginPatientFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthLoginDoctorFailureState extends AuthActionState {
  final String message;

  AuthLoginDoctorFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthRegisterPatientFailureState extends AuthActionState {
  final String message;

  AuthRegisterPatientFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthLoginLoadingState extends AuthState {}

class AuthRegisterLoadingState extends AuthState {}

class AuthRegisterDoctorFailureState extends AuthActionState {
  final String message;

  AuthRegisterDoctorFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthEmitSignUpScreenState extends AuthState {}

class DoctorGetFullContactsState extends AuthState {}

class NavigateToAdminLoginScreenState extends AuthActionState {}

class UploadMedicalImageState extends AuthState {
  final File medicalImageId;
  final File medicalImageIdTitle;
  final bool hasShownProgressBar;

  const UploadMedicalImageState({
    required this.medicalImageId,
    required this.medicalImageIdTitle,
    this.hasShownProgressBar = false,
  });

  @override
  List<Object> get props => [
        medicalImageId,
        medicalImageIdTitle,
        hasShownProgressBar,
      ];

  UploadMedicalImageState copyWith({
    File? medicalImageId,
    File? medicalImageIdTitle,
    bool? hasShownProgressBar,
  }) {
    return UploadMedicalImageState(
      medicalImageId: medicalImageId ?? this.medicalImageId,
      medicalImageIdTitle: medicalImageIdTitle ?? this.medicalImageIdTitle,
      hasShownProgressBar: hasShownProgressBar ?? this.hasShownProgressBar,
    );
  }
}

class UploadMedicalImageLoadingState extends AuthActionState {}

class UploadMedicalImageFailureState extends AuthState {
  final String message;

  const UploadMedicalImageFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class UploadMedicalImageSuccessState extends AuthActionState {}

class SubmittingVerificationLoadingState extends AuthActionState {}

class AuthWaitingForApprovalState extends AuthActionState {}

class AuthVerificationDeclinedState extends AuthActionState {
  final String declineReason;

  AuthVerificationDeclinedState({required this.declineReason});

  @override
  List<Object> get props => [declineReason];
}

class AuthVerificationApprovedState extends AuthActionState {}
