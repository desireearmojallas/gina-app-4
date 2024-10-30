import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cancelled_request_state_event.dart';
part 'cancelled_request_state_state.dart';

class CancelledRequestStateBloc extends Bloc<CancelledRequestStateEvent, CancelledRequestStateState> {
  CancelledRequestStateBloc() : super(CancelledRequestStateInitial()) {
    on<CancelledRequestStateEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
