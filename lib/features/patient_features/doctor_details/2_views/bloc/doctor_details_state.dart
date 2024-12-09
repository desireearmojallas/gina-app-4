part of 'doctor_details_bloc.dart';

abstract class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object> get props => [];
}

final class DoctorDetailsInitial extends DoctorDetailsState {}
