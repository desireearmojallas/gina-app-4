import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel extends Equatable {
  final List<int> days;
  final List<String> startTimes;
  final List<String> endTimes;
  final List<int> modeOfAppointment;
  final String name;
  final String medicalSpecialty;
  final String officeAddress;
  final List<Map<String, dynamic>>? disabledTimeSlots;

  const ScheduleModel({
    required this.days,
    required this.startTimes,
    required this.endTimes,
    required this.modeOfAppointment,
    required this.name,
    required this.medicalSpecialty,
    required this.officeAddress,
    this.disabledTimeSlots,
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
      disabledTimeSlots: json['disabledTimeSlots'] != null
          ? List<Map<String, dynamic>>.from(
              (json['disabledTimeSlots'] as List).map(
                (e) => Map<String, dynamic>.from(e),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTimes': startTimes,
      'endTimes': endTimes,
      'days': days,
      'modeOfAppointment': modeOfAppointment,
      'disabledTimeSlots': disabledTimeSlots,
    };
  }

  ScheduleModel copyWith({
    List<int>? days,
    List<String>? startTimes,
    List<String>? endTimes,
    List<int>? modeOfAppointment,
    String? name,
    String? medicalSpecialty,
    String? officeAddress,
    List<Map<String, dynamic>>? disabledTimeSlots,
  }) {
    return ScheduleModel(
      days: days ?? List<int>.from(this.days),
      startTimes: startTimes ?? List<String>.from(this.startTimes),
      endTimes: endTimes ?? List<String>.from(this.endTimes),
      modeOfAppointment:
          modeOfAppointment ?? List<int>.from(this.modeOfAppointment),
      name: name ?? this.name,
      medicalSpecialty: medicalSpecialty ?? this.medicalSpecialty,
      officeAddress: officeAddress ?? this.officeAddress,
      disabledTimeSlots: disabledTimeSlots ??
          (this.disabledTimeSlots == null
              ? null
              : List<Map<String, dynamic>>.from(this
                  .disabledTimeSlots!
                  .map((slot) => Map<String, dynamic>.from(slot)))),
    );
  }

  bool isSlotDisabled(int day, String startTime, String endTime) {
    return disabledTimeSlots?.any((slot) =>
            slot['day'] == day &&
            slot['startTime'] == startTime &&
            slot['endTime'] == endTime) ??
        false;
  }

  @override
  List<Object?> get props => [
        startTimes,
        endTimes,
        days,
        modeOfAppointment,
        disabledTimeSlots,
      ];
}
