import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'declined_request_state_event.dart';
part 'declined_request_state_state.dart';

class DeclinedRequestStateBloc
    extends Bloc<DeclinedRequestStateEvent, DeclinedRequestStateState> {
  DeclinedRequestStateBloc() : super(DeclinedRequestStateInitial()) {
    on<DeclinedRequestStateEvent>((event, emit) {});
  }
}
