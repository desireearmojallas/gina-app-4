import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Widget adminContainerTextWidget() {
    return SizedBox(
      width: 60,
      height: 20,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 60,
              height: 20,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: GinaAppTheme.lightOnPrimaryColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 6,
            top: 1,
            child: Text(
              'ADMIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GinaAppTheme.lightOnPrimaryColor,
                fontSize: 15,
                fontFamily: 'Cormorant Upright',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }