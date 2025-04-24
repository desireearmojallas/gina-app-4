import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_settings_event.dart';
part 'admin_settings_state.dart';

class AdminSettingsBloc extends Bloc<AdminSettingsEvent, AdminSettingsState> {
  AdminSettingsBloc() : super(AdminSettingsInitial()) {
    on<AdminSettingsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
