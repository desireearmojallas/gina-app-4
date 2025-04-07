import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/doctor_consultation_fee_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/2_views/screens/view_states/doctor_payment_screen_initial.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/3_services/xendit_payment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorXenditActivationScreen extends StatefulWidget {
  const DoctorXenditActivationScreen({super.key});

  @override
  State<DoctorXenditActivationScreen> createState() =>
      _DoctorXenditActivationScreenState();
}

class _DoctorXenditActivationScreenState
    extends State<DoctorXenditActivationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _xenditService = XenditPaymentService();
  bool _isLoading = false;
  bool _isCheckingStatus = false;
  String? _doctorId;

  // Form controllers
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isLoadingFees = true;
  bool _hasSetupFees = false;

  @override
  void initState() {
    super.initState();
    _getDoctorId();
  }

  Future<void> _getDoctorId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => _doctorId = user.uid);
      await _checkConsultationFees();
    }
  }

  Future<void> _checkConsultationFees() async {
    if (_doctorId == null) return;

    setState(() => _isLoadingFees = true);

    try {
      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(_doctorId)
          .get();

      if (doctorDoc.exists) {
        final doctorData = doctorDoc.data();

        // Check if consultation fees are set
        final bool hasF2FPrice =
            doctorData?['f2fInitialConsultationPrice'] != null &&
                doctorData!['f2fInitialConsultationPrice'] > 0;
        final bool hasOLPrice =
            doctorData?['olInitialConsultationPrice'] != null &&
                doctorData!['olInitialConsultationPrice'] > 0;

        setState(() {
          _hasSetupFees = hasF2FPrice || hasOLPrice;
          _isLoadingFees = false;
        });

        if (!_hasSetupFees && mounted) {
          // Show dialog if fees are not set up
          _showConsultationFeeRequiredDialog();
        } else {
          // Only check account status if fees are set up
          await _checkAccountStatus();
        }
      } else {
        setState(() => _isLoadingFees = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Doctor profile not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking consultation fees: $e');
      setState(() => _isLoadingFees = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking fees: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _checkAccountStatus() async {
    if (_isCheckingStatus || _doctorId == null) return;

    setState(() => _isCheckingStatus = true);

    try {
      debugPrint('Checking account status for doctorId: $_doctorId');
      final isActivated = await _xenditService.isAccountActivated();
      debugPrint('Account activation status: $isActivated');

      if (isActivated) {
        debugPrint('Account is activated.');
        if (mounted) {
          debugPrint(
              'Widget is mounted. Navigating to DoctorPaymentScreenInitial.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorPaymentScreenInitial(),
            ),
          );
        } else {
          debugPrint('Widget is not mounted. Navigation skipped.');
        }
      } else {
        debugPrint('Account is not activated.');
      }
    } catch (e) {
      debugPrint('Error checking account status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking account status: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingStatus = false);
      }
    }
  }

  void _showConsultationFeeRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Consultation Fees Required'),
          content: const Text(
            'You need to set up your consultation fees before activating payment processing. Would you like to set them up now?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Return to previous screen
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to consultation fee screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DoctorConsultationFeeScreenProvider(
                      isSetUpXenditAccountMode: true,
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: GinaAppTheme.lightTertiaryContainer,
              ),
              child: const Text('Set Up Now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    if (_isLoadingFees || _isCheckingStatus) {
      return const Center(child: CustomLoadingIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Setup',
              style: ginaTheme.titleLarge,
            ),
            const Gap(8),
            Text(
              'Please provide your details to set up your Xendit account for payouts.',
              style: ginaTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const Gap(24),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const Gap(16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const Gap(32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: GinaAppTheme.lightTertiaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CustomLoadingIndicator()
                    : const Text('Set Up Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || _doctorId == null) return;

    setState(() => _isLoading = true);

    try {
      await _xenditService.activateTestAccount(
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      );

      if (mounted) {
        // Check account status after activation
        await _checkAccountStatus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
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

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
