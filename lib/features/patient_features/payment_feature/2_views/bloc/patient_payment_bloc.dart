import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/3_services/patient_payment_service.dart';

part 'patient_payment_event.dart';
part 'patient_payment_state.dart';

class PatientPaymentBloc
    extends Bloc<PatientPaymentEvent, PatientPaymentState> {
  final PaymentService paymentService;

  PatientPaymentBloc({
    required this.paymentService,
  }) : super(PaymentInitial()) {
    on<CreatePayment>(_onCreatePayment);
    on<UpdatePayment>(_onUpdatePayment);
    on<DeletePayment>(_onDeletePayment);
  }

  Future<void> _onCreatePayment(
      CreatePayment event, Emitter<PatientPaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final invoiceUrl = await paymentService.createInvoice(
        externalId: event.externalId,
        amount: event.amount,
        payerEmail: event.payerEmail,
        description: event.description,
      );
      emit(PaymentSuccess(invoiceUrl: invoiceUrl['url'] as String?));
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdatePayment(
      UpdatePayment event, Emitter<PatientPaymentState> emit) async {
    emit(PaymentLoading());
    try {
      // Placeholder - Xendit doesn’t natively support invoice updates
      emit(PaymentFailure(error: 'Updating payments is not supported yet'));
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  Future<void> _onDeletePayment(
      DeletePayment event, Emitter<PatientPaymentState> emit) async {
    emit(PaymentLoading());
    try {
      // Placeholder - Xendit doesn’t natively support invoice deletions
      emit(PaymentFailure(error: 'Deleting payments is not supported yet'));
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }
}
