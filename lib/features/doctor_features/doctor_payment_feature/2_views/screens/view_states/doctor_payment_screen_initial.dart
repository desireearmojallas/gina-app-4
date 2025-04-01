import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/2_views/screens/doctor_xendit_activation_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/2_views/screens/dummy_xendit_dashboard_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/3_services/xendit_payment_service.dart';
import 'package:intl/intl.dart';
import 'package:gina_app_4/core/reusable_widgets/transaction_line_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class DoctorPaymentScreenInitial extends StatefulWidget {
  const DoctorPaymentScreenInitial({super.key});

  @override
  State<DoctorPaymentScreenInitial> createState() =>
      _DoctorPaymentScreenInitialState();
}

class _DoctorPaymentScreenInitialState
    extends State<DoctorPaymentScreenInitial> {
  final _xenditService = XenditPaymentService();
  String _selectedAccountType = 'bank';
  String _selectedTimePeriod = 'This Month';
  String? _selectedBank;
  String? _selectedEWallet;
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _customBankNameController = TextEditingController();
  final List<Map<String, dynamic>> _availableBanks = [];
  final List<Map<String, dynamic>> _availableEWallets = [];
  final bool _isLoadingBanks = false;
  final bool _isLoadingEWallets = false;
  double _totalBalance = 0.0;
  bool _isLoadingBalance = false;
  double _toBeDisbursedAmount = 0.0;
  bool _isLoadingToBeDisbursed = false;
  List<Map<String, dynamic>> _transactionHistory = [];
  bool _isLoadingTransactions = false;

  final List<String> _timePeriods = [
    'This Week',
    'This Month',
    'Last Month',
    'Last 3 Months',
    'Last 6 Months',
    'This Year',
  ];

  FlLine get _gridLine => FlLine(
        color: Colors.white.withOpacity(0.2),
        strokeWidth: 0.5,
        dashArray: [5, 5],
      );

  @override
  void initState() {
    super.initState();
    _checkXenditAccountStatus();
  }

  Future<void> _checkXenditAccountStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorXenditActivationScreen(),
            ),
          );
        }
        return;
      }

      final isActivated = await _xenditService.isAccountActivated();
      if (!isActivated && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DoctorXenditActivationScreen(),
          ),
        );
        return;
      }

      try {
        final accountDetails = await _xenditService.getAccountDetails();
        debugPrint('Account country: ${accountDetails['country']}');
        debugPrint('Account details: $accountDetails');
      } catch (e) {
        debugPrint('Error getting account details: $e');
      }

      // _loadBankAndEWalletOptions();
      _loadTotalBalance();
      _loadToBeDisbursedAmount();
      _loadTransactionHistory();
    } catch (e) {
      debugPrint('Error checking Xendit account status: $e');
      // _loadBankAndEWalletOptions();
      _loadTotalBalance();
      _loadToBeDisbursedAmount();
      _loadTransactionHistory();
    }
  }

  Future<void> _loadTotalBalance() async {
    if (!mounted) return;

    setState(() => _isLoadingBalance = true);
    try {
      final balance = await _xenditService.getTotalBalance();
      if (mounted) {
        setState(() => _totalBalance = balance);
      }
    } catch (e) {
      debugPrint('Error loading total balance: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingBalance = false);
      }
    }
  }

  Future<void> _loadToBeDisbursedAmount() async {
    if (!mounted) return;

    setState(() => _isLoadingToBeDisbursed = true);
    try {
      final amount = await _xenditService.getToBeDisbursedAmount();
      if (mounted) {
        setState(() => _toBeDisbursedAmount = amount);
      }
    } catch (e) {
      debugPrint('Error loading to-be-disbursed amount: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingToBeDisbursed = false);
      }
    }
  }

  Future<void> _loadTransactionHistory() async {
    if (!mounted) return;

    setState(() => _isLoadingTransactions = true);
    try {
      final transactions = await _xenditService.getTransactionHistory(
        timePeriod: _selectedTimePeriod,
      );
      if (mounted) {
        setState(() => _transactionHistory = transactions);
      }
    } catch (e) {
      debugPrint('Error loading transaction history: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingTransactions = false);
      }
    }
  }

  // Future<void> _loadBankAndEWalletOptions() async {
  //   setState(() {
  //     _isLoadingBanks = true;
  //     _isLoadingEWallets = true;
  //   });

  //   try {
  //     // Fetch bank details
  //     _availableBanks = await _xenditService.getAvailableBanks();
  //     setState(() => _isLoadingBanks = false);

  //     // Fetch e-wallet details
  //     _availableEWallets = await _xenditService.getAvailableEWallets();
  //     setState(() => _isLoadingEWallets = false);

  //     // If no API key is set, show a warning
  //     if (_xenditService.secretKey.isEmpty) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text(
  //                 'Using predefined payment options (Xendit API key not configured)'),
  //             backgroundColor: Colors.orange,
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoadingBanks = false;
  //       _isLoadingEWallets = false;
  //     });

  //     // Show error message only if mounted and the lists are empty
  //     if (mounted && _availableBanks.isEmpty && _availableEWallets.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //               'Using predefined payment options (API Error: ${e.toString()})'),
  //           backgroundColor: Colors.orange,
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   }
  // }

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

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _customBankNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'My Payment Account',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Earnings Card
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
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    GinaAppTheme.defaultBoxShadow,
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Earnings',
                          style: ginaTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: _showTimePeriodSelector,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedTimePeriod,
                                  style: ginaTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Gap(4),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_isLoadingToBeDisbursed)
                                const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CustomLoadingIndicator(
                                    colors: [Colors.white],
                                  ),
                                )
                              else
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '₱${NumberFormat('#,##0.00').format(_toBeDisbursedAmount)}',
                                    style: ginaTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              Text(
                                'To Be Disbursed',
                                style: ginaTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_isLoadingBalance)
                                const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CustomLoadingIndicator(
                                    colors: [Colors.white],
                                  ),
                                )
                              else
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '₱${NumberFormat('#,##0.00').format(_totalBalance)}',
                                    style: ginaTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              Text(
                                'Total Balance',
                                style: ginaTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
                    SizedBox(
                      height: 150,
                      child: _isLoadingTransactions
                          ? const Center(
                              child: CustomLoadingIndicator(
                                colors: [Colors.white],
                              ),
                            )
                          : _transactionHistory.isEmpty
                              ? Center(
                                  child: Text(
                                    'No transactions found',
                                    style: ginaTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                )
                              : TransactionLineChart(
                                  transactionData:
                                      _transactionHistory.map((data) {
                                    return {
                                      'date': data['date'],
                                      'amount': data['amount'] as double
                                    };
                                  }).toList().reversed.toList(),
                                  height: 200,
                                  lineColor: Colors.white,
                                  gradientStartColor: Colors.white,
                                  gradientEndColor: Colors.transparent,
                                ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              // Withdrawal Options Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Withdrawal Options',
                      style: ginaTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      'To withdraw your earnings, please visit your Xendit dashboard to set up your bank account and process withdrawals.',
                      style: ginaTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const Gap(24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _copyDashboardUrl,
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy Dashboard URL'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _openDashboard,
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Open Dashboard'),
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  GinaAppTheme.lightTertiaryContainer,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRowWithLogo(String label, String value) {
    // Get the display value for bank name
    String displayValue = value;
    if (label == 'Bank' && value == 'OTHER') {
      displayValue = '${_customBankNameController.text} (OTHER)';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _selectedAccountType == 'bank'
                    ? Icons.account_balance
                    : Icons.account_balance_wallet,
                size: 16,
                color: Colors.grey,
              ),
            ),
            const Gap(8),
            Text(
              displayValue,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountTypeOption(
    String value,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => setState(() => _selectedAccountType = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? GinaAppTheme.lightTertiaryContainer.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? GinaAppTheme.lightTertiaryContainer
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? GinaAppTheme.lightTertiaryContainer
                  : Colors.grey[600],
              size: 24,
            ),
            const Gap(8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? GinaAppTheme.lightTertiaryContainer
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const Gap(8),
        if (_isLoadingBanks)
          const Center(child: CustomLoadingIndicator())
        else
          DropdownButtonFormField<String>(
            value: _availableBanks.any((bank) => bank['code'] == _selectedBank)
                ? _selectedBank
                : null,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: GinaAppTheme.lightTertiaryContainer,
                  width: 1.5,
                ),
              ),
              prefixIcon: const Icon(
                Icons.account_balance,
                color: GinaAppTheme.lightTertiaryContainer,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: _availableBanks.map((bank) {
              final code = bank['code'] as String;
              final name = bank['name'] as String;
              return DropdownMenuItem<String>(
                value: code,
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedBank = value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a bank';
              }
              return null;
            },
          ),
        const Gap(16),
        // Show bank name field if Other Bank is selected
        if (_selectedBank == 'OTHER') ...[
          TextFormField(
            controller: _customBankNameController,
            decoration: InputDecoration(
              labelText: 'Bank Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: GinaAppTheme.lightTertiaryContainer,
                  width: 1.5,
                ),
              ),
              prefixIcon: const Icon(
                Icons.account_balance,
                color: GinaAppTheme.lightTertiaryContainer,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter bank name';
              }
              return null;
            },
          ),
          const Gap(16),
        ],
        TextFormField(
          controller: _accountNumberController,
          decoration: InputDecoration(
            labelText: 'Account Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: GinaAppTheme.lightTertiaryContainer,
                width: 1.5,
              ),
            ),
            prefixIcon: const Icon(
              Icons.numbers,
              color: GinaAppTheme.lightTertiaryContainer,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account number';
            }
            return null;
          },
        ),
        const Gap(16),
        TextFormField(
          controller: _accountNameController,
          decoration: InputDecoration(
            labelText: 'Account Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: GinaAppTheme.lightTertiaryContainer,
                width: 1.5,
              ),
            ),
            prefixIcon: const Icon(
              Icons.person,
              color: GinaAppTheme.lightTertiaryContainer,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEWalletSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'E-Wallet Provider',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const Gap(8),
        if (_isLoadingEWallets)
          const Center(child: CustomLoadingIndicator())
        else
          DropdownButtonFormField<String>(
            value: _selectedEWallet,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: GinaAppTheme.lightTertiaryContainer,
                  width: 1.5,
                ),
              ),
              prefixIcon: const Icon(
                Icons.account_balance_wallet,
                color: GinaAppTheme.lightTertiaryContainer,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: _availableEWallets.map((eWallet) {
              final code = eWallet['channel_code'] as String;
              final name = eWallet['name'] as String;
              return DropdownMenuItem<String>(
                value: code,
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedEWallet = value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an e-wallet provider';
              }
              return null;
            },
          ),
        const Gap(16),
        TextFormField(
          controller: _accountNumberController,
          decoration: InputDecoration(
            labelText: 'Account Number/Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: GinaAppTheme.lightTertiaryContainer,
                width: 1.5,
              ),
            ),
            prefixIcon: const Icon(
              Icons.person,
              color: GinaAppTheme.lightTertiaryContainer,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account number or username';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _openDashboard() async {
    try {
      final dashboardUrl = await _xenditService.getDashboardUrl();
      debugPrint('Attempting to open URL: $dashboardUrl');

      if (dashboardUrl.startsWith('ginaapp://')) {
        // Handle our custom URL scheme
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DummyXenditDashboardScreen(),
            ),
          );
        }
        return;
      }

      final uri = Uri.parse(dashboardUrl);
      debugPrint('Parsed URI: $uri');

      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
        debugPrint('Launch successful: $launched');

        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to open dashboard'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Try alternative method if canLaunchUrl fails
        try {
          final launched = await launchUrl(
            uri,
            mode: LaunchMode.platformDefault,
          );
          debugPrint('Alternative launch successful: $launched');

          if (!launched && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to open dashboard'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          debugPrint('Alternative launch failed: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Cannot open URL: $dashboardUrl\nError: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error in _openDashboard: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening dashboard: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _copyDashboardUrl() async {
    try {
      final dashboardUrl = await _xenditService.getDashboardUrl();
      await Clipboard.setData(ClipboardData(text: dashboardUrl));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Xendit dashboard URL copied to clipboard!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error copying URL: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
