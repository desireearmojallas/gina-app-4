import 'package:flutter/material.dart';

Widget passwordMatchValidator(
  String password,
  String confirmPassword,
) {
  if (password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      password != confirmPassword) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: const Text(
        'Passwords do not match',
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }
  return const SizedBox();
}

// Email validation method

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  }
  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
      .hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}
