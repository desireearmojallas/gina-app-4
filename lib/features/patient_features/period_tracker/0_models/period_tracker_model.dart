// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PeriodTrackerModel extends Equatable {
  final List<DateTime> periodDates;
  final List<DateTime> averageBasedPredictionDates;
  final List<DateTime> day28PredictionDates;
  final DateTime startDate;
  final DateTime endDate;
  final int periodLength;
  final bool isLog;
  int cycleLength;

  PeriodTrackerModel({
    required this.periodDates,
    required this.averageBasedPredictionDates,
    required this.day28PredictionDates,
    required this.startDate,
    required this.endDate,
    required this.isLog,
    this.cycleLength = 0,
  }) : periodLength = endDate.difference(startDate).inDays + 1;

  factory PeriodTrackerModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snap) {
    Map<String, dynamic> data = {};
    if (snap.data() != null) {
      data = snap.data() as Map<String, dynamic>;
    }
    return PeriodTrackerModel(
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      isLog: data['isLog'] ?? false,
      periodDates: data['periodDates'] != null
          ? (data['periodDates'] as List)
              .map((date) => (date as Timestamp).toDate())
              .toList()
          : [],
      averageBasedPredictionDates: data['averageBasedPredictionDates'] != null
          ? (data['averageBasedPredictionDates'] as List)
              .map((date) => (date as Timestamp).toDate())
              .toList()
          : [],
      day28PredictionDates: data['day28PredictionDates'] != null
          ? (data['day28PredictionDates'] as List)
              .map((date) => (date as Timestamp).toDate())
              .toList()
          : [],
      cycleLength: data['cycleLength'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'isLog': isLog,
      'cycleLength': cycleLength,
      'periodDates':
          periodDates.map((date) => Timestamp.fromDate(date)).toList(),
      'averageBasedPredictionDates': averageBasedPredictionDates
          .map((date) => Timestamp.fromDate(date))
          .toList(),
      'day28PredictionDates':
          day28PredictionDates.map((date) => Timestamp.fromDate(date)).toList(),
    };
  }

  factory PeriodTrackerModel.fromJson(Map<String, dynamic> json) {
    return PeriodTrackerModel(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isLog: json['isLog'],
      periodDates: json['periodDates'] != null
          ? (json['periodDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList()
          : [],
      averageBasedPredictionDates: json['averageBasedPredictionDates'] != null
          ? (json['averageBasedPredictionDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList()
          : [],
      day28PredictionDates: json['day28PredictionDates'] != null
          ? (json['day28PredictionDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList()
          : [],
      cycleLength: json['cycleLength'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isLog': isLog,
      'cycleLength': cycleLength,
      'periodDates': periodDates.map((date) => date.toIso8601String()).toList(),
      'averageBasedPredictionDates': averageBasedPredictionDates
          .map((date) => date.toIso8601String())
          .toList(),
      'day28PredictionDates':
          day28PredictionDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        periodDates,
        averageBasedPredictionDates,
        day28PredictionDates,
        startDate,
        endDate,
        periodLength,
        isLog,
        cycleLength,
      ];
}
