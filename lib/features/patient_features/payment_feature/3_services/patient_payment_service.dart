import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.xendit.co/v2/invoices";
  final String _secretKey = dotenv.env['SECRET_KEY'] ?? '';

  PaymentService() {
    _dio.options.headers = {
      "Authorization": "Basic ${base64Encode(utf8.encode('$_secretKey:'))}",
      "Content-Type": "application/json"
    };
  }

  /// Create a new payment invoice
  Future<Map<String, dynamic>> createInvoice({
    required String externalId,
    required int amount,
    required String payerEmail,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: {
          "external_id": externalId,
          "amount": amount,
          "payer_email": payerEmail,
          "description": description,
        },
      );

      return response.data;
    } on DioException catch (e) {
      debugPrint("Payment Error: ${e.response?.data ?? e.message}");
      return {
        'error': true,
        'message': e.response?.data['message'] ?? 'Something went wrong',
      };
    }
  }

  /// Check payment status
  Future<Map<String, dynamic>> getInvoiceStatus(String invoiceId) async {
    try {
      final response = await _dio.get("$_baseUrl/$invoiceId");

      return response.data;
    } on DioException catch (e) {
      debugPrint("Status Error: ${e.response?.data ?? e.message}");
      return {
        'error': true,
        'message': e.response?.data['message'] ?? 'Failed to fetch status',
      };
    }
  }

  /// Update an existing invoice (e.g., amount or description)
  Future<Map<String, dynamic>> updateInvoice({
    required String invoiceId,
    int? amount,
    String? description,
  }) async {
    try {
      final response = await _dio.patch(
        "$_baseUrl/$invoiceId",
        data: {
          if (amount != null) "amount": amount,
          if (description != null) "description": description,
        },
      );

      return response.data;
    } on DioException catch (e) {
      debugPrint("Update Error: ${e.response?.data ?? e.message}");
      return {
        'error': true,
        'message': e.response?.data['message'] ?? 'Failed to update invoice',
      };
    }
  }

  /// Cancel or "delete" an invoice (by expiring it)
  Future<Map<String, dynamic>> cancelInvoice(String invoiceId) async {
    try {
      final response = await _dio.post("$_baseUrl/$invoiceId/expire");

      return response.data;
    } on DioException catch (e) {
      debugPrint("Cancel Error: ${e.response?.data ?? e.message}");
      return {
        'error': true,
        'message': e.response?.data['message'] ?? 'Failed to cancel invoice',
      };
    }
  }
}
