import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';

class PendingRequestStateScreenLoaded extends StatelessWidget {
  const PendingRequestStateScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollbarCustom(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: itemBuilder,
          itemCount: 20,
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: size.height * 0.11,
        width: size.width / 1.05,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: GinaAppTheme.lightOnTertiary,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CircleAvatar(
                radius: 37,
                backgroundImage: AssetImage(
                  Images.patientProfileIcon,
                ),
                backgroundColor: Colors.white,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desiree Armojallas',
                  style: ginaTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(5),
                Text(
                  'Online Consultation',
                  style: ginaTheme.textTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.lightTertiaryContainer,
                  ),
                ),
                const Gap(5),
                Text(
                  'Tuesday, December 19\n8:00 AM - 9:00 AM',
                  style: ginaTheme.textTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.lightOutline,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
