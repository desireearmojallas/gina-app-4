import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/1_controllers/admin_settings_controller.dart';

part 'admin_settings_event.dart';
part 'admin_settings_state.dart';

class AdminSettingsBloc extends Bloc<AdminSettingsEvent, AdminSettingsState> {
  final AdminSettingsController adminSettingsController;

  AdminSettingsBloc({required this.adminSettingsController})
      : super(AdminSettingsInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SearchUsers>(_onSearchUsers);
    on<SwitchUserType>(_onSwitchUserType);
    on<DeleteUser>(_onDeleteUser);
    on<OptimisticDeleteUser>(_onOptimisticDeleteUser);
    on<LoadPlatformFees>(_onLoadPlatformFees);
    on<UpdatePlatformFees>(_onUpdatePlatformFees);
    on<LoadPaymentValiditySettings>(_onLoadPaymentValiditySettings);
    on<UpdatePaymentValiditySettings>(_onUpdatePaymentValiditySettings);
  }

  Future<void> _onLoadUsers(
      LoadUsers event, Emitter<AdminSettingsState> emit) async {
    emit(AdminSettingsLoading());

    final result = await adminSettingsController.getUsers(event.userType);

    result.fold(
        (exception) => emit(AdminSettingsError(message: exception.toString())),
        (users) =>
            emit(AdminSettingsLoaded(users: users, userType: event.userType)));
  }

  Future<void> _onSearchUsers(
      SearchUsers event, Emitter<AdminSettingsState> emit) async {
    emit(AdminSettingsLoading());

    final result = event.query.isEmpty
        ? await adminSettingsController.getUsers(event.userType)
        : await adminSettingsController.searchUsers(
            event.userType, event.query);

    result.fold(
        (exception) => emit(AdminSettingsError(
            message: 'Error searching users: ${exception.toString()}')),
        (users) =>
            emit(AdminSettingsLoaded(users: users, userType: event.userType)));
  }

  Future<void> _onSwitchUserType(
      SwitchUserType event, Emitter<AdminSettingsState> emit) async {
    emit(AdminSettingsLoading());

    final result = await adminSettingsController.getUsers(event.userType);

    result.fold(
        (exception) => emit(AdminSettingsError(
            message:
                'Error loading ${event.userType}: ${exception.toString()}')),
        (users) =>
            emit(AdminSettingsLoaded(users: users, userType: event.userType)));
  }

  // Simplified delete user handler
  Future<void> _onDeleteUser(
      DeleteUser event, Emitter<AdminSettingsState> emit) async {
    final currentState = state;
    if (currentState is AdminSettingsLoaded) {
      // First update UI optimistically for better UX
      add(OptimisticDeleteUser(userId: event.userId));

      // Perform actual deletion in background
      final deleteResult = await adminSettingsController.deleteUser(
          event.userId, event.userType);

      // Handle result
      deleteResult.fold((exception) {
        // On error, show error and reload
        emit(AdminSettingsError(
            message: 'Error deleting user: ${exception.toString()}'));
        // Reload to get correct data
        add(LoadUsers(userType: currentState.userType));
      }, (success) {
        // Success is already reflected in the UI from OptimisticDeleteUser
      });
    }
  }

  // Optimistic UI update - immediately remove user from list
  void _onOptimisticDeleteUser(
      OptimisticDeleteUser event, Emitter<AdminSettingsState> emit) {
    final currentState = state;
    if (currentState is AdminSettingsLoaded) {
      final updatedUsers = List<Map<String, dynamic>>.from(currentState.users)
        ..removeWhere((user) => user['id'] == event.userId);

      emit(AdminSettingsLoaded(
        users: updatedUsers,
        userType: currentState.userType,
      ));
    }
  }

  Future<void> _onLoadPlatformFees(
      LoadPlatformFees event, Emitter<AdminSettingsState> emit) async {
    emit(AdminSettingsLoading());

    try {
      final result = await adminSettingsController.getPlatformFees();

      result.fold(
        (exception) => emit(AdminSettingsError(message: exception.toString())),
        (platformFees) => emit(PlatformFeesLoaded(
          onlinePercentage: platformFees.onlinePercentage,
          f2fPercentage: platformFees.f2fPercentage,
        )),
      );
    } catch (e) {
      emit(AdminSettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePlatformFees(
      UpdatePlatformFees event, Emitter<AdminSettingsState> emit) async {
    emit(AdminSettingsLoading());

    try {
      final result = await adminSettingsController.updatePlatformFees(
        onlinePercentage: event.onlinePercentage,
        f2fPercentage: event.f2fPercentage,
      );

      result.fold(
        (exception) => emit(AdminSettingsError(message: exception.toString())),
        (success) {
          emit(const PlatformFeesUpdated());

          emit(PlatformFeesLoaded(
            onlinePercentage: event.onlinePercentage,
            f2fPercentage: event.f2fPercentage,
          ));
        },
      );
    } catch (e) {
      emit(AdminSettingsError(message: e.toString()));
    }
  }

  Future<void> _onLoadPaymentValiditySettings(LoadPaymentValiditySettings event,
      Emitter<AdminSettingsState> emit) async {
    emit(AdminSettingsLoading());

    try {
      final result = await adminSettingsController.getPaymentValiditySettings();

      result.fold(
        (exception) => emit(AdminSettingsError(message: exception.toString())),
        (settings) => emit(PaymentValiditySettingsLoaded(
          paymentWindowMinutes: settings.paymentWindowMinutes,
        )),
      );
    } catch (e) {
      emit(AdminSettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePaymentValiditySettings(
      UpdatePaymentValiditySettings event,
      Emitter<AdminSettingsState> emit) async {
    emit(AdminSettingsLoading());

    try {
      final result =
          await adminSettingsController.updatePaymentValiditySettings(
        paymentWindowMinutes: event.paymentWindowMinutes,
      );

      result.fold(
        (exception) => emit(AdminSettingsError(message: exception.toString())),
        (success) {
          emit(const PaymentValiditySettingsUpdated());

          emit(PaymentValiditySettingsLoaded(
            paymentWindowMinutes: event.paymentWindowMinutes,
          ));
        },
      );
    } catch (e) {
      emit(AdminSettingsError(message: e.toString()));
    }
  }
}
