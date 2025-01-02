import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class MenstrualCycleInformationPatientData extends StatelessWidget {
  const MenstrualCycleInformationPatientData({super.key});

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
        child: Column(
          children: [
            const Gap(20),
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                menstrualCycleInformationWidget(
                  context,
                  startDate: 'Sep 11',
                  endDate: 'Sep 15',
                  cycleDays: 25,
                  isLastItem: false,
                ),
                menstrualCycleInformationWidget(
                  context,
                  startDate: 'Sep 11',
                  endDate: 'Sep 15',
                  cycleDays: 25,
                  isLastItem: false,
                ),
                menstrualCycleInformationWidget(
                  context,
                  startDate: 'Sep 11',
                  endDate: 'Sep 15',
                  cycleDays: 25,
                  isLastItem: false,
                ),
                menstrualCycleInformationWidget(
                  context,
                  startDate: 'Sep 11',
                  endDate: 'Sep 15',
                  cycleDays: 25,
                  isLastItem: true,
                ),
              ],
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
