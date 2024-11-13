part of 'admin_login_bloc.dart';

abstract class AdminLoginEvent extends Equatable {
  const AdminLoginEvent();

  @override
  List<Object> get props => [];
}

class AdminLoginEventLogin extends AdminLoginEvent {
  final String email;
  final String password;

  const AdminLoginEventLogin({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
