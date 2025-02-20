import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/bloc/doctor_details_bloc.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/screens/view_states/doctor_details_screen_loaded.dart';
import 'package:gina_app_4/features/patient_features/doctor_details/2_views/widgets/doctor_office_address_map_view.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';

class DoctorDetailsScreenProvider extends StatelessWidget {
  const DoctorDetailsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorDetailsBloc>(
      create: (context) {
        final doctorDetailsBloc = sl<DoctorDetailsBloc>();

        doctorDetailsBloc.add(DoctorDetailsFetchRequestedEvent());

        return doctorDetailsBloc;
      },
      child: const DoctorDetailsScreen(),
    );
  }
}

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorDetailsBloc, DoctorDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GinaPatientAppBar(
            title: state is DoctorDetailsLoaded
                ? 'Dr. ${doctorDetails?.name}'
                : '',
          ),
          body: BlocConsumer<DoctorDetailsBloc, DoctorDetailsState>(
            listenWhen: (previous, current) =>
                current is DoctorDetailsActionState,
            buildWhen: (previous, current) =>
                current is! DoctorDetailsActionState,
            listener: (context, state) {
              if (state is DoctorOfficeAddressMapViewState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorOfficeAddressMapView(),
                  ),
                ).then((_) {
                  // Re-fetch the doctor details when returning from the map view
                  context
                      .read<DoctorDetailsBloc>()
                      .add(DoctorDetailsFetchRequestedEvent());
                });
              }
            },
            builder: (context, state) {
              if (state is DoctorDetailsLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              } else if (state is DoctorDetailsLoaded) {
                return DoctorDetailsScreenLoaded(
                  doctor: doctorDetails!,
                  appointment: appointmentForNearbyDocLatestAppointment ??
                      AppointmentModel(),
                );
              }
              return Container();
            },
          ),
        );
      },
    );
  }
}
