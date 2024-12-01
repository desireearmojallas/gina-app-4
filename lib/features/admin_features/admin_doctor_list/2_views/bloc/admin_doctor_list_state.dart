part of 'admin_doctor_list_bloc.dart';

abstract class AdminDoctorListState extends Equatable {
  const AdminDoctorListState();

  @override
  List<Object> get props => [];
}

abstract class AdminDoctorListActionState extends AdminDoctorListState {}

class AdminDoctorListInitial extends AdminDoctorListState {}

class AdminDoctorListLoadingState extends AdminDoctorListActionState {}

class AdminDoctorListLoadedState extends AdminDoctorListActionState {
  final List<DoctorModel> approvedDoctorList;

  AdminDoctorListLoadedState({required this.approvedDoctorList});

  @override
  List<Object> get props => [approvedDoctorList];
}

class AdminDoctorListErrorState extends AdminDoctorListActionState {
  final String message;

  AdminDoctorListErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class AdminDoctorListDoctorDetailsState extends AdminDoctorListState {
  final DoctorModel approvedDoctorDetails;
  final List<DoctorVerificationModel> doctorVerification;
  final List<AppointmentModel> appointmentDetails;

  const AdminDoctorListDoctorDetailsState({
    required this.approvedDoctorDetails,
    required this.doctorVerification,
    required this.appointmentDetails,
  });

  @override
  List<Object> get props => [approvedDoctorDetails];
}
