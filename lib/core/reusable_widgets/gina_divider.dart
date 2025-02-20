// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/widgets/dashed_line_painter_horizontal.dart';

class GinaDivider extends StatelessWidget {
  double? space;
  Color? color;
  Color? ginaColor;
  GinaDivider({
    super.key,
    this.space = 8.0,
    this.color = GinaAppTheme.lightSurfaceVariant,
    this.ginaColor = GinaAppTheme.lightSurfaceVariant,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Gap(15),
        Row(
          children: [
            Expanded(
              child: CustomPaint(
                size: const Size(double.infinity, 1),
                painter: DashedLinePainterHorizontal(
                  color: color!,
                ),
              ),
            ),
            Gap(space!),
            SvgPicture.asset(
              Images.appLogo,
              height: size.height * 0.03,
              colorFilter: ColorFilter.mode(
                ginaColor!,
                BlendMode.srcIn,
              ),
            ),
            Gap(space!),
            Expanded(
              child: CustomPaint(
                size: const Size(double.infinity, 1),
                painter: DashedLinePainterHorizontal(
                  color: color!,
                ),
              ),
            ),
          ],
        ),
        const Gap(15),
      ],
    );
  }
}
