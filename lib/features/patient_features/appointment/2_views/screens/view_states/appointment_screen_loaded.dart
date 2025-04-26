import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/view_states/appointments_tab_view.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/swiper_builder.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';
import 'package:intl/intl.dart';

class AppointmentScreenLoaded extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final int initialIndex;
  final List<ChatMessageModel> chatRooms;
  const AppointmentScreenLoaded({
    super.key,
    required this.appointments,
    required this.initialIndex,
    required this.chatRooms,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();

    // Reusable sorting function
    void sortAppointmentsByDate(List<AppointmentModel> appointments) {
      appointments.sort((a, b) {
        final dateFormat = DateFormat('MMMM d, yyyy');
        final timeFormat = DateFormat('hh:mm a');

        // Parse date and time for appointment A
        final dateA = dateFormat.parse(a.appointmentDate!.trim());
        final timeA =
            timeFormat.parse(a.appointmentTime!.split(' - ')[0].trim());
        final dateTimeA = DateTime(
          dateA.year,
          dateA.month,
          dateA.day,
          timeA.hour,
          timeA.minute,
        );

        // Parse date and time for appointment B
        final dateB = dateFormat.parse(b.appointmentDate!.trim());
        final timeB =
            timeFormat.parse(b.appointmentTime!.split(' - ')[0].trim());
        final dateTimeB = DateTime(
          dateB.year,
          dateB.month,
          dateB.day,
          timeB.hour,
          timeB.minute,
        );

        return dateTimeB.compareTo(dateTimeA); // Sort in descending order
      });
    }

    final upcomingAppointments = appointments
        .where((appointment) =>
            appointment.appointmentStatus == AppointmentStatus.confirmed.index)
        .toList();

    final completedAppointments = appointments
        .where((appointment) =>
            appointment.appointmentStatus == AppointmentStatus.completed.index)
        .toList();
    sortAppointmentsByDate(completedAppointments);

    final missedAppointments = appointments
        .where((appointment) =>
            appointment.appointmentStatus == AppointmentStatus.missed.index)
        .toList();
    sortAppointmentsByDate(missedAppointments);

    final cancelledAppointments = appointments
        .where((appointment) =>
            appointment.appointmentStatus == AppointmentStatus.cancelled.index)
        .toList();
    sortAppointmentsByDate(cancelledAppointments);

    final declinedAppointments = appointments
        .where((appointment) =>
            appointment.appointmentStatus == AppointmentStatus.declined.index)
        .toList();
    sortAppointmentsByDate(declinedAppointments);

    final pendingAppointments = appointments
        .where((appointment) =>
            appointment.appointmentStatus == AppointmentStatus.pending.index)
        .toList();
    sortAppointmentsByDate(pendingAppointments);

    final ongoingAppointments = appointments.where((appointment) {
      final String appointmentDateStr = appointment.appointmentDate!.trim();
      final String appointmentTimeStr = appointment.appointmentTime!.trim();
      final int appointmentStatus = appointment.appointmentStatus!;

      final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
      final DateFormat timeFormat = DateFormat('hh:mm a');

      try {
        final List<String> times = appointmentTimeStr.split(' - ');

        if (times.length != 2) {
          throw const FormatException('Invalid time format');
        }

        final DateTime appointmentDate = dateFormat.parse(appointmentDateStr);
        final DateTime startTime = timeFormat.parse(times[0]);
        final DateTime endTime = timeFormat.parse(times[1]);

        // Adjust the parsed time to today's date
        final DateTime appointmentStartDateTime = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          startTime.hour,
          startTime.minute,
        );

        final DateTime appointmentEndDateTime = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          endTime.hour,
          endTime.minute,
        );

        final DateTime now = DateTime.now();

        return appointmentStatus == AppointmentStatus.confirmed.index &&
            appointmentDate
                .isAtSameMomentAs(DateTime(now.year, now.month, now.day)) &&
            now.isAfter(appointmentStartDateTime) &&
            now.isBefore(appointmentEndDateTime);
      } catch (e) {
        // Handle the parsing error
        debugPrint('Error parsing date: $e');
        return false;
      }
    }).toList();
    sortAppointmentsByDate(ongoingAppointments);

    return RefreshIndicator(
      onRefresh: () async {
        appointmentBloc.add(GetAppointmentsEvent());
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ScrollbarCustom(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _title(context, 'Upcoming appointments'),
                    const Gap(10),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: upcomingAppointments.isEmpty
                            ? Colors.grey[300]
                            : GinaAppTheme.lightTertiaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          upcomingAppointments.isEmpty
                              ? '0'
                              : upcomingAppointments.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(17),
                SwiperBuilderWidget(
                  upcomingAppointments: upcomingAppointments,
                ),
                GinaDivider(),
                SizedBox(
                  height: 500,
                  child: AppointmentsTabView(
                    missedAppointments: missedAppointments,
                    completedAppointments: completedAppointments,
                    cancelledAppointments: cancelledAppointments,
                    declinedAppointments: declinedAppointments,
                    pendingAppointments: pendingAppointments,
                    ongoingAppointments: ongoingAppointments,
                    initialIndex: initialIndex,
                    chatRooms: chatRooms,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
      textAlign: TextAlign.left,
    );
  }
}
