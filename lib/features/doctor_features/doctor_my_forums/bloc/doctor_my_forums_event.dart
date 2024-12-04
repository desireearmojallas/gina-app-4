part of 'doctor_my_forums_bloc.dart';

abstract class DoctorMyForumsEvent extends Equatable {
  const DoctorMyForumsEvent();

  @override
  List<Object> get props => [];
}

class GetMyDoctorForumsPostEvent extends DoctorMyForumsEvent {}
