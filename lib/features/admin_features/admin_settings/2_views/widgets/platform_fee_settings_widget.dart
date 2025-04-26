import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/2_views/bloc/admin_settings_bloc.dart';

class PlatformFeeSettingsWidget extends StatelessWidget {
  const PlatformFeeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // No need to create a new bloc instance here, we'll use the existing one
    // and dispatch an event to load platform fees when the widget is built
    context.read<AdminSettingsBloc>().add(const LoadPlatformFees());
    return const _PlatformFeeSettingsContent();
  }
}

class _PlatformFeeSettingsContent extends StatefulWidget {
  const _PlatformFeeSettingsContent();

  @override
  State<_PlatformFeeSettingsContent> createState() =>
      _PlatformFeeSettingsContentState();
}

class _PlatformFeeSettingsContentState
    extends State<_PlatformFeeSettingsContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _onlineFeeController = TextEditingController();
  final TextEditingController _f2fFeeController = TextEditingController();

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

    _onlineFeeController.addListener(_onFieldChanged);
    _f2fFeeController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    // Mark form as dirty if any changes are made
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  @override
  void dispose() {
    _onlineFeeController.dispose();
    _f2fFeeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return BlocConsumer<AdminSettingsBloc, AdminSettingsState>(
      listenWhen: (previous, current) =>
          current is AdminSettingsError || current is PlatformFeesUpdated,
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
        } else if (state is PlatformFeesUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  Gap(16),
                  Text('Platform fees updated successfully',
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
        if (state is PlatformFeesLoaded && _onlineFeeController.text.isEmpty) {
          _onlineFeeController.text =
              (state.onlinePercentage * 100).toStringAsFixed(2);
          _f2fFeeController.text =
              (state.f2fPercentage * 100).toStringAsFixed(2);
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
                  'Platform Fee Settings',
                  style: ginaTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GinaAppTheme.lightOnSurface,
                  ),
                ),

                const Gap(8),

                Text(
                  'Set the platform fee percentage for online and face-to-face appointments',
                  style: ginaTheme.bodyMedium?.copyWith(
                    color: GinaAppTheme.lightOnSurfaceVariant,
                  ),
                ),

                const Gap(24),

                // Info banner explaining platform fees
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
                        color: GinaAppTheme.lightTertiary,
                        size: 24,
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About Platform Fees',
                              style: ginaTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: GinaAppTheme.lightOnSurface,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'Platform fees are automatically collected by GINA on each appointment booking. The percentage is applied to the total appointment fee set by the doctor.',
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
                          Text('Loading platform fee settings...'),
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
                            if (state is PlatformFeesLoaded)
                              _buildCurrentSettingsCard(state, ginaTheme),

                            const Gap(32),

                            // Platform fee input fields
                            Text(
                              'Fee Percentages',
                              style: ginaTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: GinaAppTheme.lightOnSurface,
                              ),
                            ),

                            const Gap(16),

                            // Online appointments fee
                            _buildFeeInputField(
                              context: context,
                              controller: _onlineFeeController,
                              label: 'Online Appointment Fee (%)',
                              hint: 'Enter percentage (e.g. 10.00)',
                              icon: Icons.videocam_outlined,
                              iconColor: GinaAppTheme.lightTertiaryContainer,
                              ginaTheme: ginaTheme,
                            ),

                            const Gap(24),

                            // F2F appointments fee
                            _buildFeeInputField(
                              context: context,
                              controller: _f2fFeeController,
                              label: 'Face-to-Face Appointment Fee (%)',
                              hint: 'Enter percentage (e.g. 15.00)',
                              icon: Icons.people_outline,
                              iconColor: GinaAppTheme.lightSecondary,
                              ginaTheme: ginaTheme,
                            ),
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
                                  if (state is PlatformFeesLoaded) {
                                    _onlineFeeController.text =
                                        (state.onlinePercentage * 100)
                                            .toStringAsFixed(2);
                                    _f2fFeeController.text =
                                        (state.f2fPercentage * 100)
                                            .toStringAsFixed(2);
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
                                    final onlinePercentage = double.tryParse(
                                            _onlineFeeController.text) ??
                                        0;
                                    final f2fPercentage = double.tryParse(
                                            _f2fFeeController.text) ??
                                        0;

                                    context.read<AdminSettingsBloc>().add(
                                          UpdatePlatformFees(
                                            onlinePercentage:
                                                onlinePercentage / 100,
                                            f2fPercentage: f2fPercentage / 100,
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
      PlatformFeesLoaded state, TextTheme ginaTheme) {
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
            'Current Platform Fees',
            style: ginaTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          // Display current settings
          Row(
            children: [
              Expanded(
                child: _buildCurrentFeeTile(
                  context: context,
                  icon: Icons.videocam_outlined,
                  iconColor: GinaAppTheme.lightTertiaryContainer,
                  title: 'Online Appointments',
                  percentage: state.onlinePercentage * 100,
                  ginaTheme: ginaTheme,
                ),
              ),
              const Gap(16),
              Expanded(
                child: _buildCurrentFeeTile(
                  context: context,
                  icon: Icons.people_outline,
                  iconColor: GinaAppTheme.lightSecondary,
                  title: 'Face-to-Face Appointments',
                  percentage: state.f2fPercentage * 100,
                  ginaTheme: ginaTheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentFeeTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required double percentage,
    required TextTheme ginaTheme,
  }) {
    return Container(
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
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ginaTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.lightOnSurfaceVariant,
                  ),
                ),
                const Gap(4),
                Text(
                  '${percentage.toStringAsFixed(2)}%',
                  style: ginaTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GinaAppTheme.lightOnSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required TextTheme ginaTheme,
  }) {
    // Remove the const keyword to allow dynamic content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            const Gap(8),
            Text(
              label,
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
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: ginaTheme.bodyMedium?.copyWith(color: Colors.grey),
            suffixIcon: const Icon(Icons.percent),
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
              borderSide: BorderSide(
                color: iconColor,
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
              return 'Please enter a percentage value';
            }
            final percentage = double.tryParse(value);
            if (percentage == null) {
              return 'Please enter a valid number';
            }
            if (percentage <= 0) {
              return 'Percentage must be greater than 0';
            }
            if (percentage > 100) {
              return 'Percentage cannot exceed 100%';
            }
            return null;
          },
        ),
        const Gap(4),
        Text(
          'Enter the percentage value without the % symbol',
          style: ginaTheme.bodySmall?.copyWith(
            color: GinaAppTheme.lightOutline,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
