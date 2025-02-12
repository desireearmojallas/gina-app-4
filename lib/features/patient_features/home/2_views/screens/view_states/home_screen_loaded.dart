import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/book_appointment_container.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/forums_container.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/home_calendar_tracker_container.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/widgets/patient_greeting_widget.dart';

class HomeScreenLoaded extends StatelessWidget {
  final List<AppointmentModel> completedAppointments;
  const HomeScreenLoaded({
    super.key,
    required this.completedAppointments,
  });

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();

    return ScrollbarCustom(
      child: RefreshIndicator(
        onRefresh: () async {
          homeBloc.add(GetPatientNameEvent());
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(15),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is GetPatientNameState) {
                      return PatientGreetingWidget(
                        patientName: state.patientName,
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const Gap(20),
                const HomeCalendarTrackerContainer(),
                const Gap(20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BookAppointmentContainer(),
                    Gap(10),
                    ForumsContainer(),
                  ],
                ),
                const Gap(20),
                ConsultationHistoryContainer(
                  completedAppointments: completedAppointments,
                ),
                const Gap(80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
