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
