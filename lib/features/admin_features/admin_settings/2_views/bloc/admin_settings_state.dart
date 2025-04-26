part of 'admin_settings_bloc.dart';

sealed class AdminSettingsState extends Equatable {
  const AdminSettingsState();

  @override
  List<Object> get props => [];
}

final class AdminSettingsInitial extends AdminSettingsState {}

final class AdminSettingsLoading extends AdminSettingsState {}

final class AdminSettingsLoaded extends AdminSettingsState {
  final List<Map<String, dynamic>> users;
  final String userType;

  const AdminSettingsLoaded({
    required this.users,
    required this.userType,
  });

  @override
  List<Object> get props => [users, userType];
}

final class AdminSettingsError extends AdminSettingsState {
  final String message;

  const AdminSettingsError({required this.message});

  @override
  List<Object> get props => [message];
}

class PlatformFeesLoaded extends AdminSettingsState {
  final double onlinePercentage;
  final double f2fPercentage;

  const PlatformFeesLoaded({
    required this.onlinePercentage,
    required this.f2fPercentage,
  });

  @override
  List<Object> get props => [onlinePercentage, f2fPercentage];
}

class PlatformFeesUpdated extends AdminSettingsState {
  const PlatformFeesUpdated();

  @override
  List<Object> get props => [];
}

class PaymentValiditySettingsLoaded extends AdminSettingsState {
  final int paymentWindowMinutes;

  const PaymentValiditySettingsLoaded({
    required this.paymentWindowMinutes,
  });

  @override
  List<Object> get props => [paymentWindowMinutes];
}

class PaymentValiditySettingsUpdated extends AdminSettingsState {
  const PaymentValiditySettingsUpdated();

  @override
  List<Object> get props => [];
}
