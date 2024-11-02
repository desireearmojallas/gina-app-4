import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cancelled_request_state_event.dart';
part 'cancelled_request_state_state.dart';

class CancelledRequestStateBloc
    extends Bloc<CancelledRequestStateEvent, CancelledRequestStateState> {
  CancelledRequestStateBloc() : super(CancelledRequestStateInitial()) {
    on<CancelledRequestStateEvent>((event, emit) {});
  }
}
