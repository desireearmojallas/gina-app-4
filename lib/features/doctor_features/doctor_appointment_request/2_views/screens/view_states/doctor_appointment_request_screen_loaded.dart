import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/screens/bloc/doctor_appointment_request_screen_loaded_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';

class DoctorAppointmentRequestScreenLoaded extends StatelessWidget {
  const DoctorAppointmentRequestScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const Gap(5),
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white.withOpacity(0.5),
            ),
            child: BlocBuilder<DoctorAppointmentRequestScreenLoadedBloc,
                DoctorAppointmentRequestScreenLoadedState>(
              builder: (context, state) {
                return SizedBox(
                  height: size.height * 0.045,
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    onTap: (index) {
                      context
                          .read<DoctorAppointmentRequestScreenLoadedBloc>()
                          .add(TabChangedEvent(tab: index));
                    },
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                    unselectedLabelColor: GinaAppTheme.lightOutline,
                    labelStyle: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: state.backgroundColor,
                      boxShadow: [
                        GinaAppTheme.defaultBoxShadow,
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Pending'),
                      Tab(text: 'Approved'),
                      Tab(text: 'Declined'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<DoctorAppointmentRequestScreenLoadedBloc,
                DoctorAppointmentRequestScreenLoadedState>(
              builder: (context, state) {
                return TabBarView(
                  children: [
                    Center(child: state.selectedScreen),
                    Center(child: state.selectedScreen),
                    Center(child: state.selectedScreen),
                    Center(child: state.selectedScreen),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
