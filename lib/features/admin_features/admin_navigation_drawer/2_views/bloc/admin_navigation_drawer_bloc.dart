import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_navigation_drawer_event.dart';
part 'admin_navigation_drawer_state.dart';

class AdminNavigationDrawerBloc extends Bloc<AdminNavigationDrawerEvent, AdminNavigationDrawerState> {
  AdminNavigationDrawerBloc() : super(AdminNavigationDrawerInitial()) {
    on<AdminNavigationDrawerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
