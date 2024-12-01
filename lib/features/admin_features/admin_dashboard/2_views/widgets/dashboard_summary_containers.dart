import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_dashboard/2_views/bloc/admin_dashboard_bloc.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';

class DashboardSummaryContainers extends StatelessWidget {
  final List<DoctorModel> doctors;
  final List<UserModel> patients;
  const DashboardSummaryContainers({
    super.key,
    required this.doctors,
    required this.patients,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final adminDashboardBloc = context.read<AdminDashboardBloc>();
    final patientCount = patients.length;
    final approvedDoctorCount = doctors
        .where((element) =>
            element.doctorVerificationStatus ==
            DoctorVerificationStatus.approved.index)
        .length;
    final pendingDoctorCount = doctors
        .where((element) =>
            element.doctorVerificationStatus ==
            DoctorVerificationStatus.pending.index)
        .length;
    final appointmentsBookedCount = patients.fold(
        0, (prev, patient) => prev + (patient.appointmentsBooked.length));

    return Row(
      children: [
        InkWell(
          onTap: () {
            adminDashboardBloc.add(PendingDoctorVerificationListEvent());
          },
          child: FittedBox(
            child: Container(
              width: size.width * 0.115,
              height: size.height * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF5E0CD),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: GinaAppTheme.pendingTextColor,
                          child: Icon(
                            Icons.watch_later_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pending\nDoctor\nVerification',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          pendingDoctorCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(15),
        SizedBox(
          height: size.height * 0.1,
          child: const VerticalDivider(
            color: GinaAppTheme.lightScrim,
            thickness: 0.1,
          ),
        ),
        const Gap(15),
        InkWell(
          onTap: () {
            adminDashboardBloc.add(ApprovedDoctorVerificationListEvent());
          },
          child: FittedBox(
            child: Container(
              width: size.width * 0.115,
              height: size.height * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: GinaAppTheme.lightPrimaryColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: GinaAppTheme.lightTertiaryContainer,
                          child: Icon(
                            Icons.badge_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total\nVerified\nDoctors',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          approvedDoctorCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(20),
        InkWell(
          onTap: () {
            adminDashboardBloc
                .add(AdminDashboardNavigateToListOfAllPatientsEvent());
          },
          child: FittedBox(
            child: Container(
              width: size.width * 0.115,
              height: size.height * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffCCEBD9),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: GinaAppTheme.approvedTextColor,
                          child: Icon(
                            Icons.face_3_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total\nPatients',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          patientCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(20),
        InkWell(
          onTap: () {
            adminDashboardBloc
                .add(AdminDashboardNavigateToListOfAllAppointmentsEvent());
          },
          child: FittedBox(
            child: Container(
              width: size.width * 0.115,
              height: size.height * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffE3CDF5),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xffA837FF),
                          child: Icon(
                            CupertinoIcons.book_fill,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total\nAppointments\nBooked',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          appointmentsBookedCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
