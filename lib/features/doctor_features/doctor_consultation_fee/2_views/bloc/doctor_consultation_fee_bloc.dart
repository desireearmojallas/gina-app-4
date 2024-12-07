import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/1_controllers/doctor_consultation_fee_controller.dart';

part 'doctor_consultation_fee_event.dart';
part 'doctor_consultation_fee_state.dart';

class DoctorConsultationFeeBloc
    extends Bloc<DoctorConsultationFeeEvent, DoctorConsultationFeeState> {
  final DoctorConsultationFeeController doctorConsultationFeeController;
  DoctorConsultationFeeBloc({
    required this.doctorConsultationFeeController,
  }) : super(DoctorConsultationFeeInitial()) {
    on<GetDoctorConsultationFeeEvent>(getCurrentDoctor);
    on<NavigateToEditDoctorConsultationFeeEvent>(
        navigateToEditDoctorConsultationFeeEvent);
    on<ToggleDoctorConsultationFeeEvent>(toggleDoctorConsultationFee);
    on<SaveEditDoctorConsultationFeeEvent>(saveEditDoctorConsultationFee);
  }

  FutureOr<void> getCurrentDoctor(GetDoctorConsultationFeeEvent event,
      Emitter<DoctorConsultationFeeState> emit) async {
    emit(DoctorConsultationFeeLoadingState());

    final getCurrentDoctorData =
        await doctorConsultationFeeController.getCurrentDoctor();

    getCurrentDoctorData.fold(
      (failure) {
        emit(DoctorConsultationFeeErrorState(
          errorMessage: failure.toString(),
        ));
      },
      (doctorData) {
        emit(DoctorConsultationFeeLoadedState(doctor: doctorData));
      },
    );
  }

  FutureOr<void> navigateToEditDoctorConsultationFeeEvent(
      NavigateToEditDoctorConsultationFeeEvent event,
      Emitter<DoctorConsultationFeeState> emit) async {
    emit(DoctorConsultationFeeLoadingState());

    final getCurrentDoctorData =
        await doctorConsultationFeeController.getCurrentDoctor();

    getCurrentDoctorData.fold(
      (failure) {
        emit(DoctorConsultationFeeErrorState(
          errorMessage: failure.toString(),
        ));
      },
      (doctorData) {
        emit(
          NavigateToEditDoctorConsultationFeeState(doctorData: doctorData),
        );
      },
    );
  }

  FutureOr<void> toggleDoctorConsultationFee(
      ToggleDoctorConsultationFeeEvent event,
      Emitter<DoctorConsultationFeeState> emit) async {
    await doctorConsultationFeeController.toggleDoctorConsultationPriceFee();
  }

  FutureOr<void> saveEditDoctorConsultationFee(
      SaveEditDoctorConsultationFeeEvent event,
      Emitter<DoctorConsultationFeeState> emit) async {
    try {
      await doctorConsultationFeeController.updateDoctorConsultationFee(
        f2fInitialConsultationPrice: event.f2fInitialConsultationPrice,
        f2fFollowUpConsultationPrice: event.f2fFollowUpConsultationPrice,
        olInitialConsultationPrice: event.olInitialConsultationPrice,
        olFollowUpConsultationPrice: event.olFollowUpConsultationPrice,
      );
    } catch (e) {
      emit(DoctorConsultationFeeErrorState(errorMessage: e.toString()));
    }
  }
}
