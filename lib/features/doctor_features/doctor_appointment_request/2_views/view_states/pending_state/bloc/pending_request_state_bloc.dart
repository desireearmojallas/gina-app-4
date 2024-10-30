import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pending_request_state_event.dart';
part 'pending_request_state_state.dart';

class PendingRequestStateBloc
    extends Bloc<PendingRequestStateEvent, PendingRequestStateState> {
  PendingRequestStateBloc() : super(PendingRequestStateInitial()) {
    on<PendingRequestStateEvent>((event, emit) {});
  }
}
