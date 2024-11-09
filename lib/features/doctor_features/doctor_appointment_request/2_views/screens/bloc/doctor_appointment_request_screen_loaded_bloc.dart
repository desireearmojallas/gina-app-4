import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/screens/approved_request_state_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/screens/cancelled_request_state_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/screens/declined_request_state_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/screens/pending_request_state_screen.dart';

part 'doctor_appointment_request_screen_loaded_event.dart';
part 'doctor_appointment_request_screen_loaded_state.dart';

class DoctorAppointmentRequestScreenLoadedBloc extends Bloc<
    DoctorAppointmentRequestScreenLoadedEvent,
    DoctorAppointmentRequestScreenLoadedState> {
  DoctorAppointmentRequestScreenLoadedBloc()
      : super(const DoctorAppointmentRequestScreenLoadedInitial(
          currentIndex: 0,
          selectedScreen: PendingRequestStateScreenProvider(),
          backgroundColor: GinaAppTheme.pendingTextColor,
        )) {
    on<DoctorAppointmentRequestScreenLoadedEvent>((event, emit) {
      if (event is TabChangedEvent) {
        switch (event.tab) {
          case 0:
            emit(
              DoctorAppointmentRequestScreenLoadedInitial(
                currentIndex: event.tab,
                backgroundColor: GinaAppTheme.pendingTextColor,
                selectedScreen: const PendingRequestStateScreenProvider(),
              ),
            );
            break;
          case 1:
            emit(
              DoctorAppointmentRequestScreenLoadedInitial(
                currentIndex: event.tab,
                backgroundColor: GinaAppTheme.approvedTextColor,
                selectedScreen: const ApprovedRequestStateScreenProvider(),
              ),
            );
            break;
          case 2:
            emit(
              DoctorAppointmentRequestScreenLoadedInitial(
                currentIndex: event.tab,
                backgroundColor: GinaAppTheme.declinedTextColor,
                selectedScreen: const DeclinedRequestStateScreenProvider(),
              ),
            );
            break;
          case 3:
            emit(
              DoctorAppointmentRequestScreenLoadedInitial(
                currentIndex: event.tab,
                backgroundColor: GinaAppTheme.cancelledTextColor,
                selectedScreen: const CancelledRequestStateScreenProvider(),
              ),
            );
            break;
        }
      }
    });
  }
}
