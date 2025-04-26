// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/2_views/bloc/admin_settings_bloc.dart';
import 'package:intl/intl.dart';

class UserManagementWidget extends StatelessWidget {
  const UserManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
      builder: (context, state) {
        // Initialize the bloc when first building
        if (state is AdminSettingsInitial) {
          context
              .read<AdminSettingsBloc>()
              .add(const LoadUsers(userType: 'Patients'));
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }

        return const UserManagementContent();
      },
    );
  }
}

class UserManagementContent extends StatefulWidget {
  const UserManagementContent({super.key});

  @override
  State<UserManagementContent> createState() => _UserManagementContentState();
}

class _UserManagementContentState extends State<UserManagementContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final bloc = context.read<AdminSettingsBloc>();
    final state = bloc.state;

    if (state is AdminSettingsLoaded) {
      bloc.add(SearchUsers(
        userType: state.userType,
        query: _searchController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return BlocListener<AdminSettingsBloc, AdminSettingsState>(
      listenWhen: (previous, current) => current is AdminSettingsError,
      listener: (context, state) {
        if (state is AdminSettingsError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const Gap(16),
                  Expanded(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.white))),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: FadeTransition(
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
                'User Management',
                style: ginaTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: GinaAppTheme.lightOnSurface,
                ),
              ),

              const Gap(8),

              Text(
                'View, search, and manage all patients and doctors in the system',
                style: ginaTheme.bodyMedium?.copyWith(
                  color: GinaAppTheme.lightOnSurfaceVariant,
                ),
              ),

              const Gap(24),

              // Search and filter bar
              Material(
                elevation: 2,
                shadowColor: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Search bar
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search users by name',
                            hintStyle: ginaTheme.bodyMedium
                                ?.copyWith(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search,
                                color: GinaAppTheme.lightTertiaryContainer),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: GinaAppTheme.lightOutlineVariant),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: GinaAppTheme.lightOutlineVariant),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: GinaAppTheme.lightTertiaryContainer,
                                  width: 2),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const Gap(16),

                      // User type selector
                      BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
                        builder: (context, state) {
                          final String selectedType =
                              state is AdminSettingsLoaded
                                  ? state.userType
                                  : 'Patients';

                          return Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text(
                                  'Filter by:',
                                  style: ginaTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: GinaAppTheme.lightOnSurface,
                                  ),
                                ),
                                const Gap(16),
                                _buildFilterChip(
                                  label: 'Patients',
                                  isSelected: selectedType == 'Patients',
                                  onSelected: (selected) {
                                    if (selected) {
                                      _animationController.reset();
                                      _animationController.forward();
                                      context.read<AdminSettingsBloc>().add(
                                            const SwitchUserType(
                                                userType: 'Patients'),
                                          );
                                    }
                                  },
                                  ginaTheme: ginaTheme,
                                ),
                                const Gap(8),
                                _buildFilterChip(
                                  label: 'Doctors',
                                  isSelected: selectedType == 'Doctors',
                                  onSelected: (selected) {
                                    if (selected) {
                                      _animationController.reset();
                                      _animationController.forward();
                                      context.read<AdminSettingsBloc>().add(
                                            const SwitchUserType(
                                                userType: 'Doctors'),
                                          );
                                    }
                                  },
                                  ginaTheme: ginaTheme,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(24),

              // Column headers
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: GinaAppTheme.lightSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Gap(56),
                    SizedBox(
                      width: size.width * 0.15,
                      child: Text(
                        'NAME',
                        style: ginaTheme.labelSmall?.copyWith(
                          color: GinaAppTheme.lightOnSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.18,
                      child: Text(
                        'EMAIL',
                        style: ginaTheme.labelSmall?.copyWith(
                          color: GinaAppTheme.lightOnSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.15,
                      child: Text(
                        'TYPE',
                        style: ginaTheme.labelSmall?.copyWith(
                          color: GinaAppTheme.lightOnSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.15,
                      child: Text(
                        'SIGN-UP DATE',
                        style: ginaTheme.labelSmall?.copyWith(
                          color: GinaAppTheme.lightOnSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 48, // For delete button
                    ),
                  ],
                ),
              ),

              // User list
              Expanded(
                child: BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
                  builder: (context, state) {
                    if (state is AdminSettingsLoading) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CustomLoadingIndicator(),
                            const Gap(16),
                            Text(
                              'Loading users...',
                              style: ginaTheme.bodyMedium?.copyWith(
                                color: GinaAppTheme.lightOnSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is AdminSettingsError) {
                      return _buildErrorState(
                          context, ginaTheme, state.message);
                    } else if (state is AdminSettingsLoaded) {
                      final users = state.users;

                      if (users.isEmpty) {
                        return _buildEmptyState(ginaTheme);
                      }

                      return _buildUserList(users, ginaTheme, size);
                    }
                    return const Center(child: Text('Something went wrong'));
                  },
                ),
              ),

              // Bottom row with counts
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
                  builder: (context, state) {
                    if (state is AdminSettingsLoaded) {
                      final userCount = state.users.length;
                      final userType = state.userType;

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: GinaAppTheme.lightPrimaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Total $userType: $userCount',
                              style: ginaTheme.labelSmall?.copyWith(
                                color: GinaAppTheme.lightOnPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (_searchController.text.isNotEmpty)
                            TextButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                context.read<AdminSettingsBloc>().add(
                                      LoadUsers(userType: userType),
                                    );
                              },
                              icon: const Icon(Icons.clear, size: 18),
                              label: const Text('Clear Search'),
                              style: TextButton.styleFrom(
                                foregroundColor: GinaAppTheme.lightPrimaryColor,
                              ),
                            ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
    required TextTheme ginaTheme,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        selectedColor: GinaAppTheme.lightTertiaryContainer,
        backgroundColor: Colors.white,
        labelStyle: ginaTheme.labelMedium?.copyWith(
          color: isSelected
              ? GinaAppTheme.lightOnTertiaryContainer
              : GinaAppTheme.lightOnSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? GinaAppTheme.lightTertiaryContainer
                : GinaAppTheme.lightOutlineVariant,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, TextTheme ginaTheme, String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: GinaAppTheme.lightErrorContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GinaAppTheme.lightErrorContainer),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: GinaAppTheme.lightError,
              size: 64,
            ),
            const Gap(16),
            Text(
              'Error Loading Users',
              style: ginaTheme.titleMedium?.copyWith(
                color: GinaAppTheme.lightError,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              message,
              style: ginaTheme.bodyMedium?.copyWith(
                color: GinaAppTheme.lightOnErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<AdminSettingsBloc>()
                    .add(const LoadUsers(userType: 'Patients'));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: GinaAppTheme.lightPrimaryContainer,
                foregroundColor: GinaAppTheme.lightOnPrimaryContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(TextTheme ginaTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: GinaAppTheme.lightSurfaceVariant.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_outline,
              color: GinaAppTheme.lightPrimaryColor,
              size: 64,
            ),
          ),
          const Gap(16),
          Text(
            'No users found',
            style: ginaTheme.titleMedium?.copyWith(
              color: GinaAppTheme.lightOnSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          if (_searchController.text.isNotEmpty)
            Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GinaAppTheme.lightSurfaceVariant.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'No results for "${_searchController.text}"',
                    style: ginaTheme.bodyMedium?.copyWith(
                      color: GinaAppTheme.lightOnSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    'Try using different keywords or clear your search',
                    style: ginaTheme.bodySmall?.copyWith(
                      color:
                          GinaAppTheme.lightOnSurfaceVariant.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserList(
    List<Map<String, dynamic>> users,
    TextTheme ginaTheme,
    Size size,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final displayName =
            user['type'] == 'Doctor' ? 'Dr. ${user['name']}' : user['name'];
        final createdDate = user['created'] != null
            ? DateFormat('MMMM d, yyyy').format(
                (user['created'] as Timestamp).toDate().toLocal(),
              )
            : 'N/A';

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: GinaAppTheme.lightOutlineVariant.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                // Optionally add detailed view navigation
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
                child: Row(
                  children: [
                    // Profile image
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                GinaAppTheme.lightPrimaryColor.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: GinaAppTheme.lightTertiaryContainer,
                        foregroundImage: AssetImage(
                          user['type'] == 'Doctor'
                              ? Images.doctorProfileIcon1
                              : Images.patientProfileIcon,
                        ),
                      ),
                    ),

                    // Name
                    SizedBox(
                      width: size.width * 0.15,
                      child: Text(
                        displayName,
                        style: ginaTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GinaAppTheme.lightOnSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Email
                    SizedBox(
                      width: size.width * 0.15,
                      child: Text(
                        user['email'] ?? 'N/A',
                        style: ginaTheme.labelMedium?.copyWith(
                          color: GinaAppTheme.lightOnSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
// User Type
                    SizedBox(
                      width: size.width * 0.12,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              GinaAppTheme.lightSecondaryContainer
                                  .withOpacity(0.2),
                              GinaAppTheme.lightSecondaryContainer
                                  .withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: GinaAppTheme.lightSecondary.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  GinaAppTheme.lightSecondary.withOpacity(0.05),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 8.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              user['type'] == 'Doctor'
                                  ? Icons.medical_services_rounded
                                  : Icons.person_rounded,
                              size: 14,
                              color: GinaAppTheme.lightSecondary,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                user['type'],
                                style: ginaTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: GinaAppTheme.lightSecondary,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Gap(110),

                    // Created Date
                    SizedBox(
                      width: size.width * 0.15,
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: GinaAppTheme.lightOnSurfaceVariant
                                .withOpacity(0.6),
                          ),
                          const Gap(4),
                          Expanded(
                            child: Text(
                              createdDate,
                              style: ginaTheme.labelMedium?.copyWith(
                                color: GinaAppTheme.lightOnSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // View details button
                        IconButton(
                          icon: const Icon(
                            Icons.visibility_outlined,
                            color: GinaAppTheme.lightTertiaryContainer,
                            size: 20,
                          ),
                          onPressed: () {
                            // View user details
                          },
                          tooltip: 'View details',
                          style: IconButton.styleFrom(
                            backgroundColor: GinaAppTheme.lightPrimaryColor
                                .withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const Gap(8),
                        // Delete button
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: GinaAppTheme.lightError,
                            size: 20,
                          ),
                          onPressed: () =>
                              _showDeleteConfirmation(context, user),
                          tooltip: 'Delete user',
                          style: IconButton.styleFrom(
                            backgroundColor:
                                GinaAppTheme.lightError.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> user) async {
    final ginaTheme = Theme.of(context).textTheme;

    final bloc = context.read<AdminSettingsBloc>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 5,
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber,
              size: 28,
            ),
            const Gap(12),
            Text(
              'Delete User',
              style: ginaTheme.titleLarge?.copyWith(
                color: GinaAppTheme.lightOnSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GinaAppTheme.lightErrorContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: GinaAppTheme.lightErrorContainer.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    foregroundImage: AssetImage(
                      user['type'] == 'Doctor'
                          ? Images.doctorProfileIcon1
                          : Images.patientProfileIcon,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] ?? 'Unknown User',
                          style: ginaTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user['email'] ?? 'No email provided',
                          style: ginaTheme.bodySmall?.copyWith(
                            color: GinaAppTheme.lightOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Text(
              'Are you sure you want to delete this user?',
              style: ginaTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            Text(
              'This will permanently remove the user from Firestore. This action cannot be undone.',
              style: ginaTheme.bodyMedium?.copyWith(
                color: GinaAppTheme.lightOnSurfaceVariant,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: GinaAppTheme.lightOnSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancel',
              style: ginaTheme.labelLarge,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: GinaAppTheme.lightError,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
    );

    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CustomLoadingIndicator(
                  colors: [Colors.white],
                ),
              ),
              Gap(16),
              Text('Removing user from database...',
                  style: TextStyle(color: Colors.white)), // Updated text
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      final currentState = bloc.state;
      final userType = currentState is AdminSettingsLoaded
          ? currentState.userType
          : user['type'];

      // Dispatch optimistic delete first
      bloc.add(OptimisticDeleteUser(userId: user['id']));

      // Then perform the actual deletion
      bloc.add(DeleteUser(userId: user['id'], userType: user['type']));

      // Show success message after a short delay to allow the optimistic update to complete
      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                Gap(16),
                Text('User removed from database successfully'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
  }
}
