import 'package:equatable/equatable.dart';

class ScheduleModel extends Equatable {
  final List<int> days;
  final List<String> startTimes;
  final List<String> endTimes;
  final List<int> modeOfAppointment;
  final String name;
  final String medicalSpecialty;
  final String officeAddress;

  const ScheduleModel({
    required this.days,
    required this.startTimes,
    required this.endTimes,
    required this.modeOfAppointment,
    required this.name,
    required this.medicalSpecialty,
    required this.officeAddress,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      startTimes: List<String>.from(json['startTimes'] ?? []),
      endTimes: List<String>.from(json['endTimes'] ?? []),
      days: List<int>.from(json['days'] ?? []),
      modeOfAppointment: List<int>.from(json['modeOfAppointment'] ?? []),
      name: json['name'] ?? '',
      medicalSpecialty: json['medicalSpecialty'] ?? '',
      officeAddress: json['officeAddress'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTimes': startTimes,
      'endTimes': endTimes,
      'days': days,
      'modeOfAppointment': modeOfAppointment,
    };
  }

  @override
  List<Object?> get props => [startTimes, endTimes, days, modeOfAppointment];
}
