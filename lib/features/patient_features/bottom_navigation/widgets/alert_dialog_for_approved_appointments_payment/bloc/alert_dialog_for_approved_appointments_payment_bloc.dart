import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'alert_dialog_for_approved_appointments_payment_event.dart';
part 'alert_dialog_for_approved_appointments_payment_state.dart';

class AlertDialogForApprovedAppointmentsBloc extends Bloc<
    AlertDialogForApprovedAppointmentsPaymentEvent,
    AlertDialogForApprovedAppointmentsPaymentState> {
  AlertDialogForApprovedAppointmentsBloc()
      : super(AlertDialogForApprovedAppointmentsPaymentInitial()) {
    on<AlertDialogForApprovedAppointmentsPaymentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
