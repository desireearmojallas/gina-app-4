import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class XenditPaymentService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.xendit.co";
  String secretKey = '';
  String publicKey = '';
  String? _cachedAccountId;
  String? _currentDoctorId;
  final bool _isSimulationMode = true; // Default to simulation mode

  // Test bank account details for Philippine banks
  final Map<String, Map<String, dynamic>> _testBankAccounts = {
    'BPI': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
      'minAmount': 100, // PHP
      'maxAmount': 100000, // PHP
    },
    'BDO': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
      'minAmount': 100,
      'maxAmount': 100000,
    },
    'METROBANK': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
      'minAmount': 100,
      'maxAmount': 100000,
    },
    'UNIONBANK': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
      'minAmount': 100,
      'maxAmount': 100000,
    },
    'RCBC': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
      'minAmount': 100,
      'maxAmount': 100000,
    },
  };

  // Currency conversion rate (IDR to PHP)
  static const double _idrToPhpRate = 0.004; // 1 IDR = 0.004 PHP

  // Convert PHP to IDR for testing
  int _convertPhpToIdr(double phpAmount) {
    const conversionRate = 250; // 1 PHP ≈ 250 IDR
    return (phpAmount * conversionRate).round();
  }

  // Convert IDR to PHP
  double _convertIdrToPhp(int idrAmount) {
    return idrAmount * _idrToPhpRate;
  }

  XenditPaymentService() {
    secretKey = dotenv.env['SECRET_KEY'] ?? '';
    publicKey = dotenv.env['PUBLIC_KEY'] ?? '';
    _initializeCurrentDoctor();

    debugPrint('Secret Key loaded: ${secretKey.isNotEmpty ? 'Yes' : 'No'}');
    debugPrint('Public Key loaded: ${publicKey.isNotEmpty ? 'Yes' : 'No'}');
    debugPrint(
        'Secret Key first 10 chars: ${secretKey.isNotEmpty ? '${secretKey.substring(0, 10)}...' : 'Not Loaded'}');

    final authToken = base64Encode(utf8.encode('$secretKey:'));
    debugPrint('Auth Token: $authToken');

    _dio.options.headers = {
      "Authorization": "Basic $authToken",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    debugPrint('Headers set: ${_dio.options.headers}');
    debugPrint('Base URL: $_baseUrl');

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
    ));
  }

  Future<void> _initializeCurrentDoctor() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _currentDoctorId = user.uid;
        debugPrint('Current doctor ID initialized: $_currentDoctorId');
      } else {
        debugPrint('No user is currently logged in');
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      debugPrint('Error initializing current doctor: $e');
      throw Exception('Failed to initialize current doctor: $e');
    }
  }

  Future<String> _ensureCurrentDoctor() async {
    if (_currentDoctorId == null) {
      await _initializeCurrentDoctor();
    }
    if (_currentDoctorId == null) {
      throw Exception('No doctor is currently logged in');
    }
    return _currentDoctorId!;
  }

  Future<String> _getAccountId() async {
    if (_cachedAccountId != null) {
      return _cachedAccountId!;
    }

    final doctorId = await _ensureCurrentDoctor();
    try {
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

      _cachedAccountId = doctorData['xenditAccountId'] as String;
      return _cachedAccountId!;
    } catch (e) {
      debugPrint('Error fetching account ID: $e');
      throw Exception('Failed to fetch account ID: $e');
    }
  }

  Future<bool> isAccountActivated() async {
    if (secretKey.isEmpty) {
      throw Exception('Xendit API key not configured');
    }

    try {
      final doctorId = await _ensureCurrentDoctor();
      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      if (!doctorDoc.exists) {
        return false;
      }

      final doctorData = doctorDoc.data();
      if (doctorData == null || doctorData['xenditAccountId'] == null) {
        return false;
      }

      final response = await _dio.get('$_baseUrl/v2/accounts');

      if (response.statusCode == 200) {
        final List<dynamic> accounts = response.data['data'] ?? [];
        return accounts
            .any((account) => account['id'] == doctorData['xenditAccountId']);
      }

      return false;
    } catch (e) {
      debugPrint('Error checking account status: ${e.toString()}');
      return false;
    }
  }

  Future<Map<String, dynamic>> activateTestAccount({
    required String email,
    required String phoneNumber,
    required String firstName,
    required String lastName,
  }) async {
    if (secretKey.isEmpty) {
      throw Exception('Xendit API key not configured');
    }

    try {
      final doctorId = await _ensureCurrentDoctor();
      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      if (doctorDoc.exists) {
        final doctorData = doctorDoc.data();
        if (doctorData != null && doctorData['xenditAccountId'] != null) {
          throw Exception('An account already exists for this doctor');
        }
      }

      final Map<String, dynamic> activationData = {
        'type': 'OWNED',
        'email': email.trim().toLowerCase(),
        'for_user_verification': false,
        'profile': {
          'email': email.trim().toLowerCase(),
          'mobile_number': phoneNumber,
          'first_name': firstName,
          'last_name': lastName,
        },
        'public_profile': {
          'business_name': '$firstName $lastName Medical Practice',
          'business_category': 'HEALTHCARE',
          'description': 'Medical Professional Services',
        },
        'business_profile': {
          'business_name': '$firstName $lastName Medical Practice',
          'business_type': 'INDIVIDUAL',
          'business_line': 'HEALTHCARE',
          'address': {
            'country': 'PH',
            'city': 'Manila',
            'province': 'Metro Manila',
            'postal_code': '1000',
            'street_line1': 'Test Address',
          },
        },
        'capabilities': [
          'DISBURSEMENT',
          'PAYMENTS',
        ],
      };

      debugPrint('Activating test account with data: $activationData');
      final response = await _dio.post(
        '$_baseUrl/v2/accounts',
        data: activationData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to activate account: ${response.data}');
      }

      final xenditAccountId = response.data['id'];
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .update({
        'xenditAccountId': xenditAccountId,
        'xenditAccountActivated': true,
        'xenditAccountCreated': FieldValue.serverTimestamp(),
      });

      debugPrint('Account activation response: ${response.data}');
      return response.data;
    } catch (e) {
      debugPrint('Error activating test account: $e');
      if (e is DioException) {
        debugPrint('Error response: ${e.response?.data}');
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic>) {
          final errorMessage = errorData['message'] as String?;
          final errors = errorData['errors'] as List<dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            final fieldErrors = errors.map((error) {
              final field = (error['field'] as List<dynamic>).join('.');
              final messages = (error['messages'] as List<dynamic>).join(', ');
              return '$field: $messages';
            }).join('\n');
            throw Exception('Validation errors:\n$fieldErrors');
          }
          throw Exception(errorMessage ?? 'Failed to activate account');
        }
        throw Exception(
            'Failed to activate account: ${e.response?.data ?? e.message}');
      }
      throw Exception('Failed to activate account: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getAccountDetails() async {
    if (secretKey.isEmpty) {
      throw Exception('Xendit API key not configured');
    }

    try {
      debugPrint('Fetching account details');
      final response = await _dio.get('$_baseUrl/v2/accounts');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        if (data.isEmpty) {
          throw Exception('No account found');
        }
        final accountDetails = data.first as Map<String, dynamic>;
        debugPrint('Account details: $accountDetails');
        return accountDetails;
      } else {
        debugPrint('Error response: ${response.statusCode} - ${response.data}');
        throw Exception('Failed to fetch account details');
      }
    } catch (e) {
      debugPrint('Error fetching account details: ${e.toString()}');
      throw Exception('Failed to fetch account details: ${e.toString()}');
    }
  }

  Future<double> getTotalBalance() async {
    if (secretKey.isEmpty) {
      debugPrint('Error: Secret key is empty');
      throw Exception('Xendit API key not configured');
    }

    try {
      debugPrint('Starting balance fetch process...');
      final accountId = await _getAccountId();
      debugPrint('Using account ID: $accountId');

      debugPrint('Making request to $_baseUrl/balance');
      final response = await _dio.get(
        '$_baseUrl/balance',
        queryParameters: {'account_type': 'CASH'},
        options: Options(
          headers: {
            'for-user-id': accountId,
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
      );

      debugPrint('Balance response status: ${response.statusCode}');
      debugPrint('Balance response data: ${response.data}');

      if (response.statusCode == 200) {
        final balance = (response.data['balance'] as num).toDouble();
        debugPrint('Successfully retrieved balance: ₱$balance');
        return balance;
      } else {
        debugPrint(
            'Error: Failed to fetch balance. Status: ${response.statusCode}');
        debugPrint('Error response data: ${response.data}');
        return 0.0;
      }
    } catch (e) {
      debugPrint('Error in getTotalBalance: ${e.toString()}');
      if (e is DioException) {
        debugPrint('Dio error type: ${e.type}');
        debugPrint('Dio error message: ${e.message}');
        debugPrint('Dio error response: ${e.response?.data}');
        debugPrint('Dio error request: ${e.requestOptions.uri}');
        debugPrint('Dio error headers: ${e.requestOptions.headers}');
      }
      return 0.0;
    }
  }

  Future<double> getToBeDisbursedAmount() async {
    if (secretKey.isEmpty) {
      debugPrint('Error: Secret key is empty');
      throw Exception('Xendit API key not configured');
    }

    try {
      debugPrint('Starting to-be-disbursed amount fetch process...');
      final accountId = await _getAccountId();
      debugPrint('Using account ID: $accountId');

      debugPrint('Making request to $_baseUrl/balance');
      final response = await _dio.get(
        '$_baseUrl/balance',
        queryParameters: {'account_type': 'HOLDING'},
        options: Options(
          headers: {
            'for-user-id': accountId,
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
      );

      debugPrint('Balance response status: ${response.statusCode}');
      debugPrint('Balance response data: ${response.data}');

      if (response.statusCode == 200) {
        final balance = (response.data['balance'] as num).toDouble();
        debugPrint('Successfully retrieved to-be-disbursed amount: ₱$balance');
        return balance;
      } else {
        debugPrint(
            'Error: Failed to fetch to-be-disbursed amount. Status: ${response.statusCode}');
        debugPrint('Error response data: ${response.data}');
        return 0.0;
      }
    } catch (e) {
      debugPrint('Error in getToBeDisbursedAmount: ${e.toString()}');
      if (e is DioException) {
        debugPrint('Dio error type: ${e.type}');
        debugPrint('Dio error message: ${e.message}');
        debugPrint('Dio error response: ${e.response?.data}');
        debugPrint('Dio error request: ${e.requestOptions.uri}');
        debugPrint('Dio error headers: ${e.requestOptions.headers}');
      }
      return 0.0;
    }
  }

  Future<List<Map<String, dynamic>>> getTransactionHistory({
    required String timePeriod,
  }) async {
    if (secretKey.isEmpty) {
      debugPrint('Error: Secret key is empty');
      throw Exception('Xendit API key not configured');
    }

    try {
      debugPrint('Starting transaction history fetch process...');
      final accountId = await _getAccountId();
      debugPrint('Using account ID: $accountId');

      final response = await _dio.get(
        '$_baseUrl/transactions',
        queryParameters: {
          'limit': 50,
          'types[]': [
            'PAYMENT',
            'DISBURSEMENT',
            'TRANSFER',
            'TOPUP',
            'WITHDRAWAL'
          ],
          'statuses[]': ['SUCCESS'],
          'currency': 'PHP',
        },
        options: Options(
          headers: {
            'for-user-id': accountId,
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
      );

      debugPrint('Transaction response status: ${response.statusCode}');
      debugPrint('Transaction response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> transactions = response.data['data'] ?? [];
        debugPrint('Found ${transactions.length} transactions');

        // Debug print each transaction
        for (var transaction in transactions) {
          debugPrint('Transaction: ${transaction.toString()}');
        }

        final now = DateTime.now();
        DateTime startDate;
        switch (timePeriod) {
          case 'This Week':
            startDate = now.subtract(const Duration(days: 7));
            break;
          case 'This Month':
            startDate = DateTime(now.year, now.month, 1);
            break;
          case 'Last Month':
            startDate = DateTime(now.year, now.month - 1, 1);
            break;
          case 'Last 3 Months':
            startDate = DateTime(now.year, now.month - 3, 1);
            break;
          case 'Last 6 Months':
            startDate = DateTime(now.year, now.month - 6, 1);
            break;
          case 'This Year':
            startDate = DateTime(now.year, 1, 1);
            break;
          default:
            startDate = DateTime(now.year, now.month, 1);
        }

        final List<Map<String, dynamic>> result = [];
        for (var transaction in transactions) {
          try {
            final transactionDate = DateTime.parse(
                transaction['created_at'] ?? transaction['created']);
            if (transactionDate.isBefore(startDate)) continue;

            final date = transactionDate.toIso8601String().split('T')[0];
            final amount = (transaction['amount'] as num).toDouble();
            final type = transaction['type'] as String;

            // Add individual transaction instead of daily totals
            result.add({
              'date': date,
              'timestamp': transactionDate
                  .toIso8601String(), // Add full timestamp for sorting
              'amount': type == 'DISBURSEMENT' || type == 'WITHDRAWAL'
                  ? -amount
                  : amount,
              'type': type,
              'status': transaction['status'],
              'reference': transaction['reference_id'] ??
                  transaction['external_id'] ??
                  '',
            });
          } catch (e) {
            debugPrint('Error processing transaction: $e');
            debugPrint('Problematic transaction: ${transaction.toString()}');
          }
        }

        // Sort by date and time (timestamp) descending
        result.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        debugPrint('Processed ${result.length} transactions');
        return result;
      } else {
        debugPrint(
            'Error: Failed to fetch transactions. Status: ${response.statusCode}');
        debugPrint('Error response data: ${response.data}');
        return [];
      }
    } catch (e) {
      debugPrint('Error in getTransactionHistory: ${e.toString()}');
      if (e is DioException) {
        debugPrint('Dio error type: ${e.type}');
        debugPrint('Dio error message: ${e.message}');
        debugPrint('Dio error response: ${e.response?.data}');
        debugPrint('Dio error request: ${e.requestOptions.uri}');
        debugPrint('Dio error headers: ${e.requestOptions.headers}');
      }
      return [];
    }
  }

  List<Map<String, dynamic>> generateDummyTransactions() {
    final List<Map<String, dynamic>> dummyTransactions = [];
    final now = DateTime.now();
    final random = math.Random();

    for (int i = 0; i < 20; i++) {
      final double amount = 500 +
          400 * (1 + math.sin(i * math.pi / 10)) +
          random.nextDouble() * 50;
      dummyTransactions.add({
        'date': now.subtract(Duration(days: i)).toIso8601String(),
        'amount': amount,
      });
    }

    return dummyTransactions;
  }

  Future<String> getDashboardUrl() async {
    if (secretKey.isEmpty) {
      throw Exception('Xendit API key not configured');
    }

    try {
      final accountId = await _getAccountId();
      // Return a custom URL scheme that our app will handle
      return 'ginaapp://xendit-dashboard';
    } catch (e) {
      debugPrint('Error getting dashboard URL: $e');
      throw Exception('Failed to get dashboard URL: $e');
    }
  }

  Future<Map<String, dynamic>> requestWithdrawal({
    required double amount,
    String? description,
    required String bankCode,
    required String accountNumber,
    required String accountHolderName,
  }) async {
    try {
      if (_isSimulationMode) {
        return _simulateWithdrawal(
          amount: amount,
          bankCode: bankCode,
          accountNumber: accountNumber,
          accountHolderName: accountHolderName,
          description: description,
        );
      }

      // 1. Validate inputs
      if (secretKey.isEmpty) {
        debugPrint('Error: Secret key is empty');
        throw Exception('Xendit API key not configured');
      }

      debugPrint(
          'Starting withdrawal with bank: $bankCode, account: $accountNumber');

      // 2. Generate unique IDs
      final externalId = 'disb-${DateTime.now().millisecondsSinceEpoch}';
      final idempotencyKey = 'idemp-$externalId';

      // 3. Convert PHP to IDR
      final idrAmount = _convertPhpToIdr(amount);
      debugPrint('Converted amount: ₱$amount PHP → $idrAmount IDR');

      // 4. Prepare request data
      final requestData = {
        'external_id': externalId,
        'bank_code': bankCode,
        'account_holder_name': accountHolderName,
        'account_number': accountNumber,
        'description': description ?? 'Test disbursement',
        'amount': idrAmount,
        'currency': 'IDR', // Must be IDR for Indonesian banks
      };

      debugPrint('Request data:');
      debugPrint(JsonEncoder.withIndent('  ').convert(requestData));

      // 5. Use the CORRECT endpoint
      final endpoint = '$_baseUrl/v2/disbursements'; // Standard endpoint
      debugPrint('Making request to: $endpoint');

      // 6. Make the request
      final response = await _dio.post(
        endpoint,
        data: requestData,
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
            'X-IDEMPOTENCY-KEY': idempotencyKey,
          },
          validateStatus: (status) =>
              status! < 500, // Accept any status code less than 500
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data:');
      debugPrint(JsonEncoder.withIndent('  ').convert(response.data));

      // 7. Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        _handleXenditError(response);
        throw Exception('Failed to process disbursement');
      }
    } catch (e) {
      _handleXenditError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _simulateWithdrawal({
    required double amount,
    required String bankCode,
    required String accountNumber,
    required String accountHolderName,
    String? description,
  }) async {
    try {
      debugPrint('Starting simulated withdrawal...');

      // 1. Validate inputs
      if (amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }

      // 2. Check if bank is supported
      if (!_testBankAccounts.containsKey(bankCode)) {
        throw Exception('Unsupported bank: $bankCode');
      }

      // 3. Validate amount against bank limits
      final bankLimits = _testBankAccounts[bankCode]!;
      if (amount < bankLimits['minAmount']) {
        throw Exception(
            'Amount below minimum limit of ₱${bankLimits['minAmount']}');
      }
      if (amount > bankLimits['maxAmount']) {
        throw Exception(
            'Amount above maximum limit of ₱${bankLimits['maxAmount']}');
      }

      // 4. Generate unique transaction ID
      final transactionId = 'sim-${DateTime.now().millisecondsSinceEpoch}';

      // 5. Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // 6. Create simulated response
      final response = {
        'id': transactionId,
        'status': 'COMPLETED',
        'amount': amount,
        'currency': 'PHP',
        'bank_code': bankCode,
        'account_number': accountNumber,
        'account_holder_name': accountHolderName,
        'description': description ?? 'Simulated withdrawal',
        'created_at': DateTime.now().toIso8601String(),
        'estimated_arrival':
            DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        'simulated': true,
      };

      debugPrint('Simulated withdrawal completed:');
      debugPrint(JsonEncoder.withIndent('  ').convert(response));

      return response;
    } catch (e) {
      debugPrint('Error in simulated withdrawal: $e');
      throw Exception('Failed to process simulated withdrawal: $e');
    }
  }

  void _handleXenditError(dynamic e) {
    if (e is DioException) {
      final response = e.response;
      if (response != null) {
        debugPrint('Xendit API Error: ${response.statusCode}');
        debugPrint('Response: ${response.data}');

        if (response.statusCode == 404) {
          throw Exception('''
Xendit endpoint not found. Please verify:
1. You're using the correct endpoint: /v2/disbursements
2. Your account has disbursement permissions enabled
3. You're using an Indonesian test bank account''');
        }

        final errorData = response.data;
        if (errorData is Map<String, dynamic>) {
          final errorMessage = errorData['message'] as String?;
          final errors = errorData['errors'] as List<dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            final fieldErrors = errors.map((error) {
              final field = (error['field'] as List<dynamic>).join('.');
              final messages = (error['messages'] as List<dynamic>).join(', ');
              return '$field: $messages';
            }).join('\n');
            throw Exception('Validation errors:\n$fieldErrors');
          }
          throw Exception(errorMessage ?? 'Failed to process disbursement');
        }
      }
    }
    throw Exception('Disbursement failed: ${e.toString()}');
  }

  Future<List<Map<String, dynamic>>> getWithdrawalHistory() async {
    if (secretKey.isEmpty) {
      throw Exception('Xendit API key not configured');
    }

    try {
      debugPrint('Fetching withdrawal history...');
      final accountId = await _getAccountId();

      final response = await _dio.get(
        '$_baseUrl/v2/managed_accounts/$accountId/withdrawals',
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
      );

      debugPrint('Withdrawal history response: ${response.data}');
      return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
    } catch (e) {
      debugPrint('Error fetching withdrawal history: $e');
      if (e is DioException) {
        debugPrint('Error response: ${e.response?.data}');
        throw Exception(e.response?.data?['message'] ??
            'Failed to fetch withdrawal history');
      }
      throw Exception('Failed to fetch withdrawal history: $e');
    }
  }

  String getBankCode(String bankName) {
    // Map Philippine bank names to their codes
    final bankCodes = {
      'BPI': 'BPI',
      'BDO': 'BDO',
      'METROBANK': 'METROBANK',
      'UNIONBANK': 'UNIONBANK',
      'RCBC': 'RCBC',
    };

    return bankCodes[bankName] ?? 'BPI'; // Default to BPI if not found
  }
}
