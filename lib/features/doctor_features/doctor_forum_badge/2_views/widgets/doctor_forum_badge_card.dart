import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DoctorForumBadgeCard extends StatelessWidget {
  final String formattedDate;
  final String badgeName;
  final String backgroundImage;
  final String nextBadgeName;
  final Color? currentBadgeColor;
  final Color? nextBadgeColor;
  final int progress;
  final double progressValue;
  final int nextBadgeQuota;

  const DoctorForumBadgeCard({
    super.key,
    required this.formattedDate,
    required this.badgeName,
    required this.backgroundImage,
    required this.nextBadgeName,
    this.currentBadgeColor,
    this.nextBadgeColor,
    required this.progress,
    required this.progressValue,
    required this.nextBadgeQuota,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    return Container(
      height: size.height * 0.24,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
        color: GinaAppTheme.lightOnTertiary,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor:
                      GinaAppTheme.lightOnTertiary.withOpacity(0.5),
                  child: Icon(
                    Icons.star_rounded,
                    color: GinaAppTheme.lightOnTertiary,
                  ),
                ),
                const Gap(15),
                Text(
                  badgeName,
                  style: ginaTheme.headlineSmall!.copyWith(
                    color: GinaAppTheme.lightOnTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: size.height * 0.16,
            width: size.width * 0.83,
            decoration: BoxDecoration(
              color: GinaAppTheme.lightOnTertiary,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                badgeName == 'Top Doctor'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: Text(
                            'You\'ve reached the highest badge!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: currentBadgeColor,
                                ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'To Unlock Next Badge:',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: currentBadgeColor,
                                  ),
                        ),
                      ),
                badgeName == 'Top Doctor'
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    nextBadgeColor?.withOpacity(0.25),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: nextBadgeColor,
                                  size: 35,
                                ),
                              ),
                              const Gap(2),
                              Text(
                                nextBadgeName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: nextBadgeColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          // vertical: 3.0,
                        ),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: progress.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: currentBadgeColor,
                                          fontWeight: FontWeight.bold,
                                        ), // Style for '0'
                                  ),
                                  TextSpan(
                                    text: badgeName == 'Top Doctor'
                                        ? ''
                                        : '/$nextBadgeQuota',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.grey[500],
                                        ), // Style for '/1'
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                badgeName == 'Top Doctor'
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.65,
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(10),
                              value: progress / nextBadgeQuota,
                              backgroundColor: Colors.grey[150],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  currentBadgeColor!),
                              minHeight: 8,
                            ),
                          ),
                          const Gap(10),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    nextBadgeColor?.withOpacity(0.25),
                                child: Icon(Icons.star_rounded,
                                    color: nextBadgeColor),
                              ),
                              const Gap(2),
                              Text(
                                nextBadgeName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: nextBadgeColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Progress will be refreshed $formattedDate',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
