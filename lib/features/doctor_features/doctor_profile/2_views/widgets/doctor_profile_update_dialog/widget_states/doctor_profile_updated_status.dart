import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DoctorProfileUpdatedStatus extends StatelessWidget {
  const DoctorProfileUpdatedStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 250,
        width: 200,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green,
              size: 50,
            ),
            const Gap(10),
            const Text(
              'Profile Updated Successfully!',
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            SizedBox(
              height: 30,
              child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
