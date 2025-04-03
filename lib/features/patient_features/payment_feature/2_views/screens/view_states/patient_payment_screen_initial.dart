import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/2_views/widgets/rounded_rectangle_receipt_base.dart';
import 'package:gina_app_4/features/patient_features/payment_feature/3_services/patient_payment_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PatientPaymentScreenInitial extends StatefulWidget {
  final String appointmentId;
  final String doctorName;
  final String patientName;
  final int modeOfAppointment;
  final double amount;
  final DateTime appointmentDate;
  final String? existingInvoiceUrl;
  final bool showReceipt;

  const PatientPaymentScreenInitial({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.patientName,
    required this.modeOfAppointment,
    required this.amount,
    required this.appointmentDate,
    this.existingInvoiceUrl,
    this.showReceipt = false,
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
  String _paymentStatus = 'pending';
  Timer? _pollingTimer;
  StreamSubscription<DocumentSnapshot>? _appointmentSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.showReceipt) {
      _invoiceUrl = widget.existingInvoiceUrl;
      _paymentStatus = 'paid';
    } else if (widget.existingInvoiceUrl != null) {
      _invoiceUrl = widget.existingInvoiceUrl;
      _startPaymentStatusPolling();
    } else {
      _createInvoice();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _appointmentSubscription?.cancel();
    super.dispose();
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
        patientName: widget.patientName,
        consultationType:
            widget.modeOfAppointment == 0 ? 'Face-to-face' : 'Online',
        amount: widget.amount,
        appointmentDate: widget.appointmentDate,
      );

      debugPrint('Received invoice data: $invoice');

      setState(() {
        _invoiceUrl = invoice['invoiceUrl'];
        _invoiceNumber = invoice['invoiceId'];
        _isLoading = false;
      });

      _startPaymentStatusPolling();

      await Future.delayed(Duration.zero);

      if (_invoiceUrl != null) {
        debugPrint('Launching payment URL: $_invoiceUrl');
        await _launchPaymentUrl();
      } else {
        debugPrint('Error: Invoice URL is null after state update');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to get payment URL. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
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

  void _startPaymentStatusPolling() {
    _paymentService.startPaymentStatusPolling(
      appointmentId: widget.appointmentId,
      onStatusChanged: (status) {
        setState(() {
          _paymentStatus = status;
        });

        switch (status) {
          case 'paid':
            _showPaymentSuccessDialog();
            break;
          case 'expired':
          case 'failed':
            _showPaymentFailedDialog();
            break;
          default:
            break;
        }
      },
      onPaymentSuccess: () {
        _showPaymentSuccessDialog();
      },
      onPaymentFailed: () {
        _showPaymentFailedDialog();
      },
    );
  }

  void _startAppointmentStatusListener() {
    _appointmentSubscription = FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.appointmentId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          setState(() {
            _paymentStatus = data['status'] ?? 'pending';
          });

          switch (_paymentStatus) {
            case 'payment_pending':
              break;
            case 'awaiting_approval':
              _pollingTimer?.cancel();
              _showApprovalPendingDialog();
              break;
            case 'payment_failed':
              _pollingTimer?.cancel();
              _showPaymentFailedDialog();
              break;
            case 'approved':
              _pollingTimer?.cancel();
              _showPaymentSuccessDialog();
              break;
            case 'declined':
              _pollingTimer?.cancel();
              _showPaymentDeclinedDialog();
              break;
          }
        }
      }
    });
  }

  Future<void> _launchPaymentUrl() async {
    if (_invoiceUrl == null) {
      debugPrint('Error: Invoice URL is null');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment URL not available. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    debugPrint('Attempting to launch payment URL: $_invoiceUrl');

    try {
      final Uri uri = Uri.parse(_invoiceUrl!);
      debugPrint('Parsed URI: $uri');

      bool launched = false;
      try {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
        if (launched) {
          debugPrint('Successfully launched URL in in-app WebView');
          return;
        }
      } catch (e) {
        debugPrint('Failed to launch in in-app WebView: $e');
      }

      if (!launched) {
        try {
          launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) {
            debugPrint('Successfully launched URL in external application');
            return;
          }
        } catch (e) {
          debugPrint('Failed to launch in external application: $e');
        }
      }

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Could not open payment page. Please copy the link and open it in your browser.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'Copy Link',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _invoiceUrl!));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Payment link copied to clipboard. Please paste it in your browser.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              textColor: Colors.white,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error launching payment URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Could not open payment page. Please copy the link and open it in your browser.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'Copy Link',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _invoiceUrl!));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Payment link copied to clipboard. Please paste it in your browser.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              textColor: Colors.white,
            ),
          ),
        );
      }
    }
  }

  void _showApprovalPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment Received'),
        content: const Text(
          'Your payment has been received and is pending doctor approval. '
          'You will be notified once the doctor approves your appointment.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text(
          'Your payment could not be processed. Please try again or contact support.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _createInvoice();
            },
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Approved'),
        content: const Text(
          'Your appointment has been approved by the doctor. '
          'You will receive a confirmation email with the details.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDeclinedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Declined'),
        content: const Text(
          'The doctor has declined your appointment request. '
          'A refund will be processed to your original payment method.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentReceiptCard(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return NotchedRoundedRectangle(
      width: size.width - 32,
      height: 600,
      color: Colors.white,
      notchRadius: 15,
      notchOffsetY: 6,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Text(
                      'Payment Receipt',
                      style: ginaTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Your reservation',
                      style: ginaTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    GinaDivider(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Doctor',
                          style: ginaTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Dr. ${widget.doctorName}',
                          style: ginaTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Patient',
                          style: ginaTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          widget.patientName,
                          style: ginaTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: ginaTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          DateFormat('MMMM d, yyyy')
                              .format(widget.appointmentDate),
                          style: ginaTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mode',
                          style: ginaTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: GinaAppTheme.lightTertiaryContainer
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.modeOfAppointment == 0
                                ? 'Online Consultation'
                                : 'Face-to-Face Consultation',
                            style: ginaTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: GinaAppTheme.lightTertiaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color:
                          GinaAppTheme.lightTertiaryContainer.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: ginaTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
                    ),
                    Text(
                      '₱${widget.amount.toStringAsFixed(2)}',
                      style: ginaTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pending_payments')
                    .doc(widget.appointmentId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists) {
                    return const SizedBox.shrink();
                  }

                  final paymentData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final paymentMethod =
                      paymentData['paymentMethod'] ?? 'Xendit';

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Method',
                              style: ginaTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              paymentMethod,
                              style: ginaTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reference No.',
                              style: ginaTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              paymentData['invoiceId'] ?? 'N/A',
                              style: ginaTheme.bodyMedium?.copyWith(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Gap(32),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: GinaAppTheme.lightTertiaryContainer,
                  minimumSize: Size(size.width - 80, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Done'),
              ),
              const Gap(15),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showReceipt ? 'Payment Receipt' : 'Payment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showReceipt) ...[
                  _buildPaymentReceiptCard(context),
                ] else if (_isLoading)
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
