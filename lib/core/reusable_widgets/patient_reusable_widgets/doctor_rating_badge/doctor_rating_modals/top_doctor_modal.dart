import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Future<dynamic> topDoctorModal(BuildContext context) {
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
                    GinaAppTheme.declinedTextColor.withOpacity(0.1),
                child: const Icon(
                  Icons.star_rounded,
                  color: GinaAppTheme.declinedTextColor,
                  size: 30,
                ),
              ),
              const Text(
                'Top Doctor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GinaAppTheme.declinedTextColor,
                ),
              ),
              const Text(
                'Earned by making at least 50 forum posts or replies in a month.',
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
