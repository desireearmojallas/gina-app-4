import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
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

  void _simulateSuccessfulWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;

    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() => _isLoading = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            title: const Text('Withdrawal Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: ₱${NumberFormat('#,##0.00').format(amount)}'),
                Text('Bank: $_selectedBank'),
                Text('Account Number: ${_accountNumberController.text}'),
                Text('Account Name: ${_accountNameController.text}'),
                const Gap(8),
                const Text(
                  'Your withdrawal request has been submitted successfully. The amount will be credited to your bank account within 1-2 business days.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  _amountController.clear();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: GinaAppTheme.lightTertiaryContainer,
                ),
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _processWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final amount = double.parse(_amountController.text);
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
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Withdrawal Successful'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: ₱${NumberFormat('#,##0.00').format(amount)}'),
                  Text('Bank: $bankName'),
                  Text('Account Number: ${_accountNumberController.text}'),
                  Text('Account Name: ${_accountNameController.text}'),
                  const Gap(8),
                  const Text(
                    'Your withdrawal request has been submitted successfully. The amount will be credited to your bank account within 1-2 business days.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    // Clear form fields
                    _amountController.clear();
                    _accountNumberController.clear();
                    _accountNameController.clear();
                    if (_selectedBank == 'Other') {
                      _bankNameController.clear();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: GinaAppTheme.lightTertiaryContainer,
                  ),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
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
                      child: CustomLoadingIndicator(
                        colors: [
                          Colors.white,
                        ],
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
                        // onPressed: _isLoading ? null : _processWithdrawal,
                        onPressed: _isLoading
                            ? null
                            : () {
                                _simulateSuccessfulWithdrawal();
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: GinaAppTheme.lightTertiaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CustomLoadingIndicator(
                                  colors: [
                                    Colors.white,
                                  ],
                                ),
                              )
                            : const Text('Submit Withdrawal'),
                      ),
                    ),
                  ],
                ),
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
