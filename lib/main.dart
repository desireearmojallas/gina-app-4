import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/firebase_options.dart';
import 'package:gina_app_4/gina_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  runApp(const GinaApp());
}
