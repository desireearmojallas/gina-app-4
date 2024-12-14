part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

abstract class AppointmentActionState extends AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class GetAppointmentsLoading extends AppointmentState {}

class GetAppointmentsLoaded extends AppointmentState {
  final List<AppointmentModel> appointments;

  const GetAppointmentsLoaded({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

class GetAppointmentsError extends AppointmentState {
  final String errorMessage;

  const GetAppointmentsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AppointmentDetailsState extends AppointmentState {
  final AppointmentModel appointment;
  final DoctorModel doctorDetails;
  final UserModel currentPatient;

  const AppointmentDetailsState({
    required this.appointment,
    required this.doctorDetails,
    required this.currentPatient,
  });

  @override
  List<Object> get props => [appointment, doctorDetails, currentPatient];
}

class AppointmentDetailsLoading extends AppointmentState {}

class AppointmentDetailsError extends AppointmentState {
  final String errorMessage;

  const AppointmentDetailsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ConsultationHistoryState extends AppointmentState {
  final AppointmentModel appointment;
  final DoctorModel doctorDetails;
  final UserModel currentPatient;
  final List<String> prescriptionImages;

  const ConsultationHistoryState({
    required this.appointment,
    required this.doctorDetails,
    required this.currentPatient,
    required this.prescriptionImages,
  });

  @override
  List<Object> get props => [
        appointment,
        doctorDetails,
        currentPatient,
        prescriptionImages,
      ];
}

class ConsultationHistoryLoading extends AppointmentState {}

class ConsultationHistoryError extends AppointmentState {
  final String errorMessage;

  const ConsultationHistoryError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class UploadPrescriptionState extends AppointmentState {
  final List<File> prescriptionImage;
  final List<File> imageTitle;

  const UploadPrescriptionState({
    required this.prescriptionImage,
    required this.imageTitle,
  });

  // @override
  // List<Object> get props => [prescriptionImage, imageTitle];
}

class UploadPrescriptionLoading extends AppointmentState {}

class UploadPrescriptionError extends AppointmentState {
  final String errorMessage;

  const UploadPrescriptionError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class UploadingPrescriptionInFirebase extends AppointmentActionState {}

class PrescriptionUploadedSuccessfully extends AppointmentActionState {}

class GetPrescriptionImagesState extends AppointmentActionState {
  final List<String> images;

  GetPrescriptionImagesState({required this.images});

  @override
  List<Object> get props => [images];
}

class GetPrescriptionImagesError extends AppointmentState {
  final String errorMessage;

  const GetPrescriptionImagesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GetPrescriptionImagesLoading extends AppointmentState {}

class NavigateToUploadPrescription extends AppointmentState {}

class CancelAppointmentState extends AppointmentActionState {}

class CancelAppointmentError extends AppointmentActionState {
  final String errorMessage;

  CancelAppointmentError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class CancelAppointmentLoading extends AppointmentActionState {}
