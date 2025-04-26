import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class PaymentAccountForm extends StatefulWidget {
  const PaymentAccountForm({super.key});

  @override
  State<PaymentAccountForm> createState() => _PaymentAccountFormState();
}

class _PaymentAccountFormState extends State<PaymentAccountForm> {
  String selectedAccountType = 'bank';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Type Selection
          Container(
            width: size.width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Type',
                  style: ginaTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(12),
                Row(
                  children: [
                    Expanded(
                      child: _buildAccountTypeOption(
                        'Bank Account',
                        'bank',
                        Icons.account_balance_rounded,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: _buildAccountTypeOption(
                        'E-Wallet',
                        'ewallet',
                        Icons.payment_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(24),

          // Account Details Form
          Container(
            width: size.width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Details',
                  style: ginaTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(16),
                if (selectedAccountType == 'bank') ...[
                  _buildBankAccountFields(),
                ] else ...[
                  _buildEWalletFields(),
                ],
              ],
            ),
          ),
          const Gap(32),

          // Save Button
          SizedBox(
            width: size.width,
            height: 50,
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Implement save functionality
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: GinaAppTheme.lightTertiaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save Account Details',
                style: ginaTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeOption(
    String title,
    String value,
    IconData icon,
  ) {
    final isSelected = selectedAccountType == value;
    return InkWell(
      onTap: () => setState(() => selectedAccountType = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? GinaAppTheme.lightTertiaryContainer.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? GinaAppTheme.lightTertiaryContainer
                : Colors.grey[200]!,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? GinaAppTheme.lightTertiaryContainer
                  : Colors.grey[400],
              size: 24,
            ),
            const Gap(8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
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

  Widget _buildBankAccountFields() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Bank Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(
              Icons.account_balance_rounded,
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
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Account Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(
              Icons.numbers_rounded,
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
          decoration: InputDecoration(
            labelText: 'Account Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(
              Icons.person_rounded,
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

  Widget _buildEWalletFields() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'E-Wallet Provider',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(
              Icons.payment_rounded,
              color: GinaAppTheme.lightTertiaryContainer,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter e-wallet provider';
            }
            return null;
          },
        ),
        const Gap(16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Account Number/Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(
              Icons.person_rounded,
              color: GinaAppTheme.lightTertiaryContainer,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account number/username';
            }
            return null;
          },
        ),
      ],
    );
  }
} 