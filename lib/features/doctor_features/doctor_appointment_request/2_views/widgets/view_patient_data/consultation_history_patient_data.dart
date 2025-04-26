import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/completed_appointments/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class ConsultationHistoryPatientData extends StatelessWidget {
  final List<AppointmentModel> completedAppointments;
  const ConsultationHistoryPatientData({
    super.key,
    required this.completedAppointments,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Sort appointments by date (most recent first)
    final sortedAppointments =
        List<AppointmentModel>.from(completedAppointments)
          ..sort((a, b) {
            DateTime dateA = _parseAppointmentDate(a.appointmentDate ?? '');
            DateTime dateB = _parseAppointmentDate(b.appointmentDate ?? '');
            return dateB.compareTo(dateA); // Descending order (newest first)
          });

    // Group appointments by year
    final appointmentsByYear = <int, List<AppointmentModel>>{};
    for (var appointment in sortedAppointments) {
      final year = _parseAppointmentDate(appointment.appointmentDate!).year;
      if (!appointmentsByYear.containsKey(year)) {
        appointmentsByYear[year] = [];
      }
      appointmentsByYear[year]!.add(appointment);
    }

    // Sort years in descending order (latest first)
    final years = appointmentsByYear.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: Container(
        width: size.width / 1.08,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: completedAppointments.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No consultation history',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: GinaAppTheme.lightOutline),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display appointments grouped by year
                  for (final year in years) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          year.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    GinaAppTheme.lightOutline.withOpacity(0.4),
                              ),
                        ),
                      ),
                    ),
                    for (int i = 0;
                        i < appointmentsByYear[year]!.length;
                        i++) ...[
                      Builder(
                        builder: (context) {
                          final appointment = appointmentsByYear[year]![i];
                          final isLatestAppointment =
                              (year == years.first && i == 0);

                          return Column(
                            children: [
                              AppointmentConsultationHistoryContainer(
                                appointment: appointment,
                                isDoctor: true,
                                isLatest: isLatestAppointment,
                              ),
                              // Add a gap after the last item in each year group
                              if (i == appointmentsByYear[year]!.length - 1 &&
                                  year != years.last)
                                const Gap(10),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ],
              ),
      ),
    );
  }

  // Helper method to parse appointment date strings
  DateTime _parseAppointmentDate(String dateStr) {
    try {
      // Try different date formats
      List<String> formats = ["MMMM d, yyyy", "MMM d, yyyy", "yyyy-MM-dd"];

      for (var format in formats) {
        try {
          return DateFormat(format).parse(dateStr);
        } catch (e) {
          // Try next format
          continue;
        }
      }

      // If none of the formats work, use a fallback
      final parts = dateStr.split(RegExp(r'[, ]'));
      if (parts.length >= 3) {
        // Try to extract month, day, year from parts
        final month = _getMonthNumber(parts[0]);
        final day = int.tryParse(parts[1].replaceAll(',', '')) ?? 1;
        final year = int.tryParse(parts[2]) ?? DateTime.now().year;
        return DateTime(year, month, day);
      }

      // If all else fails, return current date
      return DateTime.now();
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return DateTime.now(); // Fallback to current date
    }
  }

  // Helper to convert month name to number
  int _getMonthNumber(String monthName) {
    const months = {
      'january': 1,
      'jan': 1,
      'february': 2,
      'feb': 2,
      'march': 3,
      'mar': 3,
      'april': 4,
      'apr': 4,
      'may': 5,
      'june': 6,
      'jun': 6,
      'july': 7,
      'jul': 7,
      'august': 8,
      'aug': 8,
      'september': 9,
      'sep': 9,
      'sept': 9,
      'october': 10,
      'oct': 10,
      'november': 11,
      'nov': 11,
      'december': 12,
      'dec': 12,
    };

    return months[monthName.toLowerCase()] ?? 1;
  }
}
