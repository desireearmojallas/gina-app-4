import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class DoctorViewPatientsScreenLoaded extends StatelessWidget {
  final List<UserModel> patientList;
  final List<AppointmentModel> patientAppointments;

  const DoctorViewPatientsScreenLoaded({
    super.key,
    required this.patientList,
    required this.patientAppointments,
  });

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;
    final patientDetailsBloc = context.read<DoctorViewPatientsBloc>();

    final Map<String, List<UserModel>> groupedPatients = {};
    for (var patient in patientList) {
      final firstLetter = patient.name[0].toUpperCase();
      if (groupedPatients[firstLetter] == null) {
        groupedPatients[firstLetter] = [];
      }
      groupedPatients[firstLetter]!.add(patient);
    }

    final sortedKeys = groupedPatients.keys.toList()..sort();

    return patientList.isEmpty
        ? Column(
            children: [
              const Gap(150),
              Center(
                child: Text(
                  "You don't have any patients yet",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: GinaAppTheme.lightOutline),
                ),
              ),
            ],
          )
        : ScrollbarCustom(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: sortedKeys.length,
                itemBuilder: (context, index) {
                  final letter = sortedKeys[index];
                  final patients = groupedPatients[letter]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Text(
                          letter,
                          style: ginaTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: GinaAppTheme.lightOutline,
                          ),
                        ),
                      ),
                      ...patients.map((patient) {
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            patientDetailsBloc
                                .add(FindNavigateToPatientDetailsEvent(
                              patient: patient,
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                      Images.patientProfileIcon,
                                    ),
                                  ),
                                  const Gap(15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient.name,
                                        style: ginaTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        patient.email,
                                        style: ginaTheme.bodySmall?.copyWith(
                                          color: GinaAppTheme.lightOutline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
          );
  }
}
