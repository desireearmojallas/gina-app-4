part of 'admin_doctor_list_bloc.dart';

sealed class AdminDoctorListState extends Equatable {
  const AdminDoctorListState();
  
  @override
  List<Object> get props => [];
}

final class AdminDoctorListInitial extends AdminDoctorListState {}
