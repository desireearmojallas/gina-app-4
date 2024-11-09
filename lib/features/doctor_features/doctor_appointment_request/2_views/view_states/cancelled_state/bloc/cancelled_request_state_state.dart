part of 'cancelled_request_state_bloc.dart';

sealed class CancelledRequestStateState extends Equatable {
  const CancelledRequestStateState();
  
  @override
  List<Object> get props => [];
}

final class CancelledRequestStateInitial extends CancelledRequestStateState {}
