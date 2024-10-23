// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GinaHeader extends StatelessWidget {
  bool? isDoctor;
  final double size;
  GinaHeader({
    super.key,
    this.isDoctor = false,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isDoctor == true)
          SizedBox(
            width: 35,
            height: 20,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 35,
                    height: 20,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF36344E)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 6,
                  top: 1,
                  child: Text(
                    'DR.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF36344E),
                      fontSize: 15,
                      fontFamily: 'Cormorant Upright',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const Gap(5),
        Text(
          'GINA',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF36344E),
            fontSize: size,
            fontFamily: 'Cormorant Upright',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
