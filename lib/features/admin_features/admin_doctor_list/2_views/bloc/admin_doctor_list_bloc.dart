import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_doctor_list_event.dart';
part 'admin_doctor_list_state.dart';

class AdminDoctorListBloc extends Bloc<AdminDoctorListEvent, AdminDoctorListState> {
  AdminDoctorListBloc() : super(AdminDoctorListInitial()) {
    on<AdminDoctorListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
