import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/2_views/bloc/admin_settings_bloc.dart';

class PaymentValidityWidget extends StatelessWidget {
  const PaymentValidityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Load payment validity settings when the widget is built
    context.read<AdminSettingsBloc>().add(const LoadPaymentValiditySettings());
    return const _PaymentValidityContent();
  }
}

class _PaymentValidityContent extends StatefulWidget {
  const _PaymentValidityContent();

  @override
  State<_PaymentValidityContent> createState() =>
      _PaymentValidityContentState();
}

class _PaymentValidityContentState extends State<_PaymentValidityContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _paymentWindowController =
      TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();

    _paymentWindowController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    // Mark form as dirty if any changes are made
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  @override
  void dispose() {
    _paymentWindowController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;

      if (remainingMinutes == 0) {
        return hours == 1 ? '$hours hour' : '$hours hours';
      } else {
        final hourText = hours == 1 ? '$hours hour' : '$hours hours';
        return '$hourText $remainingMinutes minutes';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return BlocConsumer<AdminSettingsBloc, AdminSettingsState>(
      listenWhen: (previous, current) =>
          current is AdminSettingsError ||
          current is PaymentValiditySettingsUpdated,
      listener: (context, state) {
        if (state is AdminSettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is PaymentValiditySettingsUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  Gap(16),
                  Text('Payment window updated successfully',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              duration: const Duration(seconds: 2),
            ),
          );
          setState(() => _isDirty = false);
        }
      },
      builder: (context, state) {
        // Initialize controllers when data is loaded
        if (state is PaymentValiditySettingsLoaded &&
            _paymentWindowController.text.isEmpty) {
          _paymentWindowController.text = state.paymentWindowMinutes.toString();
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24.0),
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and header
                Text(
                  'Payment Validity Settings',
                  style: ginaTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GinaAppTheme.lightOnSurface,
                  ),
                ),

                const Gap(8),

                Text(
                  'Configure the time window patients have to complete payment after appointment approval',
                  style: ginaTheme.bodyMedium?.copyWith(
                    color: GinaAppTheme.lightOnSurfaceVariant,
                  ),
                ),

                const Gap(24),

                // Info banner explaining payment window
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          GinaAppTheme.lightTertiaryContainer.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: GinaAppTheme.lightSecondary,
                        size: 24,
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About Payment Window',
                              style: ginaTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: GinaAppTheme.lightOnSurface,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'This setting controls how long patients have to complete their payment after their appointment request is approved by a doctor. If payment is not received within this time window, the appointment will be automatically declined.',
                              style: ginaTheme.bodyMedium?.copyWith(
                                color: GinaAppTheme.lightOnSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(32),

                // Form
                if (state is AdminSettingsLoading)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomLoadingIndicator(),
                          Gap(16),
                          Text('Loading payment validity settings...'),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Current Settings Card
                            if (state is PaymentValiditySettingsLoaded)
                              _buildCurrentSettingsCard(state, ginaTheme),

                            const Gap(32),

                            // Payment window input field
                            Text(
                              'Payment Window',
                              style: ginaTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: GinaAppTheme.lightOnSurface,
                              ),
                            ),

                            const Gap(16),

                            // Payment window duration input
                            _buildPaymentWindowField(
                              context: context,
                              controller: _paymentWindowController,
                              ginaTheme: ginaTheme,
                            ),

                            const Gap(16),

                            // Recommended presets
                            Text(
                              'Recommended Presets',
                              style: ginaTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: GinaAppTheme.lightOnSurface,
                              ),
                            ),

                            const Gap(8),

                            // Preset buttons
                            _buildPresetButtons(ginaTheme),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Save button
                if (state is! AdminSettingsLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: _isDirty
                              ? () {
                                  // Reset the form to original values
                                  if (state is PaymentValiditySettingsLoaded) {
                                    _paymentWindowController.text =
                                        state.paymentWindowMinutes.toString();
                                    setState(() => _isDirty = false);
                                  }
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(
                              color: GinaAppTheme.lightOutlineVariant,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: ginaTheme.labelLarge?.copyWith(
                              color: GinaAppTheme.lightOutline,
                            ),
                          ),
                        ),
                        const Gap(16),
                        ElevatedButton.icon(
                          onPressed: _isDirty
                              ? () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    // Parse values and submit
                                    final paymentWindowMinutes = int.tryParse(
                                            _paymentWindowController.text) ??
                                        60;

                                    context.read<AdminSettingsBloc>().add(
                                          UpdatePaymentValiditySettings(
                                            paymentWindowMinutes:
                                                paymentWindowMinutes,
                                          ),
                                        );
                                  }
                                }
                              : null,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                GinaAppTheme.lightTertiaryContainer,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBackgroundColor: GinaAppTheme
                                .lightTertiaryContainer
                                .withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentSettingsCard(
      PaymentValiditySettingsLoaded state, TextTheme ginaTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GinaAppTheme.lightSurfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GinaAppTheme.lightOutlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Payment Window',
            style: ginaTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          // Display current settings
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: GinaAppTheme.lightOutlineVariant.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GinaAppTheme.lightTertiaryContainer.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.timer,
                    color: GinaAppTheme.lightTertiaryContainer,
                    size: 24,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Window Duration',
                        style: ginaTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.lightOnSurfaceVariant,
                        ),
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          Text(
                            '${state.paymentWindowMinutes} minutes',
                            style: ginaTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GinaAppTheme.lightOnSurface,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            '(${_formatDuration(state.paymentWindowMinutes)})',
                            style: ginaTheme.bodyMedium?.copyWith(
                              color: GinaAppTheme.lightOnSurfaceVariant,
                              fontStyle: FontStyle.italic,
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
        ],
      ),
    );
  }

  Widget _buildPaymentWindowField({
    required BuildContext context,
    required TextEditingController controller,
    required TextTheme ginaTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.timer,
              color: GinaAppTheme.lightTertiaryContainer,
              size: 20,
            ),
            const Gap(8),
            Text(
              'Payment Window (minutes)',
              style: ginaTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: GinaAppTheme.lightOnSurface,
              ),
            ),
          ],
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: 'Enter duration in minutes (e.g. 60)',
            hintStyle: ginaTheme.bodyMedium?.copyWith(color: Colors.grey),
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: GinaAppTheme.lightOutlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: GinaAppTheme.lightOutlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: GinaAppTheme.lightTertiaryContainer,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: GinaAppTheme.lightError),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a duration value';
            }
            final minutes = int.tryParse(value);
            if (minutes == null) {
              return 'Please enter a valid number';
            }
            if (minutes <= 0) {
              return 'Duration must be greater than 0 minutes';
            }
            if (minutes > 1440) {
              return 'Duration cannot exceed 24 hours (1440 minutes)';
            }
            return null;
          },
        ),
        const Gap(4),
        Text(
          'Enter the time window (in minutes) that patients have to complete payment',
          style: ginaTheme.bodySmall?.copyWith(
            color: GinaAppTheme.lightOutline,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildPresetButtons(TextTheme ginaTheme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildPresetButton(
          label: '30 minutes',
          minutes: 30,
          icon: Icons.timer_outlined,
          ginaTheme: ginaTheme,
        ),
        _buildPresetButton(
          label: '1 hour',
          minutes: 60,
          icon: Icons.timer_outlined,
          ginaTheme: ginaTheme,
        ),
        _buildPresetButton(
          label: '2 hours',
          minutes: 120,
          icon: Icons.timer_outlined,
          ginaTheme: ginaTheme,
        ),
        _buildPresetButton(
          label: '4 hours',
          minutes: 240,
          icon: Icons.timer_outlined,
          ginaTheme: ginaTheme,
        ),
        _buildPresetButton(
          label: '8 hours',
          minutes: 480,
          icon: Icons.timer_outlined,
          ginaTheme: ginaTheme,
        ),
        _buildPresetButton(
          label: '12 hours',
          minutes: 720,
          icon: Icons.timer_outlined,
          ginaTheme: ginaTheme,
        ),
        _buildPresetButton(
          label: '24 hours',
          minutes: 1440,
          icon: Icons.timer_outlined,
          ginaTheme: ginaTheme,
        ),
      ],
    );
  }

  Widget _buildPresetButton({
    required String label,
    required int minutes,
    required IconData icon,
    required TextTheme ginaTheme,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        _paymentWindowController.text = minutes.toString();
        setState(() => _isDirty = true);
      },
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: GinaAppTheme.lightSurfaceVariant.withOpacity(0.2),
        foregroundColor: GinaAppTheme.lightSecondary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: GinaAppTheme.lightOutlineVariant.withOpacity(0.5),
          ),
        ),
        textStyle: ginaTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
