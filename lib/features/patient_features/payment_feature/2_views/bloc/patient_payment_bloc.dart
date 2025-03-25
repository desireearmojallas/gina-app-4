import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/enum/enum.dart';

part 'patient_payment_event.dart';
part 'patient_payment_state.dart';

class PatientPaymentBloc
    extends Bloc<PatientPaymentEvent, PatientPaymentState> {
  PatientPaymentBloc() : super(PatientPaymentState()) {
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethod event,
    Emitter<PatientPaymentState> emit,
  ) {
    emit(state.copyWith(
      selectedPaymentMethod: event.paymentMethod,
    ));
  }
}
