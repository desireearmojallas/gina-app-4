part of 'admin_login_bloc.dart';

abstract class AdminLoginState extends Equatable {
  const AdminLoginState();

  @override
  List<Object> get props => [];
}

abstract class AdminLoginActionState extends AdminLoginState {}

class AdminLoginInitial extends AdminLoginState {}

class AdminLoginLoadingState extends AdminLoginState {}

class AdminLoginSuccessState extends AdminLoginActionState {}

class AdminLoginFailureState extends AdminLoginActionState {
  final String message;

  AdminLoginFailureState(this.message);

  @override
  List<Object> get props => [message];
}
