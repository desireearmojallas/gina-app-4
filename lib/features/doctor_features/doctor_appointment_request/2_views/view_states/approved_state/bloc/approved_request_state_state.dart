part of 'approved_request_state_bloc.dart';

sealed class ApprovedRequestStateState extends Equatable {
  const ApprovedRequestStateState();
  
  @override
  List<Object> get props => [];
}

final class ApprovedRequestStateInitial extends ApprovedRequestStateState {}
