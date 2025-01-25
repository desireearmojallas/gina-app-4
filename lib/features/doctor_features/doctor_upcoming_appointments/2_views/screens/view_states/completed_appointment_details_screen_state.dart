import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/screens/view_states/completed_appointment_detailed_screen.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/1_controllers/doctor_home_dashboard_controllers.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart'
    as doctor_home;
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:intl/intl.dart';

class CompletedAppointmentDetailScreenState extends StatelessWidget {
  final Map<DateTime, List<AppointmentModel>> completedAppointmentsList;
  final UserModel patientData;

  const CompletedAppointmentDetailScreenState({
    super.key,
    required this.completedAppointmentsList,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);
    var dates = completedAppointmentsList.keys.toList();
    final homeDashboardBloc = context.read<HomeBloc>();

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: GinaDoctorAppBar(
        title: 'My Past Appointments',
      ),
      body: SafeArea(
        bottom: true,
        child: RefreshIndicator(
          onRefresh: () async {
            homeDashboardBloc.add(doctor_home.HomeInitialEvent());
          },
          child: ScrollbarCustom(
            child: completedAppointmentsList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No completed appointments',
                          style: ginaTheme.textTheme.titleSmall?.copyWith(
                            color: GinaAppTheme.lightOutline,
                          ),
                        ),
                        const Gap(60),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const Gap(30),
                        Text('Thank you for your service,',
                            style: ginaTheme.textTheme.titleSmall?.copyWith(
                              color: GinaAppTheme.lightOutline,
                              fontSize: 12,
                            )),
                        const Gap(5),
                        Text(
                          'Dr. $doctorName!',
                          style: ginaTheme.textTheme.titleLarge?.copyWith(
                            color: GinaAppTheme.lightSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                            child: Column(
                              children: [
                                Image.asset(
                                  Images.completedAppointmentsIcon,
                                  height: size.height * 0.07,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 10.0),
                          itemCount: completedAppointmentsList.length,
                          itemBuilder: (context, index) {
                            final date = dates[index];
                            final appointments =
                                completedAppointmentsList[date]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    DateFormat('MMMM d, EEEE').format(date),
                                    style: const TextStyle(
                                      color: GinaAppTheme.lightOutline,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "SF UI Display",
                                    ),
                                  ),
                                ),
                                ...appointments.map((appointment) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CompletedAppointmentDetailedScreenState(
                                            appointment: appointment,
                                            patientData: patientData,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      // height: size.height * 0.11,
                                      width: size.width / 1.05,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border.all(
                                        //   color: GinaAppTheme.lightOutline
                                        //       .withOpacity(0.5),
                                        // ),
                                        boxShadow: [
                                          GinaAppTheme.defaultBoxShadow
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: CircleAvatar(
                                              radius: 37,
                                              backgroundImage: AssetImage(
                                                Images.patientProfileIcon,
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Appt ID: ${appointment.appointmentUid}',
                                                style: ginaTheme
                                                    .textTheme.labelMedium
                                                    ?.copyWith(
                                                  color:
                                                      GinaAppTheme.lightOutline,
                                                  fontSize: 9,
                                                ),
                                              ),
                                              const Gap(5),
                                              Text(
                                                appointment.patientName ?? "",
                                                style: ginaTheme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Gap(5),
                                              Text(
                                                appointment.modeOfAppointment ==
                                                        ModeOfAppointmentId
                                                            .onlineConsultation
                                                            .index
                                                    ? 'Online Consultation'
                                                        .toUpperCase()
                                                    : 'Face-to-face Consultation'
                                                        .toUpperCase(),
                                                style: ginaTheme
                                                    .textTheme.labelSmall
                                                    ?.copyWith(
                                                  color: GinaAppTheme
                                                      .lightTertiaryContainer,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Gap(5),
                                              Text(
                                                '${appointment.appointmentTime}',
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 30.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppointmentStatusContainer(
                                                  appointmentStatus: appointment
                                                      .appointmentStatus!,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
