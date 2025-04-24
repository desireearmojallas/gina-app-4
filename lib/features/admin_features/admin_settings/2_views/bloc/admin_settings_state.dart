part of 'admin_settings_bloc.dart';

sealed class AdminSettingsState extends Equatable {
  const AdminSettingsState();
  
  @override
  List<Object> get props => [];
}

final class AdminSettingsInitial extends AdminSettingsState {}
