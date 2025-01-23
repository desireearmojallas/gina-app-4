import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/widgets/chat_econsult_card_list.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/screens/view_states/completed_appointment_details_screen_state.dart';
import 'package:gina_app_4/features/doctor_features/home_dashboard/2_views/bloc/home_dashboard_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/swiper_builder.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/0_model/chat_message_model.dart';

class DoctorEConsultScreenLoaded extends StatelessWidget {
  final List<AppointmentModel> upcomingAppointments;
  final List<ChatMessageModel> chatRooms;
  const DoctorEConsultScreenLoaded({
    super.key,
    required this.upcomingAppointments,
    required this.chatRooms,
  });

  @override
  Widget build(BuildContext context) {
    final doctorEconsultBloc = context.read<DoctorEconsultBloc>();
    final ginaTheme = Theme.of(context).textTheme;
    // final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Upcoming Appointments'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(10),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: upcomingAppointments.isEmpty
                        ? Colors.grey[300]
                        : GinaAppTheme.lightTertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      upcomingAppointments.isEmpty
                          ? '0'
                          : upcomingAppointments.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(15),
            SwiperBuilderWidget(
              upcomingAppointments: upcomingAppointments,
              isDoctor: true,
            ),
            GinaDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Consultation History'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompletedAppointmentDetailScreenState(
                            completedAppointmentsList:
                                completedAppointmentsListForEconsult!,
                            patientData: patientDataForEconsult!,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'View Past Appointments',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
                    ),
                  ),
                )
              ],
            ),
            // const Gap(10),
            chatRooms.isEmpty
                ? Column(
                    children: [
                      const Gap(50),
                      Center(
                        child: Text(
                          "You have no online consultation messages yet ",
                          style: ginaTheme.labelLarge?.copyWith(
                            color: GinaAppTheme.lightOutline,
                          ),
                        ),
                      ),
                    ],
                  )
                : ChatEConsultCardList(
                    chatRooms: chatRooms,
                    doctorEconsultBloc: doctorEconsultBloc,
                  ),
          ],
        ),
      ),
    );
  }
}
