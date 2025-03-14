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
        child: patientPeriods.isEmpty
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
                  const Gap(20),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: patientPeriods.length,
                    itemBuilder: (context, index) {
                      final period = patientPeriods[index];
                      final startDate =
                          DateFormat('MMM d').format(period.startDate);
                      final endDate =
                          DateFormat('MMM d').format(period.endDate);
                      final cycleDays = period.cycleLength;
                      final isLastItem = index == patientPeriods.length - 1;

                      return menstrualCycleInformationWidget(
                        context,
                        startDate: startDate,
                        endDate: endDate,
                        cycleDays: cycleDays,
                        isFirstLog: index == 0,
                        isLastItem: isLastItem,
                      );
                    },
                  ),
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
    required bool isFirstLog,
    required bool isLastItem,
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
          Text(
            '$startDate - $endDate',
            style: ginaTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: GinaAppTheme.lightTertiaryContainer,
            ),
          ),
          const Gap(5),
          if (!isFirstLog)
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
          isLastItem ? const Gap(25) : divider,
        ],
      ),
    );
  }
}
