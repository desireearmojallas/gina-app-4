import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/view_states/period_tracker_edit_dates_screen.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/view_states/period_tracker_initial_screen.dart';

class PeriodTrackerScreenProvider extends StatelessWidget {
  const PeriodTrackerScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeriodTrackerBloc>(
      create: (context) {
        final periodTrackerBloc = sl<PeriodTrackerBloc>();
        periodDates.clear();
        periodTrackerBloc.add(GetFirstMenstrualPeriodDatesEvent());
        return periodTrackerBloc;
      },
      child: const PeriodTrackerScreen(),
    );
  }
}

class PeriodTrackerScreen extends StatelessWidget {
  const PeriodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final periodTrackerBloc = context.read<PeriodTrackerBloc>();
    return Scaffold(
        appBar: GinaPatientAppBar(
          title: 'Period Tracker',
        ),
        body: BlocConsumer<PeriodTrackerBloc, PeriodTrackerState>(
            listenWhen: (previous, current) =>
                current is PeriodTrackerActionState,
            buildWhen: (previous, current) =>
                current is! PeriodTrackerActionState,
            listener: (context, state) {
              if (state is LogFirstMenstrualPeriodSuccess) {
                periodDates.clear();
                periodTrackerBloc.add(GetFirstMenstrualPeriodDatesEvent());
              } else if (state is LogFirstMenstrualPeriodError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                  ),
                );
              } else if (state is LogFirstMenstrualPeriodLoadingState) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Container(
                        height: 220,
                        width: 200,
                        decoration: BoxDecoration(
                          color: GinaAppTheme.appbarColorLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(29.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomLoadingIndicator(),
                              Gap(20),
                              Text(
                                'We are preparing your period tracker...\nPlease wait.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                Future.delayed(const Duration(seconds: 5), () {
                  Navigator.of(context).pop();
                });
              }
            },
            builder: (context, state) {
              if (state is NavigateToPeriodTrackerEditDatesState) {
                return PeriodTrackerEditDatesScreen(
                  periodTrackerModel: state.periodTrackerModel,
                  storedPeriodDates: state.loggedPeriodDates,
                );
              } else if (state is GetFirstMenstrualPeriodSuccess) {
                return PeriodTrackerInitialScreen(
                  periodTrackerModel: state.periodTrackerModel,
                  allPeriodsWithPredictions: state.allPeriodsWithPredictions,
                );
              } else if (state is GetFirstMenstrualPeriodError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is GetFirstMenstrualPeriodLoadingState) {
                return const Center(child: CustomLoadingIndicator());
              }

              return const SizedBox.shrink();
            }));
  }
}
