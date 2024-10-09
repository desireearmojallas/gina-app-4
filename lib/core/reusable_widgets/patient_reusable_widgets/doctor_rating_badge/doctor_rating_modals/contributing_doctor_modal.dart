import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Future<dynamic> contributingDoctorModal(BuildContext context) {
  return showDialog(
    barrierColor: Colors.black.withOpacity(0.1),
    context: context,
    builder: (context) => Dialog(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          height: 150,
          width: 80,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    GinaAppTheme.lightOnSelectedColorNavBar.withOpacity(0.1),
                child: const Icon(
                  Icons.star_rounded,
                  color: GinaAppTheme.lightOnSelectedColorNavBar,
                  size: 30,
                ),
              ),
              const Text(
                'Contributing Doctor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GinaAppTheme.lightOnSelectedColorNavBar,
                ),
              ),
              const Text(
                'Earned by joining the forum and making at least one post or reply.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )),
    ),
  );
}
