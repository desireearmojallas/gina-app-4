import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/1_controllers/admin_patient_list_controller.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

part 'admin_patient_list_event.dart';
part 'admin_patient_list_state.dart';

class AdminPatientListBloc
    extends Bloc<AdminPatientListEvent, AdminPatientListState> {
  final AdminPatientListController adminPatientListController;
  AdminPatientListBloc({
    required this.adminPatientListController,
  }) : super(AdminPatientListInitial()) {
    on<AdminPatientListGetRequestedEvent>(onAdminPatientListGetRequestedEvent);
    on<AdminPatientDetailsEvent>(onAdminPatientDetailsEvent);
  }

  FutureOr<void> onAdminPatientListGetRequestedEvent(
      AdminPatientListGetRequestedEvent event,
      Emitter<AdminPatientListState> emit) async {
    emit(AdminPatientListLoadingState());

    final patients = await adminPatientListController.getAllPatients();

    patients.fold(
      (failure) {
        emit(AdminPatientListErrorState(message: failure.toString()));
      },
      (patients) {
        emit(AdminPatientListLoadedState(patients: patients));
      },
    );
  }

  FutureOr<void> onAdminPatientDetailsEvent(AdminPatientDetailsEvent event,
      Emitter<AdminPatientListState> emit) async {
    final patientUid = event.patientDetails.uid;
    final appointments =
        await adminPatientListController.getCurrentPatientAppointment(
      patientUid: patientUid,
    );

    appointments.fold((failure) {
      emit(AdminPatientListErrorState(message: failure.toString()));
    }, (appointments) {
      emit(AdminPatientListPatientDetailsState(
        patientDetails: event.patientDetails,
        appointmentDetails: appointments,
      ));
    });
  }
}
