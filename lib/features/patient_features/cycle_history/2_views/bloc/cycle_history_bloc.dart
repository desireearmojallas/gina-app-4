import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cycle_history_event.dart';
part 'cycle_history_state.dart';

class CycleHistoryBloc extends Bloc<CycleHistoryEvent, CycleHistoryState> {
  CycleHistoryBloc() : super(CycleHistoryInitial()) {
    on<CycleHistoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
