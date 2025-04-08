import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/0_model/payment_model.dart';
import 'package:http/http.dart' as http;
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
  bool _isSimulationMode = false;

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
    required String appointmentDate,
    required String consultationType,
    required String doctorId,
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

      // Get doctor's Xendit account ID
      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      if (!doctorDoc.exists) {
        throw Exception('Doctor document not found');
      }

      final doctorData = doctorDoc.data();
      if (doctorData == null || doctorData['xenditAccountId'] == null) {
        throw Exception('Xendit account ID not found for this doctor');
      }

      final doctorXenditAccountId = doctorData['xenditAccountId'] as String;
      debugPrint('Doctor Xendit Account ID: $doctorXenditAccountId');

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
        doctorXenditAccountId: doctorXenditAccountId,
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
        'appointmentDate': appointmentDate,
        'consultationType': consultationType,
        'status': 'pending',
        'isLinkedToAppointment': false,
        'createdAt': FieldValue.serverTimestamp(),
        'patientId': patient.uid,
        'patientName': patientName,
        'doctorId': doctorId,
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
    required String doctorXenditAccountId,
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
          'doctorXenditAccountId': doctorXenditAccountId,
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
    String tempAppointmentId,
    String finalAppointmentId, {
    String? doctorId,
  }) async {
    debugPrint('=== Starting Payment Linking Process ===');
    debugPrint('Temp Appointment ID: $tempAppointmentId');
    debugPrint('Final Appointment ID: $finalAppointmentId');
    debugPrint('Doctor ID: $doctorId');

    try {
      // Get the payment document from pending_payments collection
      final paymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(tempAppointmentId)
          .get();

      if (!paymentDoc.exists) {
        debugPrint('No payment document found for temp ID: $tempAppointmentId');
        throw Exception('Payment document not found');
      }

      final paymentData = paymentDoc.data();
      if (paymentData == null) {
        debugPrint('Payment document exists but has no data');
        throw Exception('Payment document has no data');
      }

      debugPrint('Payment document found, parsing data...');
      final invoiceId = paymentData['invoiceId'] as String?;
      final status = paymentData['status'] as String?;
      final amount = paymentData['amount'] as double? ?? 0.0;
      final paymentMethod = paymentData['paymentMethod'] as String? ?? 'Xendit';

      if (invoiceId == null) {
        debugPrint('ERROR: Invoice ID is null in payment document');
        throw Exception('Invoice ID is null in payment document');
      }

      if (status != 'paid') {
        debugPrint('ERROR: Payment is not marked as paid (status: $status)');
        throw Exception('Payment is not marked as paid');
      }

      debugPrint('Found paid payment with ID: $invoiceId');
      debugPrint('Payment Amount: ₱$amount');
      debugPrint('Payment Method: $paymentMethod');

      // Get the appointment document
      debugPrint('Fetching appointment document...');
      final appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(finalAppointmentId)
          .get();

      if (!appointmentDoc.exists) {
        debugPrint('ERROR: Appointment document not found');
        throw Exception('Appointment document not found');
      }

      final appointmentData = appointmentDoc.data();
      if (appointmentData == null) {
        debugPrint('ERROR: Appointment document exists but has no data');
        throw Exception('Appointment document has no data');
      }

      debugPrint('Appointment data: $appointmentData');

      // Use the provided doctorId or try to get it from the appointment document
      final appointmentDoctorId = appointmentData['doctorUid'] as String?;
      final effectiveDoctorId = doctorId ?? appointmentDoctorId;

      if (effectiveDoctorId == null) {
        debugPrint('ERROR: Doctor ID is null in appointment document');
        throw Exception('Doctor ID is null in appointment document');
      }

      // Get doctor's Xendit account ID
      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(effectiveDoctorId)
          .get();

      if (!doctorDoc.exists) {
        throw Exception('Doctor document not found');
      }

      final doctorData = doctorDoc.data();
      if (doctorData == null || doctorData['xenditAccountId'] == null) {
        throw Exception('Xendit account ID not found for this doctor');
      }

      final doctorXenditAccountId = doctorData['xenditAccountId'] as String;
      debugPrint('Doctor Xendit Account ID: $doctorXenditAccountId');

      // Create direct transfer to doctor's account
      debugPrint('Creating direct transfer to doctor...');
      final transferResult = await _createDirectTransfer(
        recipientId: doctorXenditAccountId,
        amount: amount,
        description: 'Payment for appointment $finalAppointmentId',
      );

      debugPrint('Transfer Result: $transferResult');

      // Create a payment record in the appointments/payments subcollection
      debugPrint(
          'Creating payment record in appointments/payments subcollection...');
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(finalAppointmentId)
          .collection('payments')
          .doc(invoiceId)
          .set({
        'invoiceId': invoiceId,
        'amount': amount,
        'status': status,
        'paymentMethod': paymentMethod,
        'linkedAt': FieldValue.serverTimestamp(),
        'transferId': transferResult['id'],
        'transferStatus': transferResult['status'],
      });

      // Update the appointment with payment information
      debugPrint('Updating appointment with payment information...');
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(finalAppointmentId)
          .update({
        'paymentStatus': status,
        'paymentMethod': paymentMethod,
        'paymentAmount': amount,
        'paymentUpdatedAt': FieldValue.serverTimestamp(),
        'transferId': transferResult['id'],
        'transferStatus': transferResult['status'],
      });

      // Update the doctor's document with the payment information
      debugPrint('Updating doctor document with payment information...');
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(effectiveDoctorId)
          .collection('payments')
          .doc(invoiceId)
          .set({
        'invoiceId': invoiceId,
        'appointmentId': finalAppointmentId,
        'amount': amount,
        'status': status,
        'paymentMethod': paymentMethod,
        'linkedAt': FieldValue.serverTimestamp(),
        'transferId': transferResult['id'],
        'transferStatus': transferResult['status'],
      });

      // Delete the temporary payment document
      // debugPrint('Deleting temporary payment document...');
      // await FirebaseFirestore.instance
      //     .collection('pending_payments')
      //     .doc(tempAppointmentId)
      //     .delete();

      debugPrint('=== Payment Successfully Linked to Appointment ===');
    } catch (e) {
      debugPrint('Error linking payment to appointment: $e');
      throw Exception('Failed to link payment to appointment: $e');
    }
  }

  Future<Map<String, dynamic>> _createDirectTransfer({
    required String recipientId,
    required double amount,
    required String description,
  }) async {
    try {
      debugPrint('Creating direct transfer to doctor...');
      debugPrint('Recipient ID: $recipientId');
      debugPrint('Amount: $amount');
      debugPrint('Description: $description');

      // Reload environment variables
      await dotenv.load();

      // Get the source account ID from environment variables
      final sourceAccountId = dotenv.env['XENDIT_SOURCE_ACCOUNT_ID'];
      debugPrint('All environment variables: ${dotenv.env}');
      debugPrint(
          'XENDIT_SOURCE_ACCOUNT_ID from env: ${dotenv.env['XENDIT_SOURCE_ACCOUNT_ID']}');
      debugPrint(
          'XENDIT_SOURCE_USER_ID from env: ${dotenv.env['XENDIT_SOURCE_USER_ID']}');

      if (sourceAccountId == null || sourceAccountId.isEmpty) {
        throw Exception(
            'XENDIT_SOURCE_ACCOUNT_ID is not configured in .env file');
      }
      debugPrint('Source Account ID: $sourceAccountId');

      // For simulation mode, use the simulation endpoint
      if (_isSimulationMode) {
        debugPrint('Using simulation mode for direct transfer');
        return _simulateDirectTransfer(
          recipientId: recipientId,
          amount: amount,
          description: description,
        );
      }

      // Make the API request to create a direct transfer
      final response = await _dio.post(
        '$_baseUrl/transfers',
        data: {
          'reference': 'payment-${DateTime.now().millisecondsSinceEpoch}',
          'source_user_id': dotenv.env['XENDIT_SOURCE_USER_ID'],
          'destination_user_id': recipientId,
          'amount': amount,
          'currency': 'PHP',
          'description': description,
        },
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Direct transfer response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create direct transfer: ${response.data}');
      }
    } catch (e) {
      debugPrint('Error creating direct transfer: $e');
      if (e is DioException) {
        debugPrint('DioError details:');
        debugPrint('  Status code: ${e.response?.statusCode}');
        debugPrint('  Response data: ${e.response?.data}');
        debugPrint('  Error message: ${e.message}');
        throw Exception(
            'Failed to create direct transfer: ${e.response?.data ?? e.message}');
      }
      throw Exception('Failed to create direct transfer: $e');
    }
  }

  Future<Map<String, dynamic>> _simulateDirectTransfer({
    required String recipientId,
    required double amount,
    required String description,
  }) async {
    debugPrint('Simulating direct transfer...');

    // Simulate a delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate a unique transfer ID
    final transferId = 'sim-transfer-${DateTime.now().millisecondsSinceEpoch}';

    // Return simulated response
    return {
      'id': transferId,
      'source_account_id': dotenv.env['XENDIT_SOURCE_ACCOUNT_ID'],
      'destination_account_id': recipientId,
      'amount': amount,
      'description': description,
      'status': 'COMPLETED',
      'created_at': DateTime.now().toIso8601String(),
      'simulated': true,
    };
  }

  Future<void> _startTransferStatusPolling({
    required String transferId,
    required String appointmentId,
    required String paymentId,
    int maxAttempts = 30, // 5 minutes with 10-second intervals
    int intervalSeconds = 10,
  }) async {
    int attempts = 0;
    String lastStatus = 'pending';

    debugPrint('=== Starting Transfer Status Polling ===');
    debugPrint('Transfer ID: $transferId');
    debugPrint('Appointment ID: $appointmentId');

    Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
      attempts++;
      debugPrint('Polling attempt $attempts of $maxAttempts');

      try {
        final transferStatus = await _checkTransferStatus(transferId);
        debugPrint('Current transfer status: $transferStatus');

        if (transferStatus != lastStatus) {
          debugPrint(
              'Transfer status changed from $lastStatus to $transferStatus');
          lastStatus = transferStatus;

          // Update transfer status in Firestore
          await _updateTransferStatus(
            appointmentId: appointmentId,
            paymentId: paymentId,
            transferId: transferId,
            status: transferStatus,
          );

          // If transfer is successful or failed, stop polling
          if (transferStatus == 'SUCCESS' || transferStatus == 'FAILED') {
            debugPrint('Transfer completed with status: $transferStatus');
            timer.cancel();
          }
        }

        // If we've reached the maximum number of attempts, stop polling
        if (attempts >= maxAttempts) {
          debugPrint('Reached maximum polling attempts, stopping');
          timer.cancel();
        }
      } catch (e) {
        debugPrint('Error checking transfer status: $e');
        // Don't stop polling on error, just log it and continue
      }
    });
  }

  Future<String> _checkTransferStatus(String transferId) async {
    try {
      debugPrint('Checking transfer status for ID: $transferId');
      final response = await _dio.get(
        '$_baseUrl/transfers/$transferId',
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Transfer status response: ${response.statusCode}');
      debugPrint('Transfer status body: ${response.data}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);
        return data['status'] as String;
      } else {
        throw Exception('Failed to check transfer status: ${response.data}');
      }
    } catch (e) {
      debugPrint('Error checking transfer status: $e');
      throw Exception('Failed to check transfer status: $e');
    }
  }

  Future<void> _updateTransferStatus({
    required String appointmentId,
    required String paymentId,
    required String transferId,
    required String status,
  }) async {
    try {
      debugPrint('=== Updating Transfer Status ===');
      debugPrint('Appointment ID: $appointmentId');
      debugPrint('Payment ID: $paymentId');
      debugPrint('Transfer ID: $transferId');
      debugPrint('New Status: $status');

      // Update appointment document
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'transferStatus': status,
        'transferUpdatedAt': FieldValue.serverTimestamp(),
      });

      // Update payment in appointments/payments subcollection
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .doc(paymentId)
          .update({
        'transferStatus': status,
        'transferUpdatedAt': FieldValue.serverTimestamp(),
      });

      // Update pending payment
      await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(appointmentId)
          .update({
        'transferStatus': status,
        'transferUpdatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('Successfully updated transfer status in all documents');
    } catch (e) {
      debugPrint('Error updating transfer status: $e');
      throw Exception('Failed to update transfer status: $e');
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
            paymentChannel = '$paymentChannel - ${data['payment_method']}';
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

  Future<Map<String, dynamic>> initiateRefund({
    required String appointmentId,
    required String invoiceId,
    required double amount,
    required String reason,
  }) async {
    try {
      debugPrint('=== Initiating Refund ===');
      debugPrint('Appointment ID: $appointmentId');
      debugPrint('Invoice ID: $invoiceId');
      debugPrint('Amount: $amount');
      debugPrint('Reason: $reason');

      // Call Firebase Function to create refund
      const url = 'https://initiaterefund-pbiqoneg6a-as.a.run.app';
      debugPrint('Making request to URL: $url');

      final requestBody = {
        'invoiceId': invoiceId,
        'amount': amount,
        'reason': reason,
        'external_id': 'refund_$appointmentId',
      };
      debugPrint('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Refund initiated successfully: $data');

        // Start a batch write to ensure all updates are atomic
        final batch = FirebaseFirestore.instance.batch();

        // Update appointment document
        final appointmentRef = FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId);
        batch.update(appointmentRef, {
          'refundStatus': 'PENDING',
          'refundId': data['id'],
          'refundInitiatedAt': FieldValue.serverTimestamp(),
          'refundAmount': amount,
        });

        // Update payment in pending_payments collection
        final pendingPaymentQuery = await FirebaseFirestore.instance
            .collection('pending_payments')
            .where('invoiceId', isEqualTo: invoiceId)
            .limit(1)
            .get();

        if (pendingPaymentQuery.docs.isNotEmpty) {
          final pendingPaymentRef = pendingPaymentQuery.docs.first.reference;
          batch.update(pendingPaymentRef, {
            'refundStatus': 'PENDING',
            'refundId': data['id'],
            'refundInitiatedAt': FieldValue.serverTimestamp(),
            'refundAmount': amount,
          });
        }

        // Update payment in appointments/payments subcollection
        final appointmentPaymentQuery = await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .collection('payments')
            .where('invoiceId', isEqualTo: invoiceId)
            .limit(1)
            .get();

        if (appointmentPaymentQuery.docs.isNotEmpty) {
          final appointmentPaymentRef =
              appointmentPaymentQuery.docs.first.reference;
          batch.update(appointmentPaymentRef, {
            'refundStatus': 'PENDING',
            'refundId': data['id'],
            'refundInitiatedAt': FieldValue.serverTimestamp(),
            'refundAmount': amount,
          });
        }

        // Create refund record in appointments/refunds subcollection
        final refundRef = FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .collection('refunds')
            .doc(data['id']);

        batch.set(refundRef, {
          'refundId': data['id'],
          'invoiceId': invoiceId,
          'amount': amount,
          'reason': reason,
          'status': 'PENDING',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Commit the batch
        await batch.commit();
        debugPrint('Successfully updated all Firestore documents');

        return data;
      } else {
        debugPrint('Error response from server:');
        debugPrint('Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        debugPrint('Response headers: ${response.headers}');
        throw Exception('Failed to initiate refund: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in initiateRefund:');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error message: ${e.toString()}');
      if (e is http.ClientException) {
        debugPrint('HTTP Client Exception details:');
        debugPrint('Message: ${e.message}');
        debugPrint('Uri: ${e.uri}');
      }
      throw Exception('Failed to initiate refund: $e');
    }
  }

  Future<void> handleRefundWebhook(Map<String, dynamic> webhookData) async {
    try {
      debugPrint('=== Processing Refund Webhook ===');
      debugPrint('Webhook data: $webhookData');

      final refundId = webhookData['id'];
      final status = webhookData['status'];
      final invoiceId = webhookData['invoice_id'];
      final amount = webhookData['amount'];

      // Find the appointment with this refund
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('refunds')
          .where('refundId', isEqualTo: refundId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('No matching refund record found');
        return;
      }

      final refundDoc = querySnapshot.docs.first;
      final appointmentId = refundDoc.reference.parent.parent!.id;

      // Update refund status in appointments/refunds
      await refundDoc.reference.update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        'webhookData': webhookData,
      });

      // Find the payment in pending_payments collection
      final pendingPaymentQuery = await FirebaseFirestore.instance
          .collection('pending_payments')
          .where('invoiceId', isEqualTo: invoiceId)
          .get();

      if (pendingPaymentQuery.docs.isNotEmpty) {
        final pendingPaymentDoc = pendingPaymentQuery.docs.first;
        await pendingPaymentDoc.reference.update({
          'status': 'refunded',
          'refundStatus': status,
          'refundId': refundId,
          'refundAmount': amount,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Find the payment in appointments/payments subcollection
      final appointmentPaymentQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .where('invoiceId', isEqualTo: invoiceId)
          .get();

      if (appointmentPaymentQuery.docs.isNotEmpty) {
        final appointmentPaymentDoc = appointmentPaymentQuery.docs.first;
        await appointmentPaymentDoc.reference.update({
          'status': 'refunded',
          'refundStatus': status,
          'refundId': refundId,
          'refundAmount': amount,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Update appointment status if refund is successful
      if (status == 'SUCCESS') {
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .update({
          'refundStatus': 'COMPLETED',
          'refundAmount': amount,
          'refundCompletedAt': FieldValue.serverTimestamp(),
        });
      }

      debugPrint('Refund webhook processed successfully');
    } catch (e) {
      debugPrint('Error processing refund webhook: $e');
      throw Exception('Failed to process refund webhook: $e');
    }
  }

  Future<Map<String, dynamic>> getRefundStatus(String refundId) async {
    try {
      debugPrint('=== Checking Refund Status ===');
      debugPrint('Refund ID: $refundId');

      final response = await http.get(
        Uri.parse('https://api.xendit.co/v2/refunds/$refundId'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Refund status: $data');
        return data;
      } else {
        debugPrint('Error checking refund status: ${response.body}');
        throw Exception('Failed to check refund status: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in getRefundStatus: $e');
      throw Exception('Failed to check refund status: $e');
    }
  }

  /// Processes an automatic refund when an appointment is cancelled or declined
  /// This method will be called by the appointment service when an appointment is cancelled or declined
  Future<void> processAutomaticRefund({
    required String appointmentId,
    required String reason,
  }) async {
    try {
      debugPrint('=== Processing Automatic Refund ===');
      debugPrint('Appointment ID: $appointmentId');
      debugPrint('Reason: $reason');

      // Find the payment document
      final paymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(appointmentId)
          .get();

      if (!paymentDoc.exists) {
        debugPrint('No payment found for appointment: $appointmentId');
        return;
      }

      final paymentData = paymentDoc.data()!;
      final invoiceId = paymentData['invoiceId'] as String;
      final amount = paymentData['amount'] as double;
      final status = paymentData['status'] as String? ?? 'pending';

      // Only process refund if payment is already paid
      if (status.toLowerCase() != 'paid') {
        debugPrint('Payment is not in paid status, skipping refund');
        return;
      }

      debugPrint('Found payment with invoice ID: $invoiceId');
      debugPrint('Amount: $amount');
      debugPrint('Current status: $status');

      // Call Firebase Function to process refund
      final response = await http.post(
        Uri.parse(
            'https://asia-southeast1-gina-app-4.cloudfunctions.net/processRefund'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'invoiceId': invoiceId,
          'amount': amount,
          'reason': reason,
          'external_id': 'refund_$appointmentId',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Refund processed successfully: $data');

        // Update payment status in Firestore
        await FirebaseFirestore.instance
            .collection('pending_payments')
            .doc(appointmentId)
            .update({
          'status': 'refunded',
          'refundStatus': 'COMPLETED',
          'refundId': data['id'],
          'refundAmount': amount,
          'refundReason': reason,
          'refundedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        debugPrint('Payment status updated to refunded');
      } else {
        debugPrint(
            'Error processing refund: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to process refund: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error processing automatic refund: $e');
      throw Exception('Failed to process automatic refund: $e');
    }
  }

  Future<Map<String, dynamic>> _processXenditRefund({
    required String invoiceId,
    required double amount,
    required String reason,
  }) async {
    debugPrint('=== Processing Patient Xendit Refund ===');
    debugPrint('Invoice ID: $invoiceId');
    debugPrint('Amount: $amount');
    debugPrint('Reason: $reason');

    try {
      if (_isSimulationMode) {
        debugPrint('Using simulation mode for refund');
        return _simulateRefund(
          invoiceId: invoiceId,
          amount: amount,
          reason: reason,
        );
      }

      // Make the API request to create a refund
      final response = await _dio.post(
        '$_baseUrl/v2/invoices/$invoiceId/refunds',
        data: {
          'amount': amount,
          'reason': reason,
        },
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Refund response: ${response.data}');

      // We don't update the payment document here anymore
      // This is handled in the processRefundForAppointment method

      return {
        'success': true,
        'message': 'Refund processed successfully',
        'data': response.data,
      };
    } catch (e) {
      debugPrint('Error processing Xendit refund: $e');

      // We don't update the payment document here anymore
      // This is handled in the processRefundForAppointment method

      return {
        'success': false,
        'message': 'Error processing refund: $e',
      };
    }
  }

  Future<Map<String, dynamic>> _simulateRefund({
    required String invoiceId,
    required double amount,
    required String reason,
  }) async {
    debugPrint('=== Simulating Refund ===');
    debugPrint('Invoice ID: $invoiceId');
    debugPrint('Amount: $amount');
    debugPrint('Reason: $reason');

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate a random refund ID
    final refundId = 'ref_${DateTime.now().millisecondsSinceEpoch}';

    return {
      'success': true,
      'id': refundId,
      'invoice_id': invoiceId,
      'amount': amount,
      'reason': reason,
      'status': 'COMPLETED',
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> processRefundForAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    debugPrint('=== Processing Refund from Doctor Side ===');
    debugPrint('Appointment ID: $appointmentId');
    debugPrint('Reason: $reason');

    try {
      // First, get the payment details from the appointment's payments subcollection
      final paymentSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .get();

      if (paymentSnapshot.docs.isEmpty) {
        debugPrint('No payment documents found in subcollection');
        return {
          'success': false,
          'message': 'No payment documents found for this appointment',
        };
      }

      final paymentDoc = paymentSnapshot.docs.first;
      final paymentData = paymentDoc.data();
      final paymentDocId = paymentDoc.id;

      debugPrint('Found payment in subcollection:');
      debugPrint('- Invoice ID: ${paymentData['invoiceId']}');
      debugPrint('- Amount: ${paymentData['amount']}');
      debugPrint('- Status: ${paymentData['status']}');
      debugPrint('- Refund Status: ${paymentData['refundStatus']}');
      debugPrint('- Payment Doc ID: $paymentDocId');

      // Check if payment is already refunded
      if (paymentData['refundStatus'] == 'COMPLETED' ||
          paymentData['refundStatus'] == 'SUCCEEDED') {
        debugPrint('Payment already refunded');
        return {
          'success': true,
          'message': 'Payment already refunded',
        };
      }

      // Process the refund with Xendit
      final refundResult = await _processXenditRefund(
        invoiceId: paymentData['invoiceId'],
        amount: paymentData['amount'],
        reason: reason,
      );

      debugPrint('Refund result: $refundResult');

      if (refundResult['success'] == true) {
        // Update the payment document with refund status
        // IMPORTANT: Use the correct document path with the payment document ID
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .collection('payments')
            .doc(
                paymentDocId) // Use the actual payment document ID, not the invoice ID
            .update({
          'refundStatus': 'COMPLETED',
          'refundAmount': paymentData['amount'],
          'refundReason': reason,
          'refundedAt': FieldValue.serverTimestamp(),
        });

        debugPrint('Payment document updated with refund status');

        // Also update the appointment document
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .update({
          'refundStatus': 'COMPLETED',
          'refundAmount': paymentData['amount'],
          'refundReason': reason,
          'refundedAt': FieldValue.serverTimestamp(),
        });

        debugPrint('Appointment document updated with refund status');

        return {
          'success': true,
          'message': 'Refund processed successfully',
          'data': refundResult['data'],
        };
      } else {
        debugPrint('Refund processing failed: ${refundResult['message']}');
        return refundResult;
      }
    } catch (e) {
      debugPrint('Error processing refund: $e');
      return {
        'success': false,
        'message': 'Error processing refund: $e',
      };
    }
  }
}
