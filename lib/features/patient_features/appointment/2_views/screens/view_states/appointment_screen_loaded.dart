import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/swiper_builder.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class AppointmentScreenLoaded extends StatelessWidget {
  final List<AppointmentModel> appointments;
  const AppointmentScreenLoaded({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();

    final upcomingAppointments = appointments
        .where((appointment) =>
            appointment.appointmentStatus ==
                AppointmentStatus.confirmed.index ||
            appointment.appointmentStatus == AppointmentStatus.pending.index)
        .toList();

    final completedAppointments = appointments
        .where((appointment) =>
            appointment.appointmentStatus !=
                AppointmentStatus.confirmed.index &&
            appointment.appointmentStatus != AppointmentStatus.pending.index)
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        appointmentBloc.add(GetAppointmentsEvent());
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ScrollbarCustom(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(context, 'Upcoming appointments'),
                const Gap(17),
                SwiperBuilderWidget(
                  upcomingAppointments: upcomingAppointments,
                  isDoctor: false,
                ),
                const Gap(30),
                _title(context, 'Consultation history'),
                const Gap(17),
                completedAppointments.isEmpty
                    ? Center(
                        child: Text(
                          'No History\nYour consultation history will appear here.',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: GinaAppTheme.lightOutline,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: completedAppointments.length,
                        itemBuilder: (context, index) {
                          final completedAppointment =
                              completedAppointments[index];

                          return AppointmentConsultationHistoryContainer(
                            appointment: completedAppointment,
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
      textAlign: TextAlign.left,
    );
  }
}
