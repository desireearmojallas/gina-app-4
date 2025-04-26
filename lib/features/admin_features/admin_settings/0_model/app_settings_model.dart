import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final PlatformFees platformFees;

  const AppSettings({
    required this.platformFees,
  });

  static AppSettings empty = AppSettings(
    platformFees: PlatformFees.empty,
  );

  factory AppSettings.fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};

    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }

    return AppSettings(
      platformFees: json['platformFees'] != null
          ? PlatformFees.fromJson(json['platformFees'])
          : PlatformFees.defaultValues(),
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      platformFees: json['platformFees'] != null
          ? PlatformFees.fromJson(json['platformFees'])
          : PlatformFees.defaultValues(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platformFees': platformFees.toJson(),
    };
  }

  @override
  List<Object?> get props => [platformFees];
}

class PlatformFees extends Equatable {
  final double onlinePercentage;
  final double f2fPercentage;
  final Timestamp? updatedAt;

  const PlatformFees({
    required this.onlinePercentage,
    required this.f2fPercentage,
    this.updatedAt,
  });

  static PlatformFees empty = const PlatformFees(
    onlinePercentage: 0.10,
    f2fPercentage: 0.15,
    updatedAt: null,
  );

  factory PlatformFees.fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};

    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }

    return PlatformFees(
      onlinePercentage: json['onlinePercentage']?.toDouble() ?? 0.10,
      f2fPercentage: json['f2fPercentage']?.toDouble() ?? 0.15,
      updatedAt: json['updatedAt'] ?? Timestamp.now(),
    );
  }

  factory PlatformFees.fromJson(Map<String, dynamic> json) {
    return PlatformFees(
      onlinePercentage: json['onlinePercentage']?.toDouble() ?? 0.10,
      f2fPercentage: json['f2fPercentage']?.toDouble() ?? 0.15,
      updatedAt: json['updatedAt'],
    );
  }

  factory PlatformFees.defaultValues() {
    return PlatformFees(
      onlinePercentage: 0.10, // 10%
      f2fPercentage: 0.15, // 15%
      updatedAt: Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onlinePercentage': onlinePercentage,
      'f2fPercentage': f2fPercentage,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [onlinePercentage, f2fPercentage, updatedAt];
}
