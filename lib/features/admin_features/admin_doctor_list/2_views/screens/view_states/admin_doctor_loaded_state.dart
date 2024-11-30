import 'package:flutter/material.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/widgets/doctor_list_label.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/widgets/list_of_all_doctors.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';

class AdminDoctorListLoaded extends StatelessWidget {
  final List<DoctorModel> approvedDoctorList;
  const AdminDoctorListLoaded({super.key, required this.approvedDoctorList});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Text(
                      'List of all Doctors',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Gap(10),
                  const DoctorListLabel(),
                  ListOfAllDoctors(
                    approvedDoctorList: approvedDoctorList,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
