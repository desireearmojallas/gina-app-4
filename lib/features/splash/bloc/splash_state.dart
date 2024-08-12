part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

abstract class SplashActionState extends SplashState {}

class SplashInitial extends SplashState {}

class SplashNavigateToLoginState extends SplashActionState {}

class SplashNavigateToDoctorHomeState extends SplashActionState {}

class SplashNavigateToHomeState extends SplashActionState {}

class SplashNavigateToAdminLoginState extends SplashActionState {}

class SplashNavigateToAdminHomeState extends SplashActionState {}
