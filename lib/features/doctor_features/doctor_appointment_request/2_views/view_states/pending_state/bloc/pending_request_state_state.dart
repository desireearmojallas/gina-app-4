part of 'pending_request_state_bloc.dart';

sealed class PendingRequestStateState extends Equatable {
  const PendingRequestStateState();
  
  @override
  List<Object> get props => [];
}

final class PendingRequestStateInitial extends PendingRequestStateState {}
