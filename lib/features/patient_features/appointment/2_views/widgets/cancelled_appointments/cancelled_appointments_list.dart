import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/cancelled_appointments/cancelled_appointments_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class CancelledAppointmentsList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  const CancelledAppointmentsList({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    final Map<int, List<AppointmentModel>> groupedAppointmentsByYear = {};
    for (var appointment in appointments) {
      final date =
          DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
      final year = date.year;
      if (!groupedAppointmentsByYear.containsKey(year)) {
        groupedAppointmentsByYear[year] = [];
      }
      groupedAppointmentsByYear[year]!.add(appointment);
    }

    final sortedYears = groupedAppointmentsByYear.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    for (var year in sortedYears) {
      groupedAppointmentsByYear[year]!.sort((a, b) {
        final dateA = DateFormat('MMMM d, yyyy').parse(a.appointmentDate!);
        final dateB = DateFormat('MMMM d, yyyy').parse(b.appointmentDate!);
        final monthA = dateA.month == 12 ? 0 : dateA.month;
        final monthB = dateB.month == 12 ? 0 : dateB.month;
        return monthA.compareTo(monthB);
      });
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: _title(context, 'Cancelled Appointments'),
          ),
          if (appointments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No cancelled appointments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GinaAppTheme.lightOutline.withOpacity(0.4),
                      ),
                ),
              ),
            )
          else
            ...sortedYears.map(
              (year) {
                final yearAppointments = groupedAppointmentsByYear[year]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Text(
                        year.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GinaAppTheme.lightOutline.withOpacity(0.4),
                            ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: yearAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = yearAppointments[index];
                        return CancelledAppointmentsContainer(
                          appointment: appointment,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          const Gap(60),
        ],
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
      textAlign: TextAlign.left,
    );
  }
}
