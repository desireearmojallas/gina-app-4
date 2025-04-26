import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';

class AppointmentTimeMonitor extends StatefulWidget {
  final Widget child;
  // Default check interval (1 minute)
  final Duration initialCheckInterval;

  const AppointmentTimeMonitor({
    super.key,
    required this.child,
    this.initialCheckInterval = const Duration(minutes: 1),
  });

  // Static method to access this state from anywhere
  static void resetTimerGlobally(BuildContext context, Duration duration) {
    // Find the monitor state in the widget tree
    final AppointmentTimeMonitor? monitor =
        context.findAncestorWidgetOfExactType<AppointmentTimeMonitor>();

    if (monitor != null) {
      final state =
          context.findAncestorStateOfType<_AppointmentTimeMonitorState>();
      state?.resetTimerWithDuration(duration);
    }
  }

  @override
  State<AppointmentTimeMonitor> createState() => _AppointmentTimeMonitorState();
}

class _AppointmentTimeMonitorState extends State<AppointmentTimeMonitor> {
  Timer? _timer;
  Duration _checkInterval = const Duration(minutes: 1);

  // Create a global key to access this state from outside
  static final GlobalKey<_AppointmentTimeMonitorState> monitorKey =
      GlobalKey<_AppointmentTimeMonitorState>();

  @override
  void initState() {
    super.initState();
    _checkInterval = widget.initialCheckInterval;

    // Initial check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExceededAppointments();
    });

    // Set up periodic checking
    _resetTimer();
  }

  void _checkExceededAppointments() {
    if (context.mounted) {
      context
          .read<HomeDashboardBloc>()
          .add(CheckForExceededAppointmentsEvent());
    }
  }

  // Public method to reset timer with a custom interval
  void resetTimerWithDuration(Duration newInterval) {
    _timer?.cancel(); // Cancel existing timer

    setState(() {
      _checkInterval = newInterval;
    });

    _resetTimer(); // Create new timer with updated interval
    debugPrint(
        '🔄 Appointment check timer reset: will check again in ${newInterval.inMinutes} minutes');
  }

  // Private method to handle timer creation
  void _resetTimer() {
    _timer = Timer.periodic(_checkInterval, (_) {
      _checkExceededAppointments();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
