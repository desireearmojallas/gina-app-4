import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/3_services/xendit_payment_service.dart';
import 'package:intl/intl.dart';

class DummyXenditDashboardScreen extends StatefulWidget {
  const DummyXenditDashboardScreen({super.key});

  @override
  State<DummyXenditDashboardScreen> createState() =>
      _DummyXenditDashboardScreenState();
}

class _DummyXenditDashboardScreenState
    extends State<DummyXenditDashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _xenditService = XenditPaymentService();
  String _selectedBank = 'BPI';
  bool _isLoading = false;
  bool _isLoadingBalance = false;
  bool _isLoadingTransactions = false;
  double _balance = 0.0;
  List<Map<String, dynamic>> _withdrawalHistory = [];
  String _selectedTimePeriod = 'This Month';

  final List<String> _banks = [
    'BPI',
    'BDO',
    'METROBANK',
    'UNIONBANK',
    'RCBC',
  ];

  // Test bank account details for Philippine banks
  final Map<String, Map<String, String>> _testBankAccounts = {
    'BPI': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
    },
    'BDO': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
    },
    'METROBANK': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
    },
    'UNIONBANK': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
    },
    'RCBC': {
      'accountNumber': '1234567890',
      'accountName': 'TEST ACCOUNT',
    },
  };

  final List<String> _timePeriods = [
    'This Week',
    'This Month',
    'Last Month',
    'Last 3 Months',
    'Last 6 Months',
    'This Year',
  ];

  // Group banks for dropdown organization
  List<DropdownMenuItem<String>> get _bankItems {
    final banks = [
      const DropdownMenuItem(
        value: 'BANKS',
        enabled: false,
        child: Text(
          'Philippine Test Banks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
      ..._banks.map((bank) => DropdownMenuItem(
            value: bank,
            child: Text(bank),
          )),
    ];
    return banks;
  }

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _loadTransactionHistory();
    // Pre-fill test account details if BPI is selected
    _accountNumberController.text = _testBankAccounts['BPI']!['accountNumber']!;
    _accountNameController.text = _testBankAccounts['BPI']!['accountName']!;
  }

  Future<void> _loadBalance() async {
    setState(() => _isLoadingBalance = true);
    try {
      final balance = await _xenditService.getTotalBalance();
      if (mounted) {
        setState(() => _balance = balance);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading balance: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingBalance = false);
      }
    }
  }

  Future<void> _loadTransactionHistory() async {
    setState(() => _isLoadingTransactions = true);
    try {
      final transactions = await _xenditService.getTransactionHistory(
        timePeriod: _selectedTimePeriod,
      );
      if (mounted) {
        setState(() => _withdrawalHistory = transactions);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading transaction history: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingTransactions = false);
      }
    }
  }

  Future<void> _processWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      if (amount > _balance) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insufficient balance'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final bankName =
          _selectedBank == 'Other' ? _bankNameController.text : _selectedBank;
      final bankCode = _xenditService.getBankCode(bankName);

      // Process withdrawal through Xendit API
      await _xenditService.requestWithdrawal(
        amount: amount,
        description: 'Withdrawal to $bankName',
        bankCode: bankCode,
        accountNumber: _accountNumberController.text,
        accountHolderName: _accountNameController.text,
      );

      // Refresh balance and history
      await _loadBalance();
      await _loadTransactionHistory();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Withdrawal request submitted successfully',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Clear form fields
        _amountController.clear();
        _accountNumberController.clear();
        _accountNameController.clear();
        if (_selectedBank == 'Other') {
          _bankNameController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing withdrawal: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showTimePeriodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Select Time Period',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            ..._timePeriods.map((period) => ListTile(
                  title: Text(period),
                  selected: period == _selectedTimePeriod,
                  onTap: () {
                    setState(() => _selectedTimePeriod = period);
                    Navigator.pop(context);
                    _loadTransactionHistory();
                  },
                )),
          ],
        ),
      ),
    );
  }

  // Update the bank selection handler
  void _handleBankSelection(String? value) {
    if (value != null && value != 'BANKS') {
      setState(() {
        _selectedBank = value;
        // Update account details if it's a test bank
        if (_testBankAccounts.containsKey(value)) {
          _accountNumberController.text =
              _testBankAccounts[value]!['accountNumber']!;
          _accountNameController.text =
              _testBankAccounts[value]!['accountName']!;
        } else {
          // Clear the fields if not a test bank
          _accountNumberController.clear();
          _accountNameController.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xendit Dashboard (Simulation Mode)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simulation Mode Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      'Simulation Mode: Withdrawals are simulated for testing purposes. No real transactions will occur.',
                      style: ginaTheme.bodyMedium?.copyWith(
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffeea0b6),
                    GinaAppTheme.lightTertiaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: ginaTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(8),
                  if (_isLoadingBalance)
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    Text(
                      '₱${NumberFormat('#,##0.00').format(_balance)}',
                      style: ginaTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const Gap(24),

            // Withdrawal Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Withdrawal',
                      style: ginaTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                        prefixText: '₱',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),
                    DropdownButtonFormField<String>(
                      value: _selectedBank,
                      decoration: const InputDecoration(
                        labelText: 'Bank',
                        border: OutlineInputBorder(),
                      ),
                      items: _bankItems,
                      onChanged: _handleBankSelection,
                    ),
                    const Gap(8),
                    if (_testBankAccounts.containsKey(_selectedBank))
                      Text(
                        'Using test account for ${_selectedBank}. This is for development only.',
                        style: ginaTheme.bodySmall?.copyWith(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const Gap(16),
                    TextFormField(
                      controller: _accountNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Account Number',
                        hintText: 'Enter your bank account number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        // Basic bank account number validation (at least 8 digits)
                        final cleanNumber =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (cleanNumber.length < 8) {
                          return 'Please enter a valid bank account number';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: _accountNameController,
                      decoration: const InputDecoration(
                        labelText: 'Account Holder Name',
                        hintText: 'Name as registered with the bank',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account holder name';
                        }
                        return null;
                      },
                    ),
                    const Gap(24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _processWithdrawal,
                        style: FilledButton.styleFrom(
                          backgroundColor: GinaAppTheme.lightTertiaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('Submit Withdrawal'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),

            // Transaction History
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction History',
                        style: ginaTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: _showTimePeriodSelector,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedTimePeriod,
                              style: ginaTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const Gap(4),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  if (_isLoadingTransactions)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (_withdrawalHistory.isEmpty)
                    Center(
                      child: Text(
                        'No transactions found',
                        style: ginaTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _withdrawalHistory.length,
                      itemBuilder: (context, index) {
                        final transaction = _withdrawalHistory[index];
                        final amount = transaction['amount'] as double;
                        final isPositive = amount > 0;
                        final type = transaction['type'] as String;
                        final status = transaction['status'] as String;
                        final reference = transaction['reference'] as String;

                        String transactionType = type.toLowerCase();
                        switch (type) {
                          case 'PAYMENT':
                            transactionType = 'Payment Received';
                            break;
                          case 'DISBURSEMENT':
                            transactionType = 'Withdrawal';
                            break;
                          case 'TRANSFER':
                            transactionType = 'Transfer';
                            break;
                          case 'TOPUP':
                            transactionType = 'Top Up';
                            break;
                          case 'WITHDRAWAL':
                            transactionType = 'Withdrawal';
                            break;
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₱${NumberFormat('#,##0.00').format(amount.abs())}',
                                      style: ginaTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isPositive
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      transactionType,
                                      style: ginaTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (reference.isNotEmpty)
                                      Text(
                                        'Ref: $reference',
                                        style: ginaTheme.bodySmall?.copyWith(
                                          color: Colors.grey[400],
                                          fontSize: 10,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat('MMM d, y').format(
                                      DateTime.parse(transaction['date']),
                                    ),
                                    style: ginaTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    DateFormat('h:mm a').format(
                                      DateTime.parse(transaction['timestamp']),
                                    ),
                                    style: ginaTheme.bodySmall?.copyWith(
                                      color: Colors.grey[400],
                                      fontSize: 10,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: status == 'SUCCESS' ||
                                              status == 'COMPLETED'
                                          ? Colors.green[50]
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      status,
                                      style: ginaTheme.bodySmall?.copyWith(
                                        color: status == 'SUCCESS' ||
                                                status == 'COMPLETED'
                                            ? Colors.green
                                            : Colors.grey[600],
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }
}
