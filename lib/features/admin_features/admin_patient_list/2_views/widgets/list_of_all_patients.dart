import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/bloc/admin_patient_list_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:intl/intl.dart';

class ListOfAllPatients extends StatelessWidget {
  final List<UserModel> patientList;
  const ListOfAllPatients({super.key, required this.patientList});

  @override
  Widget build(BuildContext context) {
    final adminPatientListBloc = context.read<AdminPatientListBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: GinaAppTheme.lightScrim,
          thickness: 0.1,
          height: 12,
        ),
        itemCount: patientList.length,
        itemBuilder: (context, index) {
          final patient = patientList[index];
          return InkWell(
            onTap: () {
              adminPatientListBloc.add(AdminPatientDetailsEvent(
                patientDetails: patient,
              ));
            },
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: GinaAppTheme.lightTertiaryContainer,
                        foregroundImage: AssetImage(
                          Images.patientProfileIcon,
                        ),
                      ),
                    ),
                    const Gap(15),
                    SizedBox(
                      width: size.width * 0.14,
                      child: Text(
                        patient.name,
                        style: ginaTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Gap(25),
                    SizedBox(
                      width: size.width * 0.14,
                      child: Text(
                        patient.email,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.08,
                      child: Text(
                        patient.gender,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.2,
                      child: Text(
                        patient.address,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.08,
                      child: Text(
                        patient.dateOfBirth,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.08,
                      child: Text(
                        DateFormat('MMMM d, yyyy').format(
                          patient.created!.toDate().toLocal(),
                        ),
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: GinaAppTheme.lightTertiaryContainer
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Text(
                              patient.appointmentsBooked.length.toString(),
                              style: ginaTheme.labelMedium?.copyWith(
                                // color: GinaAppTheme.lightTertiaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
