import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/enum/enum.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/view_states/appointments_tab_view.dart';
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
    final ginaTheme = Theme.of(context).textTheme;

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
                ),
                // const Gap(30),
                GinaDivider(),
                // _title(context, 'Consultation history'),
                // const Gap(17),
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: 10,
                //   itemBuilder: (context, index) {
                //     return const AppointmentConsultationHistoryContainer();
                //   },
                // ),
                Container(
                  height: 500,
                  // color: Colors.blue,
                  child: AppointmentsTabView(),
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
