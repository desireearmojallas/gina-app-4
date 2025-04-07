import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:intl/intl.dart';

class MenstrualCycleInformationPatientData extends StatelessWidget {
  final List<PeriodTrackerModel> patientPeriods;
  const MenstrualCycleInformationPatientData({
    super.key,
    required this.patientPeriods,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Create a reversed copy of the periods list to show latest first
    final reversedPeriods = patientPeriods.isEmpty
        ? <PeriodTrackerModel>[]
        : List<PeriodTrackerModel>.from(patientPeriods)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    // Group periods by year
    final periodsByYear = <int, List<PeriodTrackerModel>>{};
    for (var period in reversedPeriods) {
      final year = period.startDate.year;
      if (!periodsByYear.containsKey(year)) {
        periodsByYear[year] = [];
      }
      periodsByYear[year]!.add(period);
    }

    // Sort years in descending order (latest first)
    final years = periodsByYear.keys.toList()..sort((a, b) => b.compareTo(a));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        width: size.width / 1.08,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: reversedPeriods.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No cycle data',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: GinaAppTheme.lightOutline),
                  ),
                ),
              )
            : Column(
                children: [
                  // Display periods grouped by year
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
                    for (int i = 0; i < periodsByYear[year]!.length; i++) ...[
                      Builder(
                        builder: (context) {
                          final period = periodsByYear[year]![i];
                          final startDate =
                              DateFormat('MMM d').format(period.startDate);
                          final endDate =
                              DateFormat('MMM d').format(period.endDate);
                          final cycleDays = period.cycleLength;

                          // Check if this is the earliest log overall
                          final isEarliestLog = (year == years.last &&
                              i == periodsByYear[year]!.length - 1);

                          // Check if this is the latest log overall
                          final isLatestLog = (year == years.first && i == 0);

                          // Check if this is the last item in the current year group
                          final isLastInYear =
                              i == periodsByYear[year]!.length - 1;

                          return menstrualCycleInformationWidget(
                            context,
                            startDate: startDate,
                            endDate: endDate,
                            cycleDays: cycleDays,
                            isLatestLog: isLatestLog,
                            isEarliestLog: isEarliestLog,
                            isLastInYear: isLastInYear,
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

  Widget menstrualCycleInformationWidget(
    BuildContext context, {
    required String startDate,
    required String endDate,
    required int cycleDays,
    required bool isLatestLog,
    required bool isEarliestLog,
    required bool isLastInYear,
  }) {
    final ginaTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final divider = Column(
      children: [
        const Gap(10),
        SizedBox(
          width: size.width / 1.15,
          child: const Divider(
            thickness: 0.5,
            color: GinaAppTheme.lightSurfaceVariant,
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$startDate - $endDate',
                style: ginaTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: GinaAppTheme.lightTertiaryContainer,
                ),
              ),
              if (isLatestLog)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color:
                          GinaAppTheme.lightPrimaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Latest',
                      style: ginaTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: GinaAppTheme.lightTertiaryContainer,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Gap(5),
          // Only show cycle days for periods that aren't the earliest log
          if (!isEarliestLog && cycleDays > 0)
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: GinaAppTheme.cancelledTextColor,
                ),
                const Gap(10),
                Text(
                  '$cycleDays day cycle',
                  style: ginaTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: GinaAppTheme.cancelledTextColor,
                  ),
                ),
              ],
            ),
          isLastInYear ? const Gap(25) : divider,
        ],
      ),
    );
  }
}
