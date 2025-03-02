part of 'doctor_my_forums_bloc.dart';

abstract class DoctorMyForumsState extends Equatable {
  const DoctorMyForumsState();

  @override
  List<Object> get props => [];
}

abstract class DoctorMyForumsActionState extends DoctorMyForumsState {}

class DoctorMyForumsInitial extends DoctorMyForumsState {}

class GetMyForumsPostState extends DoctorMyForumsState {
  final List<ForumModel> myForumsPost;
  final User? currentUser;
  final DoctorModel? doctorModel;

  const GetMyForumsPostState({
    required this.myForumsPost,
    required this.currentUser,
    this.doctorModel,
  });

  @override
  List<Object> get props => [myForumsPost, currentUser!, doctorModel ?? ''];
}

class GetMyForumsPostErrorState extends DoctorMyForumsState {
  final String error;

  const GetMyForumsPostErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class GetMyForumsLoadingState extends DoctorMyForumsState {}

class GetMyForumsPostEmptyState extends DoctorMyForumsState {}

class DeleteMyForumsPostSuccessState extends DoctorMyForumsState {}
