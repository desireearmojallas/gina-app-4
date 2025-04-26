import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final PlatformFees platformFees;
  final PaymentValiditySettings paymentValidity;

  const AppSettings({
    required this.platformFees,
    required this.paymentValidity,
  });

  static AppSettings empty = AppSettings(
    platformFees: PlatformFees.empty,
    paymentValidity: PaymentValiditySettings.empty,
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
      paymentValidity: json['paymentValidity'] != null
          ? PaymentValiditySettings.fromJson(json['paymentValidity'])
          : PaymentValiditySettings.defaultValues(),
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      platformFees: json['platformFees'] != null
          ? PlatformFees.fromJson(json['platformFees'])
          : PlatformFees.defaultValues(),
      paymentValidity: json['paymentValidity'] != null
          ? PaymentValiditySettings.fromJson(json['paymentValidity'])
          : PaymentValiditySettings.defaultValues(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platformFees': platformFees.toJson(),
      'paymentValidity': paymentValidity.toJson(),
    };
  }

  @override
  List<Object?> get props => [platformFees, paymentValidity];
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

class PaymentValiditySettings extends Equatable {
  final int paymentWindowMinutes;
  final Timestamp? updatedAt;

  const PaymentValiditySettings({
    required this.paymentWindowMinutes,
    this.updatedAt,
  });

  static PaymentValiditySettings empty = const PaymentValiditySettings(
    paymentWindowMinutes: 60, // Default to 60 minutes (1 hour)
    updatedAt: null,
  );

  factory PaymentValiditySettings.fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = {};

    if (snap.data() != null) {
      json = snap.data() as Map<String, dynamic>;
    }

    return PaymentValiditySettings(
      paymentWindowMinutes: json['paymentWindowMinutes'] ?? 60,
      updatedAt: json['updatedAt'] ?? Timestamp.now(),
    );
  }

  factory PaymentValiditySettings.fromJson(Map<String, dynamic> json) {
    return PaymentValiditySettings(
      paymentWindowMinutes: json['paymentWindowMinutes'] ?? 60,
      updatedAt: json['updatedAt'],
    );
  }

  factory PaymentValiditySettings.defaultValues() {
    return PaymentValiditySettings(
      paymentWindowMinutes: 60, // 60 minutes (1 hour) by default
      updatedAt: Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentWindowMinutes': paymentWindowMinutes,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [paymentWindowMinutes, updatedAt];
}
