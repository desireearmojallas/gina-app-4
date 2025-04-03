import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/0_model/patient_payment_model.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/0_model/payment_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';

class PatientPaymentService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.xendit.co";
  String secretKey = '';
  String publicKey = '';
  UserModel? _currentPatient;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  PatientPaymentService() {
    secretKey = dotenv.env['SECRET_KEY'] ?? '';
    publicKey = dotenv.env['PUBLIC_KEY'] ?? '';
    _initializeCurrentPatient();

    debugPrint('Secret Key loaded: ${secretKey.isNotEmpty ? 'Yes' : 'No'}');
    debugPrint('Public Key loaded: ${publicKey.isNotEmpty ? 'Yes' : 'No'}');

    final authToken = base64Encode(utf8.encode('$secretKey:'));
    _dio.options.headers = {
      "Authorization": "Basic $authToken",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
    ));
  }

  Future<void> _initializeCurrentPatient() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          _currentPatient = UserModel.fromDocumentSnap(userDoc);
          debugPrint('Current patient initialized: ${_currentPatient?.email}');
        } else {
          throw Exception('Patient document not found');
        }
      } else {
        debugPrint('No user is currently logged in');
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      debugPrint('Error initializing current patient: $e');
      throw Exception('Failed to initialize current patient: $e');
    }
  }

  Future<UserModel> _ensureCurrentPatient() async {
    if (_currentPatient == null) {
      await _initializeCurrentPatient();
    }
    if (_currentPatient == null) {
      throw Exception('No patient is currently logged in');
    }
    return _currentPatient!;
  }

  Future<Map<String, dynamic>> createPaymentInvoice({
    required String appointmentId,
    required String doctorName,
    required String patientName,
    required double amount,
    required DateTime appointmentDate,
    required String consultationType,
  }) async {
    try {
      debugPrint('=== Starting createPaymentInvoice ===');
      debugPrint(
          'Checking for existing payment with appointment ID: $appointmentId');

      // Check for existing payment in Firestore
      final existingPaymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(appointmentId)
          .get();

      if (existingPaymentDoc.exists) {
        final paymentData = existingPaymentDoc.data()!;
        final invoiceId = paymentData['invoiceId'] as String;
        final invoiceUrl = paymentData['invoiceUrl'] as String;
        final currentStatus = paymentData['status'] as String? ?? 'pending';

        debugPrint('Found existing payment:');
        debugPrint('Invoice ID: $invoiceId');
        debugPrint('Current status: $currentStatus');

        // Check status with Xendit
        final xenditStatus = await checkXenditPaymentStatus(invoiceId);
        debugPrint('Xendit payment status: $xenditStatus');

        // If status has changed, update it in Firestore
        if (xenditStatus.toLowerCase() != currentStatus.toLowerCase()) {
          debugPrint(
              'Updating payment status from $currentStatus to $xenditStatus');
          await FirebaseFirestore.instance
              .collection('pending_payments')
              .doc(appointmentId)
              .update({
            'status': xenditStatus.toLowerCase(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        // If payment is still valid (not expired or failed), return existing invoice
        if (xenditStatus.toLowerCase() != 'expired' &&
            xenditStatus.toLowerCase() != 'failed') {
          debugPrint('=== Returning existing invoice ===');
          return {
            'invoiceUrl': invoiceUrl,
            'invoiceNumber': invoiceId,
          };
        }
      }

      // Create new payment invoice using Firebase Function
      debugPrint('=== Creating new payment invoice via Firebase Function ===');
      debugPrint('Current patient initialized: ${_currentPatient?.email}');

      final patient = await _ensureCurrentPatient();

      // Call the Firebase Function to create the invoice
      final result = await _createInvoiceViaFirebaseFunction(
        appointmentId: appointmentId,
        amount: amount,
        description: 'Appointment with $doctorName - $consultationType',
        customerEmail: patient.email,
      );

      debugPrint('Firebase Function Response: $result');

      final invoiceUrl = result['invoiceUrl'];
      final invoiceId = result['invoiceId'];

      debugPrint('Storing payment in Firestore...');
      await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(appointmentId)
          .set({
        'invoiceId': invoiceId,
        'invoiceUrl': invoiceUrl,
        'amount': amount,
        'appointmentId': appointmentId,
        'appointmentDate': appointmentDate.toIso8601String(),
        'consultationType': consultationType,
        'status': 'pending',
        'isLinkedToAppointment': false,
        'createdAt': FieldValue.serverTimestamp(),
        'patientId': patient.uid,
        'patientName': patientName,
        'doctorName': doctorName,
        'lastCheckedAt': FieldValue.serverTimestamp(),
        'paymentMethod': 'Xendit',
      });

      debugPrint('=== Successfully created new invoice ===');
      debugPrint('Invoice URL: $invoiceUrl');
      debugPrint('Invoice Number: $invoiceId');

      return {
        'invoiceUrl': invoiceUrl,
        'invoiceNumber': invoiceId,
      };
    } catch (e) {
      debugPrint('Error creating payment invoice: $e');
      throw Exception('Failed to create payment invoice: $e');
    }
  }

  Future<Map<String, dynamic>> _createInvoiceViaFirebaseFunction({
    required String appointmentId,
    required double amount,
    required String description,
    required String customerEmail,
  }) async {
    try {
      debugPrint('Calling Firebase Function createPayment...');

      final response = await http.post(
        Uri.parse(
            'https://asia-southeast1-gina-app-4.cloudfunctions.net/createPayment'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amount,
          'description': description,
          'customerEmail': customerEmail,
          'external_id': appointmentId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Firebase Function response: $data');
      return {
          'invoiceUrl': data['invoiceUrl'],
          'invoiceId': data['invoiceId'] ?? appointmentId,
        };
      } else {
        debugPrint(
            'Firebase Function error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to create invoice: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error calling Firebase Function: $e');
      throw Exception('Failed to create invoice via Firebase Function: $e');
    }
  }

  Future<Map<String, dynamic>> getInvoiceStatus(String invoiceId) async {
    if (secretKey.isEmpty) {
      throw Exception('Xendit API key not configured');
    }

    try {
      final response = await _dio.get('$_baseUrl/v2/invoices/$invoiceId');
      return response.data;
    } catch (e) {
      debugPrint('Error getting invoice status: $e');
      if (e is DioException) {
        debugPrint('Error response: ${e.response?.data}');
        throw Exception(
            e.response?.data?['message'] ?? 'Failed to get invoice status');
      }
      throw Exception('Failed to get invoice status: $e');
    }
  }

  Future<void> updatePaymentStatus(String appointmentId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'paymentStatus': status,
        'paymentUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating payment status: $e');
      throw Exception('Failed to update payment status: $e');
    }
  }

  // Add a method to link payment to appointment
  Future<void> linkPaymentToAppointment(
      String appointmentId, String tempAppointmentId) async {
    try {
      debugPrint('=== Linking Payment to Appointment ===');
      debugPrint('New Appointment ID: $appointmentId');
      debugPrint('Temp Appointment ID: $tempAppointmentId');

      // Find the payment document using the temp appointment ID
      final paymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(tempAppointmentId)
          .get();

      if (!paymentDoc.exists) {
        throw Exception(
            'No payment record found for temp appointment ID: $tempAppointmentId');
      }

      final payment = PaymentModel.fromMap(
        paymentDoc.data()!,
        paymentDoc.id,
      );

      if (payment.status.toLowerCase() != 'paid') {
        throw Exception('Payment is not in paid status');
      }

      debugPrint('Found paid payment with ID: ${payment.invoiceId}');
      debugPrint('Linking to appointment ID: $appointmentId');

      // Create payment subcollection in appointment
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .doc(payment.invoiceId)
          .set(payment
              .copyWith(
                isLinkedToAppointment: true,
                linkedAt: DateTime.now(),
                paymentMethod: payment.paymentMethod,
              )
              .toMap());

      // Update appointment document with payment status
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'paymentStatus': payment.status,
        'paymentUpdatedAt': FieldValue.serverTimestamp(),
        'amount': payment.amount,
        'consultationType': payment.consultationType,
        'paymentMethod': payment.paymentMethod,
      });

      // Update the pending payment to mark it as linked
      await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(tempAppointmentId)
          .update({
        'isLinkedToAppointment': true,
        'linkedAt': FieldValue.serverTimestamp(),
        'linkedAppointmentId': appointmentId,
      });

      debugPrint('Successfully linked payment to appointment');
    } catch (e) {
      debugPrint('Error linking payment to appointment: $e');
      throw Exception('Failed to link payment to appointment: $e');
    }
  }

  Future<String> checkXenditPaymentStatus(String invoiceId) async {
    try {
      debugPrint('=== Checking Xendit Payment Status ===');
      debugPrint('Invoice ID: $invoiceId');

      final response = await http.get(
        Uri.parse('https://api.xendit.co/v2/invoices/$invoiceId'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Xendit API Response Status: ${response.statusCode}');
      debugPrint('Xendit API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] as String;
        debugPrint('Raw Xendit Status: $status');

        // Normalize the status
        String normalizedStatus = status.toLowerCase();
        if (status.toUpperCase() == 'SETTLED' ||
            status.toUpperCase() == 'PAID') {
          normalizedStatus = 'paid';
        }

        debugPrint('Normalized Status: $normalizedStatus');

        // Extract payment channel information
        String paymentChannel = 'Xendit';
        if (data['payment_channel'] != null) {
          paymentChannel = data['payment_channel'] as String;
          if (data['payment_method'] != null) {
            paymentChannel = '${paymentChannel} - ${data['payment_method']}';
          }
        } else if (data['payment_method'] != null) {
          paymentChannel = data['payment_method'] as String;
        }

        debugPrint('Payment Channel: $paymentChannel');

        // Find the payment document by invoice ID
        final querySnapshot = await FirebaseFirestore.instance
            .collection('pending_payments')
            .where('invoiceId', isEqualTo: invoiceId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final paymentDoc = querySnapshot.docs.first;
          final currentStatus =
              paymentDoc.data()['status'] as String? ?? 'pending';

          debugPrint('Current Firestore Status: $currentStatus');

          // Update status and payment channel if different
          if (normalizedStatus != currentStatus.toLowerCase()) {
            debugPrint(
                'Updating Firestore status from $currentStatus to $normalizedStatus');
            await paymentDoc.reference.update({
              'status': normalizedStatus,
              'paymentMethod': paymentChannel,
              'updatedAt': FieldValue.serverTimestamp(),
              'lastCheckedAt': FieldValue.serverTimestamp(),
            });
            debugPrint('Successfully updated payment status in Firestore');
          } else {
            debugPrint('Status unchanged in Firestore');
          }
        } else {
          debugPrint(
              'Warning: Payment document not found for invoice ID: $invoiceId');
        }

        return normalizedStatus;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Unknown error';
        debugPrint('Error response from Xendit: $errorMessage');
        throw Exception('Failed to check payment status: $errorMessage');
      }
    } catch (e) {
      debugPrint('Error checking payment status: $e');
      throw Exception('Failed to check payment status: $e');
    }
  }

  Future<void> _updatePaymentStatus(String invoiceId, String status) async {
    try {
      debugPrint('Attempting to update payment status in Firebase...');
      debugPrint('Invoice ID: $invoiceId');
      debugPrint('New Status: $status');

      // Find the payment document by invoice ID
      final querySnapshot = await FirebaseFirestore.instance
          .collection('pending_payments')
          .where('invoiceId', isEqualTo: invoiceId)
          .limit(1)
          .get();

      debugPrint(
          'Found ${querySnapshot.docs.length} matching payment documents');

      if (querySnapshot.docs.isEmpty) {
        debugPrint('No payment document found for invoice ID: $invoiceId');
        throw Exception('Payment record not found');
      }

      final paymentDoc = querySnapshot.docs.first;
      final paymentData = paymentDoc.data();
      debugPrint('Current payment status: ${paymentData['status']}');
      debugPrint('Payment document ID: ${paymentDoc.id}');
      debugPrint('Temporary appointment ID: ${paymentData['appointmentId']}');

      // Update the payment status in pending_payments
      await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(paymentDoc.id)
          .update({
        'status': status.toLowerCase(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastCheckedAt': FieldValue.serverTimestamp(),
      });

      debugPrint(
          'Successfully updated payment status in pending_payments to: ${status.toLowerCase()}');
    } catch (e) {
      debugPrint('Error updating payment status: $e');
      throw Exception('Failed to update payment status: $e');
    }
  }

  /// Periodically checks the payment status and updates the UI accordingly
  /// This is a fallback mechanism in case the webhook fails
  Future<void> startPaymentStatusPolling({
    required String appointmentId,
    required Function(String) onStatusChanged,
    required Function() onPaymentSuccess,
    required Function() onPaymentFailed,
    int maxAttempts = 30, // 5 minutes with 10-second intervals
    int intervalSeconds = 10,
  }) async {
    int attempts = 0;
    String lastStatus = 'pending';

    debugPrint(
        'Starting payment status polling for appointment: $appointmentId');

    // Get the payment document
    final paymentDoc = await FirebaseFirestore.instance
        .collection('pending_payments')
        .doc(appointmentId)
        .get();

    if (!paymentDoc.exists) {
      debugPrint('Payment document not found for appointment: $appointmentId');
      onPaymentFailed();
      return;
    }

    final paymentData = paymentDoc.data()!;
    final invoiceId = paymentData['invoiceId'] as String;
    lastStatus = paymentData['status'] as String? ?? 'pending';

    debugPrint('Initial payment status: $lastStatus');

    // Set up a timer to check the payment status periodically
    Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
      attempts++;
      debugPrint('Polling attempt $attempts of $maxAttempts');

      try {
        // Check the payment status with Xendit
        final currentStatus = await checkXenditPaymentStatus(invoiceId);
        debugPrint('Current payment status: $currentStatus');

        // If the status has changed, notify the UI
        if (currentStatus != lastStatus) {
          debugPrint(
              'Payment status changed from $lastStatus to $currentStatus');
          lastStatus = currentStatus;
          onStatusChanged(currentStatus);

          // If the payment is successful, stop polling and notify the UI
          if (currentStatus == 'paid') {
            debugPrint('Payment successful, stopping polling');
            timer.cancel();
            onPaymentSuccess();
          }

          // If the payment has failed or expired, stop polling and notify the UI
          if (currentStatus == 'failed' || currentStatus == 'expired') {
            debugPrint('Payment failed or expired, stopping polling');
            timer.cancel();
            onPaymentFailed();
          }
        }

        // If we've reached the maximum number of attempts, stop polling
        if (attempts >= maxAttempts) {
          debugPrint('Reached maximum polling attempts, stopping');
          timer.cancel();

          // If the payment is still pending, notify the UI
          if (lastStatus == 'pending') {
            debugPrint('Payment still pending after maximum attempts');
            onPaymentFailed();
          }
        }
      } catch (e) {
        debugPrint('Error checking payment status: $e');
        // Don't stop polling on error, just log it and continue
      }
    });
  }
}
