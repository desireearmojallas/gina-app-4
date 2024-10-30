part of 'declined_request_state_bloc.dart';

sealed class DeclinedRequestStateState extends Equatable {
  const DeclinedRequestStateState();
  
  @override
  List<Object> get props => [];
}

final class DeclinedRequestStateInitial extends DeclinedRequestStateState {}
