import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/3_services/patient_payment_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PatientPaymentScreenInitial extends StatefulWidget {
  final String appointmentId;
  final String doctorName;
  final int modeOfAppointment;
  final double amount;
  final DateTime appointmentDate;

  const PatientPaymentScreenInitial({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.modeOfAppointment,
    required this.amount,
    required this.appointmentDate,
  });

  @override
  State<PatientPaymentScreenInitial> createState() =>
      _PatientPaymentScreenInitialState();
}

class _PatientPaymentScreenInitialState
    extends State<PatientPaymentScreenInitial> {
  final _paymentService = PatientPaymentService();
  bool _isLoading = false;
  String? _invoiceUrl;
  String? _invoiceNumber;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _createInvoice();
  }

  Future<void> _createInvoice() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final invoice = await _paymentService.createPaymentInvoice(
        appointmentId: widget.appointmentId,
        doctorName: widget.doctorName,
        patientName: 'Patient Name', // TODO: Get actual patient name
        modeOfAppointment: widget.modeOfAppointment,
        amount: widget.amount,
        appointmentDate: widget.appointmentDate,
      );

      setState(() {
        _invoiceUrl = invoice['invoice_url'];
        _invoiceNumber = invoice['invoice_number'];
        _isLoading = false;
      });

      // Automatically launch the payment URL when ready
      if (_invoiceUrl != null) {
        await _launchPaymentUrl();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating invoice: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _launchPaymentUrl() async {
    if (_invoiceUrl == null) return;

    final uri = Uri.parse(_invoiceUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch payment page'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Loading State
                if (_isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomLoadingIndicator(),
                        const Gap(16),
                        Text(
                          'Preparing your payment...',
                          style: ginaTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                // Error State
                else if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red[700], size: 48),
                        const Gap(16),
                        Text(
                          'Payment Error',
                          style: ginaTheme.titleMedium?.copyWith(
                            color: Colors.red[900],
                          ),
                        ),
                        const Gap(8),
                        Text(
                          _errorMessage!,
                          style: ginaTheme.bodyMedium?.copyWith(
                            color: Colors.red[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(16),
                        FilledButton(
                          onPressed: _createInvoice,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red[700],
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                // Success State
                else if (_invoiceUrl != null)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green[700],
                          size: 48,
                        ),
                        const Gap(16),
                        Text(
                          'Redirecting to Payment Page...',
                          style: ginaTheme.titleMedium,
                        ),
                        const Gap(8),
                        Text(
                          'Invoice Number: $_invoiceNumber',
                          style: ginaTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const Gap(24),
                        FilledButton(
                          onPressed: _launchPaymentUrl,
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                GinaAppTheme.lightTertiaryContainer,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: const Text('Open Payment Page'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
