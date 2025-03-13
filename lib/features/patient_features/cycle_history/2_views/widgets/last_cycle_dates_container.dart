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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: cycleHistoryList!.isEmpty
          ? MediaQuery.of(context).size.height * 0.14
          : MediaQuery.of(context).size.height * 0.61,
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
            const Gap(5),
            cycleHistoryList!.isEmpty
                ? Center(
                    child: Text(
                      'No cycle data yet',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: GinaAppTheme.lightOutline),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Your average cycle length: '),
                      Text(
                        averageCycleLengthOfPatient.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
            const Divider(
              thickness: 1,
              color: GinaAppTheme.lightOutline,
            ),
            SizedBox(
              height: cycleHistoryList!.isEmpty
                  ? MediaQuery.of(context).size.height * 0.01
                  : MediaQuery.of(context).size.height * 0.46,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cycleHistoryList!.length,
                itemBuilder: (context, index) {
                  final cycleHistoryDate = cycleHistoryList![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(5),
                      Text(
                        ' ${DateFormat('MMM d').format(cycleHistoryDate.startDate)} - ${DateFormat('MMM d').format(cycleHistoryDate.endDate)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: GinaAppTheme.lightSecondary,
                            ),
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: GinaAppTheme.lightOutline,
                          ),
                          const Gap(5),
                          Text(
                            '${cycleHistoryDate.cycleLength} day cycle',
                          ),
                        ],
                      ),
                      const Gap(5),
                      const Divider(
                        thickness: 0.5,
                        color: GinaAppTheme.lightOutline,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
