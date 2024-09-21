import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/firebase_options.dart';
import 'package:gina_app_4/gina_app.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MenstrualCycleWidget.init(secretKey: "11a1215l0119a140409p0919", ivKey: "23a1dfr5lyhd9a1404845001");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  runApp(const GinaApp());
}
