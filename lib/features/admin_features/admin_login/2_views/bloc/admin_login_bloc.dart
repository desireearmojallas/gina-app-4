import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_login_event.dart';
part 'admin_login_state.dart';

class AdminLoginBloc extends Bloc<AdminLoginEvent, AdminLoginState> {
  AdminLoginBloc() : super(AdminLoginInitial()) {
    on<AdminLoginEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
