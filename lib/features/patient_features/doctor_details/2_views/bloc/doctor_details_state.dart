part of 'doctor_details_bloc.dart';

abstract class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object> get props => [];
}

abstract class DoctorDetailsActionState extends DoctorDetailsState {}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoading extends DoctorDetailsState {}

class DoctorDetailsLoaded extends DoctorDetailsState {}

class DoctorDetailsNavigateToConsultationState
    extends DoctorDetailsActionState {}
