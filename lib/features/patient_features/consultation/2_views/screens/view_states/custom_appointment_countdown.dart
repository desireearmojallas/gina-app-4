import 'dart:async';
import 'package:flip_board/flip_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class AppointmentCountdown extends StatefulWidget {
  final AppointmentModel appointment;
  final VoidCallback onCountdownComplete;

  const AppointmentCountdown({
    super.key,
    required this.appointment,
    required this.onCountdownComplete,
  });

  @override
  State<AppointmentCountdown> createState() => _AppointmentCountdownState();
}

class _AppointmentCountdownState extends State<AppointmentCountdown> {
  late Timer timer;
  late StreamController<Map<String, int>> _countdownStreamController;
  bool _countdownCompleteCalled = false;

  Duration remainingTime = Duration.zero;
  Duration totalTime = Duration.zero;

  @override
  void initState() {
    super.initState();

    _countdownStreamController = StreamController<Map<String, int>>.broadcast();
    calculateRemainingTime();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      calculateRemainingTime();
    });
  }

  void calculateRemainingTime() {
    String? date = widget.appointment.appointmentDate;
    String time = widget.appointment.appointmentTime!.split(' - ')[0];
    DateTime appointmentDateTime = parseAppointment(date!, time);

    remainingTime = appointmentDateTime.difference(DateTime.now());
    totalTime =
        appointmentDateTime.difference(DateTime.now().subtract(remainingTime));

    if (remainingTime.isNegative) {
      timer.cancel();
      if (!_countdownCompleteCalled) {
        _countdownCompleteCalled = true;
        widget.onCountdownComplete();
      }
      remainingTime = Duration.zero;
    } else if (remainingTime <= const Duration(minutes: 15) &&
        !_countdownCompleteCalled) {
      _countdownCompleteCalled = true;
      widget.onCountdownComplete();
    }

    _countdownStreamController.add({
      'days': remainingTime.inDays,
      'hours': remainingTime.inHours.remainder(24),
      'minutes': remainingTime.inMinutes.remainder(60),
      'seconds': remainingTime.inSeconds.remainder(60),
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1.0 - (remainingTime.inSeconds / totalTime.inSeconds);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   width: size.width * 0.85,
          //   child: LinearProgressIndicator(
          //     value: progress,
          //     backgroundColor: Colors.grey[300],
          //     color: GinaAppTheme.lightSecondary,
          //     borderRadius: BorderRadius.circular(8.0),
          //     minHeight: 8.0,
          //   ),
          // ),
          // const Gap(16),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CountdownUnitDisplay(
                  stream: _countdownStreamController.stream
                      .map((data) => data['days'] ?? 0),
                  label: "Days",
                ),
                const Gap(12),
                CountdownUnitDisplay(
                  stream: _countdownStreamController.stream
                      .map((data) => data['hours'] ?? 0),
                  label: "Hours",
                ),
                const Gap(12),
                CountdownUnitDisplay(
                  stream: _countdownStreamController.stream
                      .map((data) => data['minutes'] ?? 0),
                  label: "Minutes",
                ),
                const Gap(12),
                CountdownUnitDisplay(
                  stream: _countdownStreamController.stream
                      .map((data) => data['seconds'] ?? 0),
                  label: "Seconds",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _countdownStreamController.close();
    timer.cancel();
    super.dispose();
  }

  DateTime parseAppointment(String date, String time) {
    String fullDateTime = '$date $time';
    DateFormat format = DateFormat('MMMM d, yyyy h:mm a');
    return format.parse(fullDateTime);
  }
}

class CountdownUnitDisplay extends StatelessWidget {
  final Stream<int> stream;
  final String label;

  const CountdownUnitDisplay({
    super.key,
    required this.stream,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<int>(
          stream: stream,
          initialData: 0,
          builder: (context, snapshot) {
            return FlipWidget(
              flipType: FlipType.middleFlip,
              itemStream: stream,
              itemBuilder: (context, value) {
                return Container(
                  alignment: Alignment.center,
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.transparent, width: 2),
                  ),
                  child: Text(
                    value == null ? '00' : value.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.bold,
                      color: GinaAppTheme.lightSecondary,
                    ),
                  ),
                );
              },
              flipDirection: AxisDirection.down,
              hingeColor: GinaAppTheme.lightSecondary,
              hingeWidth: 0.9,
              hingeLength: 0.9,
            );
          },
        ),
        const Gap(6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: GinaAppTheme.lightOutline,
          ),
        ),
      ],
    );
  }
}
