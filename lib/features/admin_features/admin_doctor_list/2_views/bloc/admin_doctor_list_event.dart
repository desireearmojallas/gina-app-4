part of 'admin_doctor_list_bloc.dart';

abstract class AdminDoctorListEvent extends Equatable {
  const AdminDoctorListEvent();

  @override
  List<Object> get props => [];
}

class AdminDoctorListInitialEvent extends AdminDoctorListEvent {}

class AdminDoctorListGetRequestEvent extends AdminDoctorListEvent {}

class AdminDoctorDetailsEvent extends AdminDoctorListEvent {
  final DoctorModel doctorApproved;

  const AdminDoctorDetailsEvent({required this.doctorApproved});

  @override
  List<Object> get props => [doctorApproved];
}
