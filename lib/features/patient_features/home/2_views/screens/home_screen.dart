// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/floating_menu_bar.dart';
// import 'package:gina_app_4/dependencies_injection.dart';
// import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
// import 'package:gina_app_4/features/patient_features/home/2_views/screens/view_states/home_screen_loaded.dart';
// import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';

// class HomeScreenProvider extends StatelessWidget {
//   const HomeScreenProvider({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<HomeBloc>(
//       create: (context) {
//         final homeBloc = sl<HomeBloc>();
//         homeBloc.add(GetPatientCurrentLocationEvent());
//         // homeBloc.add(GetPatientNameEvent());
//         homeBloc.add(HomeInitialEvent());
//         return homeBloc;
//       },
//       child: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final homeBloc = context.read<HomeBloc>();
//     return Scaffold(
//       appBar: AppBar(
//         title: GinaHeader(size: 45),
//         actions: [
//           FloatingMenuWidget(
//             hasNotification: true,
//           ),
//           const Gap(10),
//         ],
//         surfaceTintColor: Colors.white,
//         elevation: 4,
//         shadowColor: Colors.grey.withOpacity(0.1),
//       ),
//       body: BlocConsumer<HomeBloc, HomeState>(
//         listenWhen: (previous, current) => current is HomeActionState,
//         buildWhen: (previous, current) => current is! HomeActionState,
//         listener: (context, state) {
//           // TODO: implement listener
//         },
//         builder: (context, state) {
//           if (state is HomeInitial) {
//             return HomeScreenLoaded(
//               completedAppointments: state.completedAppointments,
//             );
//           }
//           return HomeScreenLoaded(
//             completedAppointments: storedCompletedAppointments,
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/floating_menu_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/screens/view_states/home_screen_loaded.dart';
import 'package:gina_app_4/features/patient_features/home/2_views/bloc/home_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/period_tracker_screen.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_alert_dialog.dart';

class HomeScreenProvider extends StatelessWidget {
  const HomeScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) {
            final homeBloc = sl<HomeBloc>();
            homeBloc.add(GetPatientCurrentLocationEvent());
            homeBloc.add(HomeInitialEvent());
            return homeBloc;
          },
        ),
        BlocProvider<PeriodTrackerBloc>(
          create: (context) {
            final periodTrackerBloc = sl<PeriodTrackerBloc>();
            periodDates.clear();
            periodTrackerBloc.add(GetFirstMenstrualPeriodDatesEvent());
            periodTrackerBloc.add(DisplayDialogUpcomingPeriodEvent());
            return periodTrackerBloc;
          },
        ),
      ],
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static bool _isDialogShown = false;

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    final periodTrackerBloc = context.read<PeriodTrackerBloc>();

    BuildContext? dialogContext;

    return Scaffold(
      appBar: AppBar(
        title: GinaHeader(size: 45),
        actions: [
          FloatingMenuWidget(
            hasNotification: true,
          ),
          const Gap(10),
        ],
        surfaceTintColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.1),
      ),
      body: BlocListener<PeriodTrackerBloc, PeriodTrackerState>(
        listener: (context, state) {
          if (state is DisplayDialogUpcomingPeriodState && !_isDialogShown) {
            PeriodAlertDialog.showPeriodAlertDialog(
              context,
              state.startDate,
              periodTrackerBloc,
              state.periodTrackerModel,
            );

            _isDialogShown = true;
          } else if (state is NavigateToPeriodTrackerEditDatesState) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PeriodTrackerScreenProvider(
                shouldTriggerEdit: true,
                periodTrackerModel: state.periodTrackerModel,
              );
            }));
          }
        },
        child: BlocConsumer<HomeBloc, HomeState>(
          listenWhen: (previous, current) => current is HomeActionState,
          buildWhen: (previous, current) => current is! HomeActionState,
          listener: (context, state) {
            // Keep this empty or handle actions from HomeBloc
          },
          builder: (context, state) {
            if (state is HomeInitial) {
              return HomeScreenLoaded(
                completedAppointments: state.completedAppointments,
              );
            }
            return HomeScreenLoaded(
              completedAppointments: storedCompletedAppointments,
            );
          },
        ),
      ),
    );
  }
}
