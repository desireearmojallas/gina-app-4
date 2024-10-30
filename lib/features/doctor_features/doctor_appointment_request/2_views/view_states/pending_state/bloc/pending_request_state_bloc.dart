import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pending_request_state_event.dart';
part 'pending_request_state_state.dart';

class PendingRequestStateBloc extends Bloc<PendingRequestStateEvent, PendingRequestStateState> {
  PendingRequestStateBloc() : super(PendingRequestStateInitial()) {
    on<PendingRequestStateEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
