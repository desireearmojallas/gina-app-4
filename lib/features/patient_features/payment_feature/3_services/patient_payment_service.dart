import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/0_model/patient_payment_model.dart';
import 'package:http/http.dart' as http;

class PatientPaymentService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.xendit.co";
  String secretKey = '';
  String publicKey = '';
  UserModel? _currentPatient;

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
    required int modeOfAppointment,
    required double amount,
    required DateTime appointmentDate,
  }) async {
    try {
      final currentPatient = await _ensureCurrentPatient();
      final externalId =
          'appointment_${appointmentId}_${DateTime.now().millisecondsSinceEpoch}';

      final invoiceData = {
        'external_id': externalId,
        'amount': amount,
        'description': 'Appointment with $doctorName',
        'invoice_duration': 86400, // 24 hours in seconds
        'currency': 'PHP',
        'customer': {
          'given_names': patientName,
          'email': currentPatient.email,
          'mobile_number': 09123456789, // dummy data for number
        },
        'customer_notification_preference': {
          'invoice_created': ['whatsapp', 'sms', 'email'],
          'invoice_reminder': ['whatsapp', 'sms', 'email'],
          'invoice_paid': ['whatsapp', 'sms', 'email'],
          'invoice_expired': ['whatsapp', 'sms', 'email'],
        },
        'success_redirect_url': 'https://gina.com/success',
        'failure_redirect_url': 'https://gina.com/failure',
        'payment_methods': ['CREDIT_CARD', 'BANK_TRANSFER', 'EWALLET'],
        'items': [
          {
            'name': modeOfAppointment == 0
                ? 'Online Consultation'
                : 'Face-to-Face Consultation',
            'price': amount,
            'quantity': 1,
          }
        ],
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/v2/invoices'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(invoiceData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'invoice_url': data['invoice_url'],
          'invoice_number': data['id'],
        };
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create invoice');
      }
    } catch (e) {
      debugPrint('Error creating invoice: $e');
      rethrow;
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
}
