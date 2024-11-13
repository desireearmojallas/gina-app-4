import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_navigation_drawer_event.dart';
part 'admin_navigation_drawer_state.dart';

class AdminNavigationDrawerBloc
    extends Bloc<AdminNavigationDrawerEvent, AdminNavigationDrawerState> {
  AdminNavigationDrawerBloc() : super(AdminNavigationDrawerInitial()) {
    on<AdminNavigationDrawerEvent>((event, emit) {});
  }
}
