import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:intl/intl.dart';

class LastCycleDatesContainer extends StatelessWidget {
  final List<PeriodTrackerModel>? cycleHistoryList;
  final int? averageCycleLengthOfPatient;
  const LastCycleDatesContainer({
    super.key,
    required this.cycleHistoryList,
    required this.averageCycleLengthOfPatient,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('cycleHistoryList: $cycleHistoryList');

    // Create a reversed copy of the periods list to show latest first
    final sortedCycleList = cycleHistoryList == null ||
            cycleHistoryList!.isEmpty
        ? <PeriodTrackerModel>[]
        : List<PeriodTrackerModel>.from(cycleHistoryList!)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    // Group periods by year
    final cyclesByYear = <int, List<PeriodTrackerModel>>{};
    for (var cycle in sortedCycleList) {
      final year = cycle.startDate.year;
      if (!cyclesByYear.containsKey(year)) {
        cyclesByYear[year] = [];
      }
      cyclesByYear[year]!.add(cycle);
    }

    // Sort years in descending order (latest first)
    final years = cyclesByYear.keys.toList()..sort((a, b) => b.compareTo(a));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width * 1,
      height: cycleHistoryList == null || cycleHistoryList!.isEmpty
          ? MediaQuery.of(context).size.height * 0.14
          : null, // Allow height to adjust based on content
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your last cycle dates',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Gap(15),
            cycleHistoryList == null || cycleHistoryList!.isEmpty
                ? Center(
                    child: Text(
                      'No cycle data yet',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: GinaAppTheme.lightOutline),
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Your average cycle length: '),
                          Text(
                            averageCycleLengthOfPatient.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      const Divider(
                        thickness: 1,
                        color: GinaAppTheme.lightOutline,
                      ),
                      const Gap(10),
                      LimitedBox(
                        maxHeight: MediaQuery.of(context).size.height * 0.46,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Display periods grouped by year
                              for (final year in years) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      year.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: GinaAppTheme.lightOutline
                                                .withOpacity(0.4),
                                          ),
                                    ),
                                  ),
                                ),
                                for (int i = 0;
                                    i < cyclesByYear[year]!.length;
                                    i++) ...[
                                  Builder(
                                    builder: (context) {
                                      final cycle = cyclesByYear[year]![i];
                                      final startDate = DateFormat('MMM d')
                                          .format(cycle.startDate);
                                      final endDate = DateFormat('MMM d')
                                          .format(cycle.endDate);
                                      final cycleDays = cycle.cycleLength;

                                      // Check if this is the earliest log overall
                                      final isEarliestLog = (year ==
                                              years.last &&
                                          i == cyclesByYear[year]!.length - 1);

                                      // Check if this is the latest log overall
                                      final isLatestLog =
                                          (year == years.first && i == 0);

                                      // Check if this is the last item in the current year group
                                      final isLastInYear =
                                          i == cyclesByYear[year]!.length - 1;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                ' $startDate - $endDate',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: GinaAppTheme
                                                          .lightSecondary,
                                                    ),
                                              ),
                                              if (isLatestLog)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: GinaAppTheme
                                                          .lightPrimaryContainer
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      'Latest',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: GinaAppTheme
                                                                .lightSecondary,
                                                            fontSize: 10,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const Gap(10),
                                          if (!isEarliestLog && cycleDays > 0)
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 18,
                                                  color:
                                                      GinaAppTheme.lightOutline,
                                                ),
                                                const Gap(5),
                                                Text(
                                                  '$cycleDays day cycle',
                                                ),
                                              ],
                                            ),
                                          const Gap(5),
                                          isLastInYear
                                              ? const Gap(15)
                                              : const Divider(
                                                  thickness: 0.5,
                                                  color:
                                                      GinaAppTheme.lightOutline,
                                                ),
                                          isLastInYear && year != years.last
                                              ? const Gap(5)
                                              : const SizedBox.shrink(),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
