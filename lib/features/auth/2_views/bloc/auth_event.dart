part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthInitialEvent extends AuthEvent {}

class AuthLoginPatientEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginPatientEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLoginDoctorEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginDoctorEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterPatientEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String dateOfBirth;
  final String gender;
  final String address;

  const AuthRegisterPatientEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
  });

  @override
  List<Object> get props =>
      [name, email, password, dateOfBirth, gender, address];
}

class AuthRegisterDoctorEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String medicalSpecialty;
  final String medicalLicenseNumber;
  final String boardCertificationOrganization;
  final String boardCertificationDate;
  final String medicalSchool;
  final String medicalSchoolStartDate;
  final String medicalSchoolEndDate;
  final String residencyProgram;
  final String residencyProgramStartDate;
  final String residencyProgramGraduationYear;
  final String fellowShipProgram;
  final String fellowShipProgramStartDate;
  final String fellowShipProgramEndDate;
  final String officeAddress;
  final String officeMapsLocationAddress;
  final String officeLatLngAddress;
  final String officePhoneNumber;

  const AuthRegisterDoctorEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.medicalSpecialty,
    required this.medicalLicenseNumber,
    required this.boardCertificationOrganization,
    required this.boardCertificationDate,
    required this.medicalSchool,
    required this.medicalSchoolStartDate,
    required this.medicalSchoolEndDate,
    required this.residencyProgram,
    required this.residencyProgramStartDate,
    required this.residencyProgramGraduationYear,
    required this.fellowShipProgram,
    required this.fellowShipProgramStartDate,
    required this.fellowShipProgramEndDate,
    required this.officeAddress,
    required this.officeMapsLocationAddress,
    required this.officeLatLngAddress,
    required this.officePhoneNumber,
  });

  @override
  List<Object> get props => [
        name,
        email,
        password,
        medicalSpecialty,
        medicalLicenseNumber,
        boardCertificationOrganization,
        boardCertificationDate,
        medicalSchool,
        medicalSchoolStartDate,
        medicalSchoolEndDate,
        residencyProgram,
        residencyProgramStartDate,
        residencyProgramGraduationYear,
        fellowShipProgram,
        fellowShipProgramStartDate,
        fellowShipProgramEndDate,
        officeAddress,
        officeMapsLocationAddress,
        officeLatLngAddress,
        officePhoneNumber,
      ];
}

class AuthEmitSignUpStateEvent extends AuthEvent {}

class GetDoctorFullContactsEvent extends AuthEvent {}

class NavigateToAdminLoginScreenEvent extends AuthEvent {}

class ChooseMedicalIdImageEvent extends AuthEvent {}

class RemoveMedicalIdImageEvent extends AuthEvent {}

class SubmitDoctorMedicalVerificationEvent extends AuthEvent {
  final String doctorUid;
  final File medicalLicenseImage;
  final String medicalLicenseImageTitle;

  const SubmitDoctorMedicalVerificationEvent({
    required this.doctorUid,
    required this.medicalLicenseImage,
    required this.medicalLicenseImageTitle,
  });

  @override
  List<Object> get props => [
        doctorUid,
        medicalLicenseImage,
        medicalLicenseImageTitle,
      ];
}

class ChangeWaitingForApprovalEvent extends AuthEvent {}

class ProgressBarCompletedEvent extends AuthEvent {}
