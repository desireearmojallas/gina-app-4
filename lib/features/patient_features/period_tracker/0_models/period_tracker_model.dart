// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PeriodTrackerModel extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const PeriodTrackerModel({
    required this.startDate,
    required this.endDate,
  });

  factory PeriodTrackerModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    return PeriodTrackerModel(
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
    };
  }

  factory PeriodTrackerModel.fromJson(Map<String, dynamic> json) {
    return PeriodTrackerModel(
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
    };
  }

  @override
  List<Object?> get props => [startDate, endDate];
}
