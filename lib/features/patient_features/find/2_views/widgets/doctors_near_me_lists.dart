import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DoctorsNearMe extends StatelessWidget {
  const DoctorsNearMe({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: width / 1.05,
        height: height * 0.09,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Row(
          children: [
            Container(),
            const Gap(10),
            const Column(
              children: [
                Row(
                  children: [
                    Text('Dr. Maria Santos'),
                    Gap(8),
                    Icon(Icons.check_circle_outline),
                  ],
                ),
                Text('General Practitioner'),
                Text('123 Main Street, Suite 201, Lapu-lapu City, Philippines'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
