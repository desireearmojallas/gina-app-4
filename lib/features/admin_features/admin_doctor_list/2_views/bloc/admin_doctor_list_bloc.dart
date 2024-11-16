import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_doctor_list_event.dart';
part 'admin_doctor_list_state.dart';

class AdminDoctorListBloc
    extends Bloc<AdminDoctorListEvent, AdminDoctorListState> {
  AdminDoctorListBloc() : super(AdminDoctorListInitial()) {
    on<AdminDoctorListEvent>((event, emit) {});
  }
}
