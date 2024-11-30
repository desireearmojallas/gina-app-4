import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/bloc/admin_doctor_list_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:intl/intl.dart';

class ListOfAllDoctors extends StatelessWidget {
  final List<DoctorModel> approvedDoctorList;
  const ListOfAllDoctors({super.key, required this.approvedDoctorList});

  @override
  Widget build(BuildContext context) {
    final adminDoctorListBloc = context.read<AdminDoctorListBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: GinaAppTheme.lightScrim,
          thickness: 0.1,
          height: 12,
        ),
        itemCount: approvedDoctorList.length,
        itemBuilder: (context, index) {
          final doctor = approvedDoctorList[index];

          return InkWell(
            onTap: () {
              adminDoctorListBloc.add(AdminDoctorDetailsEvent(
                doctorApproved: doctor,
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
                          Images.doctorProfileIcon1,
                        ),
                      ),
                    ),
                    const Gap(15),
                    SizedBox(
                      width: size.width * 0.14,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Dr. ${doctor.name}',
                              style: ginaTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const Gap(5),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                    const Gap(25),
                    SizedBox(
                      width: size.width * 0.112,
                      child: Text(
                        doctor.email,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.12,
                      child: Text(
                        doctor.medicalSpecialty,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.17,
                      child: Text(
                        doctor.officeAddress,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.102,
                      child: Text(
                        doctor.officePhoneNumber,
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.07,
                      child: Text(
                        DateFormat('MMM d, yyyy').format(
                          doctor.created!.toDate().toLocal(),
                        ),
                        style: ginaTheme.labelMedium,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.06,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: GinaAppTheme.lightTertiaryContainer
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              DateFormat('MMM d, yyyy').format(
                                doctor.verifiedDate!.toDate().toLocal(),
                              ),
                              style: ginaTheme.labelMedium,
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
