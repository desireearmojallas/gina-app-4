part of 'admin_settings_bloc.dart';

sealed class AdminSettingsEvent extends Equatable {
  const AdminSettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends AdminSettingsEvent {
  final String userType;

  const LoadUsers({required this.userType});

  @override
  List<Object> get props => [userType];
}

class SearchUsers extends AdminSettingsEvent {
  final String userType;
  final String query;

  const SearchUsers({required this.userType, required this.query});

  @override
  List<Object> get props => [userType, query];
}

class SwitchUserType extends AdminSettingsEvent {
  final String userType;

  const SwitchUserType({required this.userType});

  @override
  List<Object> get props => [userType];
}

class DeleteUser extends AdminSettingsEvent {
  final String userId;
  final String userType;

  const DeleteUser({required this.userId, required this.userType});

  @override
  List<Object> get props => [userId, userType];
}

class OptimisticDeleteUser extends AdminSettingsEvent {
  final String userId;

  const OptimisticDeleteUser({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadPlatformFees extends AdminSettingsEvent {
  const LoadPlatformFees();

  @override
  List<Object> get props => [];
}

class UpdatePlatformFees extends AdminSettingsEvent {
  final double onlinePercentage;
  final double f2fPercentage;

  const UpdatePlatformFees({
    required this.onlinePercentage,
    required this.f2fPercentage,
  });

  @override
  List<Object> get props => [onlinePercentage, f2fPercentage];
}

class LoadPaymentValiditySettings extends AdminSettingsEvent {
  const LoadPaymentValiditySettings();

  @override
  List<Object> get props => [];
}

class UpdatePaymentValiditySettings extends AdminSettingsEvent {
  final int paymentWindowMinutes;

  const UpdatePaymentValiditySettings({
    required this.paymentWindowMinutes,
  });

  @override
  List<Object> get props => [paymentWindowMinutes];
}
