import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/firebase_options.dart';
import 'package:gina_app_4/gina_app.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

bool? canVibrate;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  canVibrate = await Haptics.canVibrate();
  debugPrint = (String? message, {int? wrapWidth}) {
    debugPrintSynchronously(message, wrapWidth: wrapWidth);
  };

  runApp(const GinaApp());
}
