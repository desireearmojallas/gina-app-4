import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forums_event.dart';
part 'forums_state.dart';

class ForumsBloc extends Bloc<ForumsEvent, ForumsState> {
  ForumsBloc() : super(ForumsInitial()) {
    on<ForumsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
