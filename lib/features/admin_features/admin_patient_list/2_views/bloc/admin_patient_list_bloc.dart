import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_patient_list_event.dart';
part 'admin_patient_list_state.dart';

class AdminPatientListBloc extends Bloc<AdminPatientListEvent, AdminPatientListState> {
  AdminPatientListBloc() : super(AdminPatientListInitial()) {
    on<AdminPatientListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
