part of 'doctor_forums_bloc.dart';

sealed class DoctorForumsState extends Equatable {
  const DoctorForumsState();
  
  @override
  List<Object> get props => [];
}

final class DoctorForumsInitial extends DoctorForumsState {}
