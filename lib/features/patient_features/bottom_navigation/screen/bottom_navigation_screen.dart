// ignore_for_file: deprecated_member_use

import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/alert_dialog_for_approved_appointments_payment/screens/floating_payment_reminder_widget.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/floating_container_for_ongoing_appt/bloc/floating_container_for_ongoing_appt_bloc.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/widgets/floating_container_for_ongoing_appt/screens/floating_container_for_ongoing_appt.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/screens/home_screen.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNavigationProvider extends StatelessWidget {
  const BottomNavigationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomNavigationBloc>(
      create: (context) => BottomNavigationBloc(),
      child: const BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  void initState() {
    super.initState();

    // Add delay to ensure bloc is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('💬 NAVIGATION: Dispatching CheckOngoingAppointments event');
        context.read<FloatingContainerForOngoingApptBloc>().add(
              CheckOngoingAppointments(),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your existing build method from the StatelessWidget
    return WillPopScope(
      onWillPop: () async {
        final currentIndex =
            context.read<BottomNavigationBloc>().state.currentIndex;
        if (currentIndex == 0) {
          return true;
        } else {
          context.read<BottomNavigationBloc>().add(BackPressedEvent());
          return false;
        }
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar:
            BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            debugPrint('Current Index in NavigationBar: ${state.currentIndex}');
            return CrystalNavigationBar(
              currentIndex: state.currentIndex,
              unselectedItemColor: state.currentIndex == 4
                  ? Colors.white
                  : GinaAppTheme.lightOutline.withOpacity(0.5),
              onTap: (index) {
                context
                    .read<BottomNavigationBloc>()
                    .add(TabChangedEvent(tab: index));
              },
              backgroundColor: Colors.white.withOpacity(0.1),
              outlineBorderColor: Colors.white.withOpacity(0.1),
              items: [
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 0
                      ? MingCute.home_4_fill
                      : MingCute.home_4_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 1
                      ? MingCute.search_2_fill
                      : MingCute.search_2_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 2
                      ? MingCute.message_3_fill
                      : MingCute.message_3_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 3
                      ? MingCute.comment_2_fill
                      : MingCute.comment_2_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 4
                      ? MingCute.user_3_fill
                      : MingCute.user_3_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
              ],
            );
          },
        ),
        body: Stack(
          children: [
            BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
              builder: (context, state) {
                return state.selectedScreen;
              },
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 90,
              left: 0,
              right: 0,
              child: BlocBuilder<FloatingContainerForOngoingApptBloc,
                  FloatingContainerForOngoingApptState>(
                builder: (context, state) {
                  final hasOngoingAppointment =
                      state is OngoingAppointmentFound;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Payment reminder
                      ValueListenableBuilder<bool>(
                        valueListenable: HomeScreen.paymentReminderNotifier,
                        builder: (context, _, __) {
                          if (HomeScreen.hasPendingPayment) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FloatingPaymentReminderProvider(
                                  key: ValueKey(HomeScreen
                                      .pendingPaymentAppointment
                                      ?.appointmentUid),
                                  appointment:
                                      HomeScreen.pendingPaymentAppointment!,
                                  approvalTime:
                                      HomeScreen.pendingPaymentApprovalTime!,
                                ),
                                if (hasOngoingAppointment) const Gap(10),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      // Ongoing appointment container
                      if (hasOngoingAppointment)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child:
                              FloatingContainerForOnGoingAppointmentProvider(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
