// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_office_address/bloc/doctor_address_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_office_address/widgets/doctor_map_address_container.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_registration_steps/doctor_registration_step_4.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';

class DoctorAddOfficeAddressProvider extends StatelessWidget {
  const DoctorAddOfficeAddressProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final doctorAddressBloc = sl<DoctorAddressBloc>();
        doctorAddressBloc.add(DoctorRequestedEventLocation());

        return doctorAddressBloc;
      },
      child: DoctorAddOfficeAddressScreen(),
    );
  }
}

final GlobalKey<FormState> doctorRegistrationMapAddress =
    GlobalKey<FormState>();

class DoctorAddOfficeAddressScreen extends StatelessWidget {
  DoctorAddOfficeAddressScreen({super.key});

  Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);
    final authBloc = context.read<AuthBloc>();
    final doctorAddressBloc = context.read<DoctorAddressBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Office Address'),
      ),
      body: SizedBox(
        height: height * 0.442,
        child: BlocBuilder<DoctorAddressBloc, DoctorAddressState>(
          builder: (context, state) {
            final setMarkers = state is DoctorSuccessMarkersState
                ? state.markers
                : const <Marker>{};

            final currentLocationLatLng = state is DoctorSuccessLocationState
                ? state.currentLocation
                : null;
            if (state is DoctorSuccessLocationState ||
                state is DoctorSuccessMarkersState) {
              return GoogleMap(
                mapType: MapType.hybrid,
                // mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: currentLocationLatLng != null
                      ? LatLng(
                          currentLocationLatLng.latitude,
                          currentLocationLatLng.longitude,
                        )
                      : const LatLng(0, 0),
                  zoom: 13.5,
                ),
                markers: setMarkers,
                onTap: (LatLng latLng) {
                  officeLatLngAddressController.text = latLng.toString();
                  doctorAddressBloc.add(
                    AddMarkersInMapEvent(
                      latLng: latLng,
                    ),
                  );
                },
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomSheet: BottomSheet(
        enableDrag: false,
        showDragHandle: true,
        onClosing: () {},
        builder: (BuildContext context) {
          return Form(
            key: doctorRegistrationMapAddress,
            child: SizedBox(
              height: height * 0.42,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<DoctorAddressBloc, DoctorAddressState>(
                        builder: (context, state) {
                          final currentLocationLatLng =
                              state is DoctorSuccessLocationState
                                  ? state.currentLocation
                                  : null;
                          if (state is DoctorSuccessLocationState ||
                              state is DoctorSuccessMarkersState) {
                            return SearchGooglePlacesWidget(
                              placeholder: 'Search Location',
                              // TODO : TO CHANGE API KEY
                              apiKey: 'AIzaSyBg5KxB2Rdw7UV86btx0YJFmGkfF3CXUbc',
                              // apiKey: 'API_KEY',
                              language: 'en',
                              radius: 500000,
                              location: currentLocationLatLng != null
                                  ? LatLng(
                                      currentLocationLatLng.latitude,
                                      currentLocationLatLng.longitude,
                                    )
                                  : const LatLng(0, 0),
                              onSearch: (Place place) {},
                              onSelected: (Place place) async {
                                final geolocation = await place.geolocation;
                                mapsLocationAddressController.text =
                                    place.description.toString();

                                GoogleMapController controller =
                                    await mapController.future;
                                controller.animateCamera(CameraUpdate.newLatLng(
                                    geolocation!.coordinates));
                                controller.animateCamera(
                                    CameraUpdate.newLatLngBounds(
                                        geolocation.bounds, 0));

                                officeLatLngAddressController.text =
                                    geolocation.coordinates.toString();

                                doctorAddressBloc.add(
                                  AddMarkersInMapEvent(
                                    latLng: geolocation.coordinates,
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const Gap(20),
                      mapsLocationAddressController.text.isNotEmpty &&
                              officeAddressController.text.isNotEmpty
                          ? const DoctorMapAddressContainer()
                          : const SizedBox(),
                      const Gap(20),
                      Text(
                        'Complete Address',
                        style: ginaTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a valid address'
                              : null,
                          controller: officeAddressController,
                          decoration: const InputDecoration(
                            hintText: 'House no./ Floor / Building / Street',
                            border: UnderlineInputBorder(),
                            errorStyle: TextStyle(
                              fontSize: 0,
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Text(
                        'Phone Number',
                        style: ginaTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a valid phone number'
                              : null,
                          keyboardType: TextInputType.phone,
                          controller: officePhoneNumberController,
                          decoration: const InputDecoration(
                            hintText: '09-- --- ----',
                            border: UnderlineInputBorder(),
                            errorStyle: TextStyle(
                              fontSize: 0,
                            ),
                          ),
                        ),
                      ),
                      const Gap(20),
                      SizedBox(
                        width: width * 0.9,
                        child: FilledButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (doctorRegistrationMapAddress.currentState!
                                .validate()) {
                              authBloc.add(GetDoctorFullContactsEvent());
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Confirm & Proceed',
                            style: ginaTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
