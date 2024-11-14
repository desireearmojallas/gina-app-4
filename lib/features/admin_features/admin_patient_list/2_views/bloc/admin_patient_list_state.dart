part of 'admin_patient_list_bloc.dart';

sealed class AdminPatientListState extends Equatable {
  const AdminPatientListState();
  
  @override
  List<Object> get props => [];
}

final class AdminPatientListInitial extends AdminPatientListState {}
