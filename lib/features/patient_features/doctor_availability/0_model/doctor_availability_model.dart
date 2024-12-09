import 'package:equatable/equatable.dart';

class DoctorAvailabilityModel extends Equatable {
  final List<int> days;
  final List<String> startTimes;
  final List<String> endTimes;
  final List<int> modeOfAppointment;

  const DoctorAvailabilityModel({
    required this.days,
    required this.startTimes,
    required this.endTimes,
    required this.modeOfAppointment,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityModel(
      startTimes: List<String>.from(json['startTimes'] ?? []),
      endTimes: List<String>.from(json['endTimes'] ?? []),
      days: List<int>.from(json['days'] ?? []),
      modeOfAppointment: List<int>.from(json['modeOfAppointment'] ?? []),
    );
  }

  factory DoctorAvailabilityModel.fromMap(Map<String, dynamic> data) {
    return DoctorAvailabilityModel(
      startTimes: List<String>.from(data['startTimes'] ?? []),
      endTimes: List<String>.from(data['endTimes'] ?? []),
      days: List<int>.from(data['days'] ?? []),
      modeOfAppointment: List<int>.from(data['modeOfAppointment'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTimes': startTimes,
      'endTimes': endTimes,
      'days': days,
      'modeOfAppointment': modeOfAppointment,
    };
  }

  @override
  List<Object> get props => [
        days,
        startTimes,
        endTimes,
        modeOfAppointment,
      ];
}
