import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_forums_event.dart';
part 'my_forums_state.dart';

class MyForumsBloc extends Bloc<MyForumsEvent, MyForumsState> {
  MyForumsBloc() : super(MyForumsInitial()) {
    on<MyForumsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
