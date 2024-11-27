import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/1_controllers/admin_dashboard_controller.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/1_controllers/admin_doctor_verification_controller.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';

part 'admin_dashboard_event.dart';
part 'admin_dashboard_state.dart';

List<DoctorModel> doctorList = [];
List<UserModel> patientList = [];
bool isFromAdminDashboard = false;

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminDashboardController adminDashboardController;
  final AdminDoctorVerificationController adminDoctorVerificationController;

  AdminDashboardBloc({
    required this.adminDashboardController,
    required this.adminDoctorVerificationController,
  }) : super(AdminDashboardInitial()) {
    on<AdminDashboardEvent>((event, emit) {});
  }
}
