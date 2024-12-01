import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/list_of_all_patients.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/widgets/patient_list_label.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';

class AdminPatientListLoaded extends StatelessWidget {
  final List<UserModel> patientList;
  const AdminPatientListLoaded({super.key, required this.patientList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final adminDashboardBloc = context.read<AdminDashboardBloc>();

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 22.0),
        child: Column(
          children: [
            Container(
              height: size.height * 1.02,
              width: size.width / 1.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Text(
                          'List of all Patients',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
                        builder: (context, state) {
                          if (state is NavigateToPatientsList) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: InkWell(
                                onTap: () {
                                  adminDashboardBloc
                                      .add(AdminDashboardGetRequestedEvent());
                                },
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: GinaAppTheme.lightOutline,
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),

                  // Gap(10),
                  const PatientListLabel(),
                  ListOfAllPatients(
                    patientList: patientList,
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
