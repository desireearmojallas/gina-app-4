part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

abstract class ForgotPasswordActionState extends ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

class RequestPasswordResetLoading extends ForgotPasswordActionState {}

class RequestPasswordResetError extends ForgotPasswordActionState {
  final String errorMessage;

  RequestPasswordResetError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class RequestPasswordResetSuccess extends ForgotPasswordActionState {
  RequestPasswordResetSuccess();
}

class CountdownState extends ForgotPasswordActionState {
  final int countdown;

  CountdownState({required this.countdown});

  @override
  List<Object> get props => [countdown];
}

class CountdownCompleteState extends ForgotPasswordActionState {}
