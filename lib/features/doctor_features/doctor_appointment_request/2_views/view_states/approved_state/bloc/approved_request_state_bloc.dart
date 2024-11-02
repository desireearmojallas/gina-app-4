import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'approved_request_state_event.dart';
part 'approved_request_state_state.dart';

class ApprovedRequestStateBloc
    extends Bloc<ApprovedRequestStateEvent, ApprovedRequestStateState> {
  ApprovedRequestStateBloc() : super(ApprovedRequestStateInitial()) {
    on<ApprovedRequestStateEvent>((event, emit) {});
  }
}
