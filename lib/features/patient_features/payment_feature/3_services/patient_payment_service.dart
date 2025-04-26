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
    double platformFeePercentage = 0.0,
    double platformFeeAmount = 0.0,
    double totalAmount = 0.0,
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

      // Calculate total amount if not provided
      final effectiveTotalAmount = totalAmount > 0 ? totalAmount : amount;

      // Call the Firebase Function to create the invoice
      final result = await _createInvoiceViaFirebaseFunction(
        appointmentId: appointmentId,
        amount: effectiveTotalAmount, // Use total amount for the actual payment
        description: 'Appointment with $doctorName - $consultationType',
        customerEmail: patient.email,
        doctorXenditAccountId: doctorXenditAccountId,
      );

      debugPrint('Firebase Function Response: $result');

      final invoiceUrl = result['invoiceUrl'];
      final invoiceId = result['invoiceId'];

      debugPrint('Invoice URL: $invoiceUrl');

      debugPrint('Storing payment in Firestore...');
      await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(appointmentId)
          .set({
        'invoiceId': invoiceId,
        'invoiceUrl': invoiceUrl,
        'amount': amount, // Base fee
        'platformFeePercentage': platformFeePercentage,
        'platformFeeAmount': platformFeeAmount,
        'totalAmount': effectiveTotalAmount,
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
        'invoiceId': invoiceId,
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
    String finalAppointmentId,
    double platformFeePercentage,
    double platformFeeAmount,
    double totalAmount, {
    String? doctorId,
  }) async {
    debugPrint('=== Starting Payment Linking Process ===');
    debugPrint('Temp Appointment ID: $tempAppointmentId');
    debugPrint('Final Appointment ID: $finalAppointmentId');
    debugPrint('Doctor ID: $doctorId');
    debugPrint('Platform Fee Percentage: $platformFeePercentage');
    debugPrint('Platform Fee Amount: $platformFeeAmount');
    debugPrint('Total Amount: $totalAmount');

    try {
      // Get the payment document from pending_payments collection
      final paymentDoc = await FirebaseFirestore.instance
          .collection('pending_payments')
          .doc(finalAppointmentId)
          .get();

      if (!paymentDoc.exists) {
        debugPrint('No payment document found for temp ID: $tempAppointmentId');
        debugPrint(
            'No payment document found for final ID: $finalAppointmentId');
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

      final docPlatformFeePercentage =
          paymentData['platformFeePercentage'] as double? ?? 0.0;
      final docPlatformFeeAmount =
          paymentData['platformFeeAmount'] as double? ?? 0.0;
      final docTotalAmount = paymentData['totalAmount'] as double? ?? amount;

      final effectivePlatformFeePercentage = platformFeePercentage > 0
          ? platformFeePercentage
          : docPlatformFeePercentage;
      final effectivePlatformFeeAmount =
          platformFeeAmount > 0 ? platformFeeAmount : docPlatformFeeAmount;
      final effectiveTotalAmount =
          totalAmount > 0 ? totalAmount : docTotalAmount;

      if (invoiceId == null) {
        debugPrint('ERROR: Invoice ID is null in payment document');
        throw Exception('Invoice ID is null in payment document');
      }

      if (status != 'paid') {
        debugPrint('ERROR: Payment is not marked as paid (status: $status)');
        throw Exception('Payment is not marked as paid');
      }

      debugPrint('Found paid payment with ID: $invoiceId');
      debugPrint('Base Payment Amount: ₱$amount');
      debugPrint(
          'Platform Fee: ₱$effectivePlatformFeeAmount (${effectivePlatformFeePercentage * 100}%)');
      debugPrint('Total Amount: ₱$effectiveTotalAmount');
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

      // Calculate doctor's share (base amount minus platform fee)
      final doctorAmount = amount;
      debugPrint('Doctor receives: ₱$doctorAmount');
      debugPrint('Platform keeps: ₱$effectivePlatformFeeAmount');

      // Create direct transfer to doctor's account
      debugPrint('Creating direct transfer to doctor...');
      final transferResult = await _createDirectTransfer(
        recipientId: doctorXenditAccountId,
        amount: doctorAmount,
        description: 'Payment for appointment $finalAppointmentId',
        platformFeePercentage: effectivePlatformFeePercentage,
        platformFeeAmount: effectivePlatformFeeAmount,
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
        'platformFeePercentage': effectivePlatformFeePercentage,
        'platformFeeAmount': effectivePlatformFeeAmount,
        'totalAmount': effectiveTotalAmount,
        'doctorAmount': doctorAmount,
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
        'platformFeePercentage': effectivePlatformFeePercentage,
        'platformFeeAmount': effectivePlatformFeeAmount,
        'totalAmount': effectiveTotalAmount,
        'doctorAmount': doctorAmount,
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
        'amount': doctorAmount,
        'platformFeePercentage': effectivePlatformFeePercentage,
        'platformFeeAmount': effectivePlatformFeeAmount,
        'totalPatientPayment': effectiveTotalAmount,
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
    required platformFeePercentage,
    required platformFeeAmount,
  }) async {
    try {
      final doctorAmount = amount;
      final effectivePlatformFee = platformFeeAmount > 0
          ? platformFeeAmount
          : (amount * platformFeePercentage);
      final totalAmount = amount + effectivePlatformFee;

      debugPrint('Creating direct transfer to doctor...');
      debugPrint('Recipient ID: $recipientId');
      debugPrint('Total Amount: $totalAmount');
      debugPrint('Doctor Amount: $doctorAmount');
      debugPrint('Platform Fee: $effectivePlatformFee');
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
          amount: doctorAmount, // Only transfer doctor's amount
          description: description,
          platformFee: effectivePlatformFee,
        );
      }

      // Make the API request to create a direct transfer
      final response = await _dio.post(
        '$_baseUrl/transfers',
        data: {
          'reference': 'payment-${DateTime.now().millisecondsSinceEpoch}',
          'source_user_id': dotenv.env['XENDIT_SOURCE_USER_ID'],
          'destination_user_id': recipientId,
          'amount': doctorAmount,
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
        // Add platform fee information to the response data
        final responseData = response.data;
        responseData['platformFee'] = effectivePlatformFee;
        responseData['doctorAmount'] = doctorAmount;
        responseData['totalAmount'] = totalAmount;

        return responseData;
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
    required double platformFee,
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
      'platformFee': platformFee,
      'totalAmount': amount + platformFee,
      'doctorAmount': amount,
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
    required String appointmentId,
    required double amount,
    required String reason,
  }) async {
    debugPrint('=== Processing Xendit Refund ===');
    debugPrint('Invoice ID: $invoiceId');
    debugPrint('Amount: $amount');
    debugPrint('Reason: $reason');

    try {
      // First, get the payment document to retrieve the external_id and doctor's Xendit ID
      // Find the temp ID (document ID) in the pending_payments collection
      // We need to query by invoiceId to find the corresponding document
      final pendingPaymentsQuery = await FirebaseFirestore.instance
          .collection('pending_payments')
          .where('invoiceId', isEqualTo: invoiceId)
          .limit(1)
          .get();

      String? externalId;
      String? doctorXenditAccountId;

      if (pendingPaymentsQuery.docs.isNotEmpty) {
        // The document ID is the temp ID we need
        externalId = pendingPaymentsQuery.docs.first.id;
        final paymentData = pendingPaymentsQuery.docs.first.data();
        doctorXenditAccountId = paymentData['doctorXenditAccountId'] as String?;
        debugPrint('Found external ID in pending_payments: $externalId');
        debugPrint('Found doctor Xendit account ID: $doctorXenditAccountId');
      } else {
        // If not found by invoiceId, try to find by appointmentId
        final pendingPaymentDoc = await FirebaseFirestore.instance
            .collection('pending_payments')
            .doc(appointmentId)
            .get();

        if (pendingPaymentDoc.exists) {
          externalId = pendingPaymentDoc.id;
          final paymentData = pendingPaymentDoc.data();
          doctorXenditAccountId =
              paymentData?['doctorXenditAccountId'] as String?;
          debugPrint('Found external ID using appointmentId: $externalId');
          debugPrint('Found doctor Xendit account ID: $doctorXenditAccountId');
        } else {
          debugPrint(
              'Warning: No pending_payments document found for invoice: $invoiceId or appointment: $appointmentId');
          // Use the appointmentId as fallback
          externalId = appointmentId;

          // Try to get doctor's Xendit account ID from the appointment document
          final appointmentDoc = await FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointmentId)
              .get();

          if (appointmentDoc.exists) {
            final appointmentData = appointmentDoc.data();
            doctorXenditAccountId =
                appointmentData?['doctorXenditAccountId'] as String?;
            debugPrint(
                'Found doctor Xendit account ID from appointment: $doctorXenditAccountId');
          }
        }
      }

      debugPrint('Using external ID for refund: $externalId');

      // Map the reason to Xendit's allowed values
      final xenditReason = _mapToXenditReason(reason);
      debugPrint('Mapped reason to Xendit format: $xenditReason');

      // Generate a unique idempotency key
      final idempotencyKey = 'refund_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('Generated idempotency key: $idempotencyKey');

      // First try with invoice_id
      try {
        debugPrint('Attempting refund with invoice_id approach');
        final response = await _dio.post(
          'https://api.xendit.co/refunds',
          data: {
            "invoice_id": invoiceId,
            "amount": amount,
            "reason": xenditReason,
            "idempotency_key": idempotencyKey
          },
          options: Options(
            headers: {
              'Authorization':
                  'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
              'Content-Type': 'application/json',
            },
          ),
        );

        debugPrint('Refund with invoice_id successful: ${response.data}');
        return _handleSuccessfulRefund(
          response: response,
          appointmentId: appointmentId,
          invoiceId: invoiceId,
          externalId: externalId,
          amount: amount,
          reason: reason,
        );
      } on DioException catch (invoiceError) {
        // If invoice_id fails with 400 error, try with external_id
        if (invoiceError.response?.statusCode == 400) {
          debugPrint(
              'Invoice ID approach failed with 400 error, trying external_id approach');
          debugPrint('Error details: ${invoiceError.response?.data}');

          try {
            final response = await _dio.post(
              'https://api.xendit.co/refunds',
              data: {
                "external_id": externalId,
                "amount": amount,
                "reason": xenditReason,
                "idempotency_key": idempotencyKey
              },
              options: Options(
                headers: {
                  'Authorization':
                      'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
                  'Content-Type': 'application/json',
                },
              ),
            );

            debugPrint('Refund with external_id successful: ${response.data}');
            return _handleSuccessfulRefund(
              response: response,
              appointmentId: appointmentId,
              invoiceId: invoiceId,
              externalId: externalId,
              amount: amount,
              reason: reason,
            );
          } catch (externalIdError) {
            debugPrint('External ID approach also failed: $externalIdError');
            return _handleFailedRefund(
              error: externalIdError,
              appointmentId: appointmentId,
              invoiceId: invoiceId,
              amount: amount,
              reason: reason,
            );
          }
        } else {
          // If it's not a 400 error, rethrow to be caught by the outer catch
          debugPrint(
              'Invoice ID approach failed with non-400 error: ${invoiceError.response?.statusCode}');
          return _handleFailedRefund(
            error: invoiceError,
            appointmentId: appointmentId,
            invoiceId: invoiceId,
            amount: amount,
            reason: reason,
          );
        }
      }
    } catch (e) {
      debugPrint('Error processing refund: $e');
      return _handleFailedRefund(
        error: e,
        appointmentId: appointmentId,
        invoiceId: invoiceId,
        amount: amount,
        reason: reason,
      );
    }
  }

  /// Helper method to handle successful refunds
  Future<Map<String, dynamic>> _handleSuccessfulRefund({
    required Response response,
    required String appointmentId,
    required String invoiceId,
    required String externalId,
    required double amount,
    required String reason,
  }) async {
    debugPrint('=== Handling Successful Refund ===');
    debugPrint('Appointment ID: $appointmentId');
    debugPrint('Invoice ID: $invoiceId');
    debugPrint('External ID: $externalId');
    debugPrint('Amount: $amount');
    debugPrint('Reason: $reason');
    debugPrint('Refund ID: ${response.data['id']}');

    try {
      // Start a batch write to ensure all updates are atomic
      final batch = FirebaseFirestore.instance.batch();

      // Update the pending_payments document with refund details
      final pendingPaymentsQuery = await FirebaseFirestore.instance
          .collection('pending_payments')
          .where('invoiceId', isEqualTo: invoiceId)
          .limit(1)
          .get();

      if (pendingPaymentsQuery.docs.isNotEmpty) {
        final pendingPaymentDoc = pendingPaymentsQuery.docs.first;
        debugPrint(
            'Found pending_payments document by invoiceId: ${pendingPaymentDoc.id}');

        batch.update(pendingPaymentDoc.reference, {
          'refundStatus': 'COMPLETED',
          'refundAmount': amount,
          'refundReason': reason,
          'refundId': response.data['id'],
          'refundExternalId': externalId,
          'refundedAt': FieldValue.serverTimestamp(),
          'status': 'refunded',
        });
      } else {
        // Try to update using appointmentId
        final pendingPaymentRef = FirebaseFirestore.instance
            .collection('pending_payments')
            .doc(appointmentId);

        final pendingPaymentDoc = await pendingPaymentRef.get();

        if (pendingPaymentDoc.exists) {
          debugPrint(
              'Found pending_payments document by appointmentId: $appointmentId');

          batch.update(pendingPaymentRef, {
            'refundStatus': 'COMPLETED',
            'refundAmount': amount,
            'refundReason': reason,
            'refundId': response.data['id'],
            'refundExternalId': externalId,
            'refundedAt': FieldValue.serverTimestamp(),
            'status': 'refunded',
          });
        } else {
          debugPrint(
              'Warning: No pending_payments document found for ID: $appointmentId');
        }
      }

      // Also update the payment document in the appointments/payments subcollection
      final paymentQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .where('invoiceId', isEqualTo: invoiceId)
          .limit(1)
          .get();

      if (paymentQuery.docs.isNotEmpty) {
        final paymentDoc = paymentQuery.docs.first;
        debugPrint('Found payment document in subcollection: ${paymentDoc.id}');

        batch.update(paymentDoc.reference, {
          'refundStatus': 'COMPLETED',
          'refundAmount': amount,
          'refundReason': reason,
          'refundId': response.data['id'],
          'refundExternalId': externalId,
          'refundedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Try to find by appointmentId
        final paymentRef = FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .collection('payments')
            .doc(invoiceId);

        final paymentDoc = await paymentRef.get();

        if (paymentDoc.exists) {
          debugPrint(
              'Found payment document in subcollection by direct ID: $invoiceId');

          batch.update(paymentRef, {
            'refundStatus': 'COMPLETED',
            'refundAmount': amount,
            'refundReason': reason,
            'refundId': response.data['id'],
            'refundExternalId': externalId,
            'refundedAt': FieldValue.serverTimestamp(),
          });
        } else {
          debugPrint(
              'Warning: No payment document found in subcollection with ID: $invoiceId');
        }
      }

      // Create a refund record in the appointments/refunds subcollection
      final refundRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('refunds')
          .doc(response.data['id']);

      batch.set(refundRef, {
        'refundId': response.data['id'],
        'invoiceId': invoiceId,
        'amount': amount,
        'reason': reason,
        'status': 'COMPLETED',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update the main appointment document
      final appointmentRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId);

      batch.update(appointmentRef, {
        'refundStatus': 'COMPLETED',
        'refundId': response.data['id'],
        'refundAmount': amount,
        'refundReason': reason,
        'refundedAt': FieldValue.serverTimestamp(),
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancelledBy': 'patient',
      });

      // Then deduct from doctor's Xendit balance
      final appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (appointmentDoc.exists) {
        final doctorId = appointmentDoc.data()?['doctorUid'];
        if (doctorId != null) {
          debugPrint('Found doctor ID: $doctorId, fetching Xendit account ID');

          final doctorDoc = await FirebaseFirestore.instance
              .collection('doctors')
              .doc(doctorId)
              .get();

          if (doctorDoc.exists) {
            final doctorXenditId = doctorDoc.data()?['xenditAccountId'];
            if (doctorXenditId != null) {
              debugPrint(
                  'Found doctor Xendit ID: $doctorXenditId, creating reverse transfer');

              await _createReverseTransfer(
                fromDoctorId: doctorXenditId,
                amount: amount,
                appointmentId: appointmentId,
                invoiceId: invoiceId,
              );
            } else {
              debugPrint('Warning: Doctor has no Xendit account ID');
            }
          } else {
            debugPrint('Warning: Doctor document not found');
          }
        } else {
          debugPrint('Warning: Appointment has no doctor ID');
        }
      } else {
        debugPrint('Warning: Appointment document not found');
      }

      // Commit all updates atomically
      await batch.commit();
      debugPrint('Successfully updated all documents with refund information');

      return {
        'success': true,
        'refundId': response.data['id'],
        'amount': amount,
        'status': 'COMPLETED',
      };
    } catch (updateError) {
      debugPrint(
          'Error updating documents after successful refund: $updateError');
      // Still return success since the refund was processed
      return {
        'success': true,
        'refundId': response.data['id'],
        'amount': amount,
        'status': 'COMPLETED',
        'warning': 'Refund processed but document updates failed: $updateError',
      };
    }
  }

  /// Helper method to handle failed refunds
  Map<String, dynamic> _handleFailedRefund({
    required dynamic error,
    required String appointmentId,
    required String invoiceId,
    required double amount,
    required String reason,
  }) {
    debugPrint('Handling failed refund');

    // Check if it's a DioException to extract more details
    if (error is DioException) {
      debugPrint('DioException details:');
      debugPrint('Status code: ${error.response?.statusCode}');
      debugPrint('Response data: ${error.response?.data}');

      // Try to extract the error message from the response
      String errorMessage = 'Unknown error';
      if (error.response?.data != null && error.response?.data is Map) {
        final errorData = error.response?.data as Map;
        errorMessage = errorData['message'] ?? 'Unknown error';

        if (errorData['errors'] != null && errorData['errors'] is List) {
          final errors = errorData['errors'] as List;
          if (errors.isNotEmpty && errors[0] is Map) {
            final firstError = errors[0] as Map;
            errorMessage += ': ${firstError['message'] ?? ''}';
          }
        }
      }

      debugPrint('Xendit API error response: ${error.response?.data}');

      // Update the payment document with the error
      _updatePaymentDocumentWithError(
        appointmentId: appointmentId,
        invoiceId: invoiceId,
        amount: amount,
        reason: reason,
        errorMessage: errorMessage,
      );

      return {
        'success': false,
        'refundId': null,
        'amount': amount,
        'status': 'FAILED',
        'error': errorMessage,
      };
    } else {
      // For non-DioException errors
      debugPrint('Non-DioException error: $error');

      // Update the payment document with the error
      _updatePaymentDocumentWithError(
        appointmentId: appointmentId,
        invoiceId: invoiceId,
        amount: amount,
        reason: reason,
        errorMessage: error.toString(),
      );

      return {
        'success': false,
        'refundId': null,
        'amount': amount,
        'status': 'FAILED',
        'error': error.toString(),
      };
    }
  }

  // Helper method to update payment document with error
  Future<void> _updatePaymentDocumentWithError({
    required String appointmentId,
    required String invoiceId,
    required double amount,
    required String reason,
    required String errorMessage,
  }) async {
    try {
      final paymentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .doc(invoiceId)
          .get();

      if (paymentDoc.exists) {
        debugPrint(
            'Updating payment document in subcollection with ID: $invoiceId');
        await paymentDoc.reference.update({
          'refund_status': 'failed',
          'refund_amount': amount,
          'refund_reason': reason,
          'refund_error': errorMessage,
          'refund_created_at': DateTime.now().toIso8601String(),
        });
        debugPrint(
            'Successfully updated payment document in subcollection with error');
      } else {
        debugPrint(
            'Warning: No payment document found in subcollection with ID: $invoiceId');
      }
    } catch (updateError) {
      debugPrint('Error updating payment document with error: $updateError');
    }
  }

  /// Map common refund reasons to Xendit's allowed values
  String _mapToXenditReason(String reason) {
    final lowercaseReason = reason.toLowerCase();

    if (lowercaseReason.contains('cancel')) {
      return 'CANCELLATION';
    } else if (lowercaseReason.contains('duplicate') ||
        lowercaseReason.contains('double')) {
      return 'DUPLICATE';
    } else if (lowercaseReason.contains('fraud') ||
        lowercaseReason.contains('scam')) {
      return 'FRAUDULENT';
    } else if (lowercaseReason.contains('request') ||
        lowercaseReason.contains('customer')) {
      return 'REQUESTED_BY_CUSTOMER';
    } else {
      // Default to REQUESTED_BY_CUSTOMER if no match
      return 'REQUESTED_BY_CUSTOMER';
    }
  }

  Future<Map<String, dynamic>> processRefundForAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    debugPrint('=== Processing Refund from Patient Side ===');
    debugPrint('Appointment ID: $appointmentId');
    debugPrint('Reason: $reason');

    try {
      // Get appointment details first to get doctor's Xendit account ID
      final appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!appointmentDoc.exists) {
        debugPrint('Appointment document not found');
        return {
          'success': false,
          'message': 'Appointment not found',
        };
      }

      final appointmentData = appointmentDoc.data();
      final doctorXenditAccountId =
          appointmentData?['doctorXenditAccountId'] as String?;
      debugPrint('Doctor Xendit Account ID: $doctorXenditAccountId');

      // Get payment details from the appointment's payments subcollection
      final paymentQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .get();

      String? invoiceId;
      double amount = 0.0;
      String paymentStatus = '';
      String? refundStatus;
      String? paymentDocId;

      if (paymentQuery.docs.isNotEmpty) {
        final paymentData = paymentQuery.docs.first.data();
        paymentDocId = paymentQuery.docs.first.id;
        invoiceId = paymentData['invoiceId'] as String?;
        amount = paymentData['amount'] as double? ?? 0.0;
        paymentStatus = paymentData['status'] as String? ?? '';
        refundStatus = paymentData['refundStatus'] as String?;

        debugPrint('Found payment in subcollection:');
        debugPrint('- Invoice ID: $invoiceId');
        debugPrint('- Amount: $amount');
        debugPrint('- Status: $paymentStatus');
        debugPrint('- Refund Status: $refundStatus');
        debugPrint('- Payment Doc ID: $paymentDocId');
      } else {
        debugPrint('No payment document found in subcollection');
      }

      // If no payment details in subcollection, check pending_payments collection
      if (invoiceId == null) {
        debugPrint('Checking pending_payments collection...');
        final pendingPaymentQuery = await FirebaseFirestore.instance
            .collection('pending_payments')
            .doc(appointmentId)
            .get();

        if (pendingPaymentQuery.exists) {
          final pendingPaymentData = pendingPaymentQuery.data();
          if (pendingPaymentData != null) {
            invoiceId = pendingPaymentData['invoiceId'] as String?;
            amount = pendingPaymentData['amount'] as double? ?? 0.0;
            paymentStatus = pendingPaymentData['status'] as String? ?? '';
            refundStatus = pendingPaymentData['refundStatus'] as String?;

            debugPrint('Found payment details in pending_payments:');
            debugPrint('- Invoice ID: $invoiceId');
            debugPrint('- Amount: $amount');
            debugPrint('- Payment Status: $paymentStatus');
            debugPrint('- Refund Status: $refundStatus');
          }
        } else {
          debugPrint('No payment document found in pending_payments');
        }
      }

      // Only process refund if payment was made and not already refunded
      if (paymentStatus.toLowerCase() == 'paid' &&
          invoiceId != null &&
          amount > 0 &&
          (refundStatus == null || refundStatus.toLowerCase() != 'completed')) {
        debugPrint('=== Processing Patient Xendit Refund ===');
        debugPrint('Invoice ID: $invoiceId');
        debugPrint('Amount: $amount');
        debugPrint('Reason: $reason');

        try {
          // Process the refund
          final refundResult = await _processXenditRefund(
            invoiceId: invoiceId,
            appointmentId: appointmentId,
            amount: amount,
            reason: reason,
          );

          if (!refundResult['success']) {
            debugPrint('Refund processing failed: ${refundResult['message']}');
            return refundResult;
          }

          final refundId = refundResult['refundId'];

          // Start a batch write to ensure all updates are atomic
          final batch = FirebaseFirestore.instance.batch();

          // Update the payment document in subcollection if it exists
          if (paymentDocId != null) {
            debugPrint(
                'Updating payment document in subcollection with ID: $paymentDocId');
            final paymentRef = FirebaseFirestore.instance
                .collection('appointments')
                .doc(appointmentId)
                .collection('payments')
                .doc(paymentDocId);

            batch.update(paymentRef, {
              'refundStatus': 'COMPLETED',
              'refundAmount': amount,
              'refundReason': reason,
              'refundId': refundId,
              'refundedAt': FieldValue.serverTimestamp(),
            });
          }

          // Update pending_payments document if it exists
          final pendingPaymentRef = FirebaseFirestore.instance
              .collection('pending_payments')
              .doc(appointmentId);

          final pendingPaymentDoc = await pendingPaymentRef.get();
          if (pendingPaymentDoc.exists) {
            debugPrint('Updating pending_payments document');
            batch.update(pendingPaymentRef, {
              'refundStatus': 'COMPLETED',
              'refundAmount': amount,
              'refundReason': reason,
              'refundId': refundId,
              'refundedAt': FieldValue.serverTimestamp(),
            });
          }

          // Create refund record in appointments/refunds subcollection
          final refundRef = FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointmentId)
              .collection('refunds')
              .doc(refundId);

          batch.set(refundRef, {
            'refundId': refundId,
            'invoiceId': invoiceId,
            'amount': amount,
            'reason': reason,
            'status': 'COMPLETED',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // If we have the doctor's Xendit account ID, create a reverse transfer
          if (doctorXenditAccountId != null) {
            debugPrint(
                'Creating reverse transfer to doctor: $doctorXenditAccountId');
            try {
              // Calculate the doctor's share (typically 80% of the refund amount)
              final doctorShare = amount * 0.8;

              // Create a reverse transfer to deduct from doctor's balance
              final transferResponse = await _dio.post(
                'https://api.xendit.co/transfers',
                data: {
                  "reference": "reverse_$refundId",
                  "amount": doctorShare,
                  "currency": "PHP",
                  "destination": doctorXenditAccountId,
                  "description": "Reverse transfer for refund $refundId",
                },
                options: Options(
                  headers: {
                    'Authorization':
                        'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
                    'Content-Type': 'application/json',
                  },
                ),
              );

              debugPrint('Reverse transfer created: ${transferResponse.data}');

              // Add the reverse transfer details to the refund record
              batch.update(refundRef, {
                'reverseTransferId': transferResponse.data['id'],
                'reverseTransferAmount': doctorShare,
                'reverseTransferStatus': 'COMPLETED',
                'reverseTransferedAt': FieldValue.serverTimestamp(),
              });
            } catch (transferError) {
              debugPrint('Error creating reverse transfer: $transferError');
              // Continue with the refund process even if reverse transfer fails
              // We'll log the error but still complete the refund
              batch.update(refundRef, {
                'reverseTransferStatus': 'FAILED',
                'reverseTransferError': transferError.toString(),
                'reverseTransferFailedAt': FieldValue.serverTimestamp(),
              });
            }
          } else {
            debugPrint(
                'No doctor Xendit account ID found, skipping reverse transfer');
          }

          // Update the main appointment document
          final appointmentRef = FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointmentId);

          batch.update(appointmentRef, {
            'refundStatus': 'COMPLETED',
            'refundId': refundId,
            'refundAmount': amount,
            'refundReason': reason,
            'refundedAt': FieldValue.serverTimestamp(),
            'status': 'cancelled',
            'cancelledAt': FieldValue.serverTimestamp(),
            'cancelledBy': 'patient',
          });

          // Commit all updates atomically
          await batch.commit();
          debugPrint(
              'Successfully updated all documents with refund information');

          return {
            'success': true,
            'refundId': refundId,
            'amount': amount,
            'status': 'COMPLETED',
          };
        } catch (e) {
          debugPrint('Error processing refund: $e');
          return {
            'success': false,
            'message': 'Error processing refund: $e',
          };
        }
      } else {
        debugPrint('No refund needed or already refunded:');
        debugPrint('- Payment Status: $paymentStatus');
        debugPrint('- Invoice ID: $invoiceId');
        debugPrint('- Amount: $amount');
        debugPrint('- Refund Status: $refundStatus');

        return {
          'success': true,
          'message': 'No refund needed or already refunded',
        };
      }
    } catch (e) {
      debugPrint('Error processing refund: $e');
      return {
        'success': false,
        'message': 'Error processing refund: $e',
      };
    }
  }

  Future<Map<String, dynamic>> processRefundForCancellation({
    required String appointmentId,
    required String reason,
  }) async {
    debugPrint('=== Processing Refund from Patient Cancellation ===');
    debugPrint('Appointment ID: $appointmentId');
    debugPrint('Reason: $reason');

    try {
      // Get payment details from the appointment's payments subcollection
      final paymentQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .collection('payments')
          .get();

      String? invoiceId;
      double amount = 0.0;
      String paymentStatus = '';
      String? refundStatus;
      String? paymentDocId;

      if (paymentQuery.docs.isNotEmpty) {
        final paymentData = paymentQuery.docs.first.data();
        paymentDocId = paymentQuery.docs.first.id;
        invoiceId = paymentData['invoiceId'] as String?;
        amount = paymentData['amount'] as double? ?? 0.0;
        paymentStatus = paymentData['status'] as String? ?? '';
        refundStatus = paymentData['refundStatus'] as String?;

        debugPrint('Found payment in subcollection:');
        debugPrint('- Invoice ID: $invoiceId');
        debugPrint('- Amount: $amount');
        debugPrint('- Status: $paymentStatus');
        debugPrint('- Refund Status: $refundStatus');
        debugPrint('- Payment Doc ID: $paymentDocId');
      } else {
        debugPrint('No payment document found in subcollection');
      }

      // If no payment details in subcollection, check pending_payments collection
      if (invoiceId == null) {
        debugPrint('Checking pending_payments collection...');
        final pendingPaymentQuery = await FirebaseFirestore.instance
            .collection('pending_payments')
            .doc(appointmentId)
            .get();

        if (pendingPaymentQuery.exists) {
          final pendingPaymentData = pendingPaymentQuery.data();
          if (pendingPaymentData != null) {
            invoiceId = pendingPaymentData['invoiceId'] as String?;
            amount = pendingPaymentData['amount'] as double? ?? 0.0;
            paymentStatus = pendingPaymentData['status'] as String? ?? '';
            refundStatus = pendingPaymentData['refundStatus'] as String?;

            debugPrint('Found payment details in pending_payments:');
            debugPrint('- Invoice ID: $invoiceId');
            debugPrint('- Amount: $amount');
            debugPrint('- Payment Status: $paymentStatus');
            debugPrint('- Refund Status: $refundStatus');
          }
        } else {
          debugPrint('No payment document found in pending_payments');
        }
      }

      // Only process refund if payment was made and not already refunded
      if (paymentStatus.toLowerCase() == 'paid' &&
          invoiceId != null &&
          amount > 0 &&
          (refundStatus == null || refundStatus.toLowerCase() != 'completed')) {
        debugPrint('=== Processing Patient Xendit Refund ===');
        debugPrint('Invoice ID: $invoiceId');
        debugPrint('Amount: $amount');
        debugPrint('Reason: $reason');

        try {
          // Process the refund
          final refundResult = await _processXenditRefund(
            invoiceId: invoiceId,
            appointmentId: appointmentId,
            amount: amount,
            reason: reason,
          );

          if (!refundResult['success']) {
            debugPrint('Refund processing failed: ${refundResult['message']}');
            return refundResult;
          }

          final refundData = refundResult['data'];
          final refundId = refundData['id'];

          // Start a batch write to ensure all updates are atomic
          final batch = FirebaseFirestore.instance.batch();

          // Update the payment document in subcollection if it exists
          if (paymentDocId != null) {
            debugPrint(
                'Updating payment document in subcollection with ID: $paymentDocId');
            final paymentRef = FirebaseFirestore.instance
                .collection('appointments')
                .doc(appointmentId)
                .collection('payments')
                .doc(paymentDocId);

            batch.update(paymentRef, {
              'refundStatus': 'COMPLETED',
              'refundAmount': amount,
              'refundReason': reason,
              'refundId': refundId,
              'refundedAt': FieldValue.serverTimestamp(),
            });
          }

          // Update pending_payments document if it exists
          final pendingPaymentRef = FirebaseFirestore.instance
              .collection('pending_payments')
              .doc(appointmentId);

          final pendingPaymentDoc = await pendingPaymentRef.get();
          if (pendingPaymentDoc.exists) {
            debugPrint('Updating pending_payments document');
            batch.update(pendingPaymentRef, {
              'refundStatus': 'COMPLETED',
              'refundAmount': amount,
              'refundReason': reason,
              'refundId': refundId,
              'refundedAt': FieldValue.serverTimestamp(),
            });
          }

          // Create refund record in appointments/refunds subcollection
          final refundRef = FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointmentId)
              .collection('refunds')
              .doc(refundId);

          batch.set(refundRef, {
            'refundId': refundId,
            'invoiceId': invoiceId,
            'amount': amount,
            'reason': reason,
            'status': 'COMPLETED',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // If we have the doctor's Xendit account ID, create a reverse transfer
          // if (doctorXenditAccountId != null) {
          //   debugPrint(
          //       'Creating reverse transfer to doctor: $doctorXenditAccountId');
          //   try {
          //     // Calculate the doctor's share (typically 80% of the refund amount)
          //     final doctorShare = amount * 0.8;

          //     // Create a reverse transfer to deduct from doctor's balance
          //     final transferResponse = await _dio.post(
          //       'https://api.xendit.co/transfers',
          //       data: {
          //         "reference": "reverse_${refundId}",
          //         "amount": doctorShare,
          //         "currency": "PHP",
          //         "destination": doctorXenditAccountId,
          //         "description": "Reverse transfer for refund $refundId",
          //       },
          //       options: Options(
          //         headers: {
          //           'Authorization':
          //               'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
          //           'Content-Type': 'application/json',
          //         },
          //       ),
          //     );

          //     debugPrint('Reverse transfer created: ${transferResponse.data}');

          //     // Add the reverse transfer details to the refund record
          //     batch.update(refundRef, {
          //       'reverseTransferId': transferResponse.data['id'],
          //       'reverseTransferAmount': doctorShare,
          //       'reverseTransferStatus': 'COMPLETED',
          //       'reverseTransferedAt': FieldValue.serverTimestamp(),
          //     });
          //   } catch (transferError) {
          //     debugPrint('Error creating reverse transfer: $transferError');
          //     // Continue with the refund process even if reverse transfer fails
          //     // We'll log the error but still complete the refund
          //     batch.update(refundRef, {
          //       'reverseTransferStatus': 'FAILED',
          //       'reverseTransferError': transferError.toString(),
          //       'reverseTransferFailedAt': FieldValue.serverTimestamp(),
          //     });
          //   }
          // } else {
          //   debugPrint(
          //       'No doctor Xendit account ID found, skipping reverse transfer');
          // }

          // Update the main appointment document
          final appointmentRef = FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointmentId);

          batch.update(appointmentRef, {
            'refundStatus': 'COMPLETED',
            'refundId': refundId,
            'refundAmount': amount,
            'refundReason': reason,
            'refundedAt': FieldValue.serverTimestamp(),
            'status': 'cancelled',
            'cancelledAt': FieldValue.serverTimestamp(),
            'cancelledBy': 'patient',
          });

          // Commit all updates atomically
          await batch.commit();
          debugPrint(
              'Successfully updated all documents with refund information');

          return {
            'success': true,
            'refundId': refundId,
            'amount': amount,
            'status': 'COMPLETED',
          };
        } catch (e) {
          debugPrint('Error processing refund: $e');
          return {
            'success': false,
            'message': 'Error processing refund: $e',
          };
        }
      } else {
        debugPrint('No refund needed or already refunded:');
        debugPrint('- Payment Status: $paymentStatus');
        debugPrint('- Invoice ID: $invoiceId');
        debugPrint('- Amount: $amount');
        debugPrint('- Refund Status: $refundStatus');

        return {
          'success': true,
          'message': 'No refund needed or already refunded',
        };
      }
    } catch (e) {
      debugPrint('Error processing refund: $e');
      return {
        'success': false,
        'message': 'Error processing refund: $e',
      };
    }
  }

  // Helper method to create a reverse transfer from doctor to platform
  Future<void> _createReverseTransfer({
    required String fromDoctorId,
    required double amount,
    required String appointmentId,
    required String invoiceId,
  }) async {
    try {
      debugPrint('Creating reverse transfer from doctor');
      debugPrint('From Doctor ID: $fromDoctorId');
      debugPrint('Amount: $amount');
      debugPrint('Appointment ID: $appointmentId');
      debugPrint('Invoice ID: $invoiceId');

      final response = await _dio.post(
        'https://api.xendit.co/transfers',
        data: {
          "reference": "refund-$appointmentId-$invoiceId",
          "source_user_id": fromDoctorId,
          "destination_user_id": dotenv.env['XENDIT_SOURCE_USER_ID'],
          "amount": amount,
          "currency": "PHP",
          "description": "Refund reversal for appointment $appointmentId"
        },
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Reverse transfer successful: ${response.data}');

      // Update doctor's balance in Firestore
      await FirebaseFirestore.instance
          .collection('doctors')
          .where('xenditAccountId', isEqualTo: fromDoctorId)
          .get()
          .then((query) {
        if (query.docs.isNotEmpty) {
          final doctorDoc = query.docs.first;
          final currentBalance = doctorDoc.data()['balance'] ?? 0.0;
          return doctorDoc.reference.update({
            'balance': currentBalance - amount,
            'last_balance_update': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      debugPrint('Error creating reverse transfer: $e');
      // You may want to implement retry logic or manual reconciliation
      throw Exception('Failed to deduct from doctor balance: $e');
    }
  }
}
