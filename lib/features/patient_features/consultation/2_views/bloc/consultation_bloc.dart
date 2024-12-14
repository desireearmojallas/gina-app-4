import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'consultation_event.dart';
part 'consultation_state.dart';

String? chatRoom;
bool isAppointmentFinished = false;
bool isChatWaiting = false;

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  ConsultationBloc() : super(ConsultationInitial()) {}
}
