import 'package:flutter/cupertino.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class SquareAvatar extends StatelessWidget {
  final AssetImage image;

  const SquareAvatar({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        color: GinaAppTheme.appbarColorLight,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
