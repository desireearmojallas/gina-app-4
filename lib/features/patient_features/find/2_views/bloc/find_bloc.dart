import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'find_event.dart';
part 'find_state.dart';

class FindBloc extends Bloc<FindEvent, FindState> {
  FindBloc() : super(FindInitial()) {
    on<FindEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
