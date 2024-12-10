import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/consultation_fee_details/1_controller/consultation_fee_details_controller.dart';

part 'consultation_fee_details_event.dart';
part 'consultation_fee_details_state.dart';

bool? isPricingFeeShown;

class ConsultationFeeDetailsBloc
    extends Bloc<ConsultationFeeDetailsEvent, ConsultationFeeDetailsState> {
  final ConsultationFeeDetailsController consultationFeeDetailsController;
  ConsultationFeeDetailsBloc({
    required this.consultationFeeDetailsController,
  }) : super(ConsultationFeeDetailsInitial(
          isPricingShown: isPricingFeeShown ?? false,
        )) {
    on<ToggleConsultationFeePricingEvent>(toggleConsultationFeePricingEvent);
  }

  FutureOr<void> toggleConsultationFeePricingEvent(
      ToggleConsultationFeePricingEvent event,
      Emitter<ConsultationFeeDetailsState> emit) async {
    final isPricingShown =
        await consultationFeeDetailsController.getConsultationFeeData();

    isPricingFeeShown = isPricingShown;

    emit(ConsultationFeeDetailsInitial(
      isPricingShown: isPricingShown,
    ));
  }
}
