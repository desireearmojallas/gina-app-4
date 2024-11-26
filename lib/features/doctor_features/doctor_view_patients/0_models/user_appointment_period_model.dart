import 'package:equatable/equatable.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

class UserAppointmentPeriodModel extends Equatable {
  final List<UserModel> patients;
  final List<PeriodTrackerModel> patientPeriods;
  final List<AppointmentModel> patientAppointments;

  const UserAppointmentPeriodModel({
    required this.patients,
    required this.patientPeriods,
    required this.patientAppointments,
  });

  factory UserAppointmentPeriodModel.fromJson(Map<String, dynamic> json) {
    return UserAppointmentPeriodModel(
      patients: List<UserModel>.from(json['patients'] ?? []),
      patientPeriods:
          List<PeriodTrackerModel>.from(json['patientPeriods'] ?? []),
      patientAppointments:
          List<AppointmentModel>.from(json['patientAppointments'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patients': patients,
      'patientPeriods': patientPeriods,
      'patientAppointments': patientAppointments,
    };
  }

  @override
  List<Object?> get props => [
        patients,
        patientPeriods,
        patientAppointments,
      ];
}
