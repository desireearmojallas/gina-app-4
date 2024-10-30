import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'declined_request_state_event.dart';
part 'declined_request_state_state.dart';

class DeclinedRequestStateBloc extends Bloc<DeclinedRequestStateEvent, DeclinedRequestStateState> {
  DeclinedRequestStateBloc() : super(DeclinedRequestStateInitial()) {
    on<DeclinedRequestStateEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
