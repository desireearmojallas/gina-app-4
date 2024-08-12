import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._internal();

  SharedPreferencesManager._internal();

  factory SharedPreferencesManager() {
    return _instance;
  }

  final String patientIsLoggedIn = 'patientIsLoggedIn';
  final String doctorIsLoggedIn = 'doctorIsLoggedIn';
  final String adminIsLoggedIn = 'adminIsLoggedIn';

// ----- Storing Data -----

  Future<void> setPatientIsLoggedIn(bool isPatientLoggedIn) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(patientIsLoggedIn, isPatientLoggedIn);
  }

  Future<void> setDoctorIsLoggedIn(bool isDoctorLoggedIn) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(doctorIsLoggedIn, isDoctorLoggedIn);
  }

  Future<void> setAdminIsLoggedIn(bool isAdminLoggedIn) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(adminIsLoggedIn, isAdminLoggedIn);
  }

// ----- Retrieving Data -----

  Future<bool?> getPatientIsLoggedIn() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(patientIsLoggedIn);
  }

  Future<bool?> getDoctorIsLoggedIn() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(doctorIsLoggedIn);
  }

  Future<bool?> getAdminIsLoggedIn() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(adminIsLoggedIn);
  }

  void logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
