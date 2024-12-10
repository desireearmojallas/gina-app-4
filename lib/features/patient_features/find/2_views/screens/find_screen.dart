import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/screens/view_states/find_screen_loaded.dart';

class FindScreenProvider extends StatelessWidget {
  const FindScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FindBloc>(
      create: (context) {
        final findBloc = sl<FindBloc>();

        findBloc.add(GetDoctorsNearMeEvent());
        findBloc.add(GetDoctorsInTheNearestCityEvent());
        findBloc.add(GetAllDoctorsEvent());

        return findBloc;
      },
      child: const FindScreen(),
    );
  }
}

class FindScreen extends StatelessWidget {
  const FindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final findBloc = context.read<FindBloc>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GinaPatientAppBar(
          title: 'Find Doctors',
        ),
        body: BlocConsumer<FindBloc, FindState>(
          listenWhen: (previous, current) => current is FindActionState,
          buildWhen: (previous, current) => current is! FindActionState,
          listener: (context, state) {
            if (state is FindNavigateToDoctorDetailsState) {
              Navigator.pushNamed(context, '/doctorDetails').then(
                  (value) => findBloc.add(GetDoctorsInTheNearestCityEvent()));
            }
          },
          builder: (context, state) {
            //! testing to apply all loading states
            if (state is FindLoading) {
              return const Center(
                child: CustomLoadingIndicator(),
              );
            } else if (state is FindLoaded) {
              return const FindScreenLoaded();
            }
            return const FindScreenLoaded();
          },
        ));
  }
}
