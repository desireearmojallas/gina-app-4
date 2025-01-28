import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/bloc/doctor_appointment_request_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/approved_state/screens/approved_request_state_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/cancelled_state/screens/cancelled_request_state_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/completed_state/screens/completed_request_state_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/declined_state/screens/declined_request_state_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/missed_state/screens/missed_request_state_screen.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/screens/pending_request_state_screen.dart';

class DoctorAppointmentRequestScreenLoaded extends StatelessWidget {
  const DoctorAppointmentRequestScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<DoctorAppointmentRequestBloc,
        DoctorAppointmentRequestState>(
      builder: (context, state) {
        final ginaTheme = Theme.of(context).textTheme;

        int initialIndex = 3;
        Color indicatorColor = GinaAppTheme.lightTertiaryContainer;
        Color labelColor = GinaAppTheme.lightTertiaryContainer;

        if (state is TabChangedState) {
          initialIndex = state.tab;
          // Set colors based on the selected tab
          switch (initialIndex) {
            case 0:
              indicatorColor = GinaAppTheme.cancelledTextColor;
              labelColor = GinaAppTheme.cancelledTextColor;
              break;
            case 1:
              indicatorColor = GinaAppTheme.declinedTextColor;
              labelColor = GinaAppTheme.declinedTextColor;
              break;
            case 2:
              indicatorColor = GinaAppTheme.missedTextColor;
              labelColor = GinaAppTheme.missedTextColor;
              break;
            case 3:
              indicatorColor = GinaAppTheme.pendingTextColor;
              labelColor = GinaAppTheme.pendingTextColor;
              break;
            case 4:
              indicatorColor = GinaAppTheme.approvedTextColor;
              labelColor = GinaAppTheme.approvedTextColor;
              break;
            case 5:
              indicatorColor = GinaAppTheme.lightTertiaryContainer;
              labelColor = GinaAppTheme.lightTertiaryContainer;
              break;
          }
        }

        final List<TabData> tabs = [
          TabData(
            index: 0,
            title: const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Cancelled'),
                ],
              ),
            ),
            content: const CancelledRequestStateScreenProvider(),
          ),
          TabData(
            index: 1,
            title: const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Declined'),
                ],
              ),
            ),
            content: const DeclinedRequestStateScreenProvider(),
          ),
          TabData(
            index: 2,
            title: const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Missed'),
                ],
              ),
            ),
            content: const MissedRequestStateScreenProvider(),
          ),
          TabData(
            index: 3,
            title: const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pending'),
                ],
              ),
            ),
            content: const PendingRequestStateScreenProvider(),
          ),
          TabData(
            index: 4,
            title: const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Approved'),
                ],
              ),
            ),
            content: const ApprovedRequestStateScreenProvider(),
          ),
          TabData(
            index: 5,
            title: const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Completed'),
                ],
              ),
            ),
            content: const CompletedRequestStateScreenProvider(),
          ),
        ];

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(0.5),
              ),
              child: SizedBox(
                height: size.height * 0.89,
                child: DynamicTabBarWidget(
                  physicsTabBarView: const BouncingScrollPhysics(),
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  isScrollable: true,
                  showBackIcon: false,
                  showNextIcon: false,
                  leading: null,
                  trailing: null,
                  dynamicTabs: tabs,
                  enableFeedback: true,
                  splashBorderRadius: BorderRadius.circular(10.0),
                  splashFactory: InkSparkle.splashFactory,
                  indicatorColor: indicatorColor,
                  labelColor: labelColor,
                  labelStyle: ginaTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                  unselectedLabelStyle: ginaTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                  ),
                  unselectedLabelColor:
                      GinaAppTheme.lightOutline.withAlpha(204),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                  indicatorPadding: EdgeInsets.zero,
                  onTabControllerUpdated: (controller) {
                    controller.index = initialIndex;
                  },
                  onTabChanged: (index) {
                    context
                        .read<DoctorAppointmentRequestBloc>()
                        .add(TabChangedEvent(tab: index!));
                    HapticFeedback.heavyImpact();
                    debugPrint('Tab changed to: $index');
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
