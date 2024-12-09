import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/2_views/bloc/doctor_availability_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_availability/2_views/screens/view_states/doctor_availability_initial_screen.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/view_states/doctor_details_screen_loaded.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';

class DoctorAvailabilityScreenProvider extends StatelessWidget {
  const DoctorAvailabilityScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorAvailabilityBloc>(
      create: (context) {
        final doctorAvailabilityBloc = sl<DoctorAvailabilityBloc>();

        doctorAvailabilityBloc.add(
          GetDoctorAvailabilityEvent(
            doctorId: doctorDetails!.uid,
          ),
        );

        return doctorAvailabilityBloc;
      },
      child: Container(),
    );
  }
}

class DoctorAvailabilityScreen extends StatelessWidget {
  const DoctorAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorAvailabilityBloc, DoctorAvailabilityState>(
      listenWhen: (previous, current) =>
          current is DoctorAvailabilityActionState,
      buildWhen: (previous, current) =>
          current is! DoctorAvailabilityActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DoctorAvailabilityLoading) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        } else if (state is DoctorAvailabilityError) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else if (state is DoctorAvailabilityLoaded) {
          final doctorAvailabilityModel = state.doctorAvailabilityModel;
          return DoctorDetailsScreenLoaded(
            doctor: doctorDetails!,
          );
        }
        return Container();
      },
    );
  }
}
