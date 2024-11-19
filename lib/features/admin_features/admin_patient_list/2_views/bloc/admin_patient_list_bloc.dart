import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_patient_list_event.dart';
part 'admin_patient_list_state.dart';

class AdminPatientListBloc
    extends Bloc<AdminPatientListEvent, AdminPatientListState> {
  AdminPatientListBloc() : super(AdminPatientListInitial()) {
    on<AdminPatientListEvent>((event, emit) {});
  }
}
