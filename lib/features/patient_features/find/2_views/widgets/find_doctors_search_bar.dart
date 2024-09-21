import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';

class FindDoctorsSearchBar extends StatelessWidget {
  const FindDoctorsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    return Center(
      child: SizedBox(
        height: 50,
        width: width * 0.9,
        //TODO: KUWANG PA NI
        child: SearchBar(
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            ginaTheme.textTheme.titleMedium!.copyWith(
              color: GinaAppTheme.lightTertiaryContainer,
              fontSize: 15,
            ),
          ),
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              MingCute.search_2_line,
              color: Colors.grey,
            ),
          ),
          hintText: 'Search for doctor\'s name',
          hintStyle: MaterialStateProperty.all<TextStyle>(
            ginaTheme.textTheme.titleMedium!.copyWith(
              color: GinaAppTheme.lightOutline,
              fontSize: 15,
            ),
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            Colors.transparent,
          ),
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(
            GinaAppTheme.lightOnTertiary,
          ),
          onTap: () {},
          onChanged: (value) {},
        ),
      ),
    );
  }
}
