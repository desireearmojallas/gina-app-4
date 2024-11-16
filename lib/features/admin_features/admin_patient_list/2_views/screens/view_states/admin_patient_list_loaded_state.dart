import 'package:flutter/material.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/list_of_all_patients.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/patient_list_label.dart';

class AdminPatientListLoaded extends StatelessWidget {
  const AdminPatientListLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 22.0),
        child: Column(
          children: [
            Container(
              height: size.height * 0.96,
              width: size.width / 1.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Text(
                      'List of all Patients',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Gap(10),
                  PatientListLabel(),
                  ListOfAllPatients(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
