part of 'admin_login_bloc.dart';

sealed class AdminLoginState extends Equatable {
  const AdminLoginState();
  
  @override
  List<Object> get props => [];
}

final class AdminLoginInitial extends AdminLoginState {}
