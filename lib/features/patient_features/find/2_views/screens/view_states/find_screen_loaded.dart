import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/widgets/doctors_in_the_nearest_city_list.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/widgets/doctors_near_me_lists.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/widgets/find_doctors_search_bar.dart';

class FindScreenLoaded extends StatelessWidget {
  const FindScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final findBloc = context.read<FindBloc>();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: RefreshIndicator(
              onRefresh: () async {
                findBloc.add(GetDoctorsNearMeEvent());
                // findBloc.add(GetDoctorsInTheNearestCityEvent());
                findBloc.add(GetAllDoctorsEvent());
              },
              child: ScrollbarCustom(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Row(
                      //   children: [
                      //     const Gap(10),
                      //     Image.asset(
                      //       Images.officeAddressLogo,
                      //       width: 20,
                      //     ),
                      //     const Gap(10),
                      //     Text(
                      //       'Near me',
                      //       style: ginaTheme.textTheme.bodyLarge?.copyWith(
                      //         color: GinaAppTheme.lightOnPrimaryColor,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     // ADD INPUT FIELD HERE FOR THE DYNAMIC KM RADIUS OF NEARBY DOCTORS
                      //   ],
                      // ),

                      Row(
                        children: [
                          const Gap(10),
                          Image.asset(
                            Images.officeAddressLogo,
                            width: 20,
                          ),
                          const Gap(10),
                          Text(
                            'Near me',
                            style: ginaTheme.textTheme.bodyLarge?.copyWith(
                              color: GinaAppTheme.lightOnPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          // Radius input field
                          BlocBuilder<FindBloc, FindState>(
                            buildWhen: (previous, current) =>
                                previous.searchRadius != current.searchRadius,
                            builder: (context, state) {
                              debugPrint(
                                  'Building radius UI with: ${state.searchRadius}');
                              final radiusController = TextEditingController(
                                  text: state.searchRadius.toStringAsFixed(0));

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Radius:',
                                      style: ginaTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: GinaAppTheme.lightOnPrimaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Gap(8),
                                    SizedBox(
                                      width: 45,
                                      child: TextField(
                                        controller: radiusController,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 4.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: GinaAppTheme.lightOutline
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: GinaAppTheme.lightOutline
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(
                                              color: GinaAppTheme
                                                  .lightTertiaryContainer,
                                              width: 1.5,
                                            ),
                                          ),
                                          isDense: true,
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                        ),
                                        style: ginaTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              GinaAppTheme.lightOnPrimaryColor,
                                        ),
                                        onSubmitted: (value) {
                                          _applyRadius(context, value);
                                        },
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      'km',
                                      style: ginaTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: GinaAppTheme.lightOnPrimaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Gap(10),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () {
                                          _applyRadius(
                                              context, radiusController.text);
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 32,
                                          decoration: BoxDecoration(
                                            color: GinaAppTheme
                                                .lightTertiaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.search,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                        child: BlocBuilder<FindBloc, FindState>(
                            builder: (context, state) {
                          debugPrint('Current state: $state');

                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: 'We found '),
                                  TextSpan(
                                    text: doctorNearMeLists?.length.toString(),
                                    style: ginaTheme.textTheme.titleLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' doctor(s) within ${state.searchRadius.toStringAsFixed(0)}km!',
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      BlocConsumer<FindBloc, FindState>(
                        listenWhen: (previous, current) =>
                            current is FindActionState,
                        buildWhen: (previous, current) =>
                            current is! FindActionState,
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is GetDoctorNearMeSuccessState) {
                            debugPrint('Current state doc display: $state');
                            return DoctorsNearMe(
                              doctorLists: state.doctorLists,
                            );
                          } else if (state is GetDoctorNearMeFailedState) {
                            return const SizedBox(
                              height: 180,
                              child: Center(
                                child: Text(
                                  'No doctors found near your area',
                                ),
                              ),
                            );
                          } else if (state is GetDoctorNearMeLoadingState) {
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: CustomLoadingIndicator(),
                            ));
                          }
                          return DoctorsNearMe(
                            doctorLists: doctorNearMeLists ?? [],
                          );
                        },
                      ),
                      BlocConsumer<FindBloc, FindState>(
                        listenWhen: (previous, current) =>
                            current is FindActionState,
                        buildWhen: (previous, current) =>
                            current is! FindActionState,
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is GetDoctorsInTheNearestCitySuccessState) {
                            final citiesWithDoctors = state.citiesWithDoctors;

                            if (citiesWithDoctors.entries.isEmpty) {
                              // return const Text(
                              //     'No doctors found in other cities.');
                              return Container();
                            } else {
                              debugPrint(
                                  'Cities with doctors: $citiesWithDoctors'); //!working

                              return Column(
                                children: [
                                  const Gap(40),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Other Cities',
                                      style: ginaTheme.textTheme.titleLarge
                                          ?.copyWith(
                                        color: GinaAppTheme.lightOnPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: citiesWithDoctors.entries
                                        .map<Widget>((entry) {
                                      final city = entry.key;
                                      final doctors = entry.value;

                                      debugPrint(
                                          'Number of cities: ${citiesWithDoctors.length}');
                                      debugPrint(
                                          'Number of doctors in Lapu-Lapu City: ${doctors.length}');

                                      return SingleChildScrollView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        child: Column(
                                          children: [
                                            const Gap(10),
                                            const Divider(
                                              color: GinaAppTheme
                                                  .lightSurfaceVariant,
                                            ),
                                            const Gap(20),
                                            Row(
                                              children: [
                                                const Gap(10),
                                                Image.asset(
                                                  Images.officeAddressLogo,
                                                  width: 20,
                                                ),
                                                const Gap(10),
                                                Text(
                                                  city,
                                                  style: ginaTheme
                                                      .textTheme.bodyLarge
                                                      ?.copyWith(
                                                    color: GinaAppTheme
                                                        .lightOnPrimaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Gap(20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 0, 5),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                          text: 'We found '),
                                                      TextSpan(
                                                        text: doctors.length
                                                            .toString(),
                                                        style: ginaTheme
                                                            .textTheme
                                                            .titleLarge
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              ' doctor(s) in $city!'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Gap(10),
                                            Column(
                                              children:
                                                  doctors.map<Widget>((doctor) {
                                                return Column(
                                                  children: [
                                                    DoctorsInTheNearestCity(
                                                        doctorLists: [doctor]),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            }
                          } else if (state
                              is ToggleOtherCitiesVisibilityFailedState) {
                            return Center(
                              child: Text(state.errorMessage),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 75,
            left: 60,
            right: 60,
            child: BlocBuilder<FindBloc, FindState>(
              builder: (context, state) {
                return FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (state is GetDoctorsInTheNearestCitySuccessState) {
                          return Colors.grey.shade400.withOpacity(0.95);
                        }
                        return GinaAppTheme.lightTertiaryContainer
                            .withOpacity(0.95);
                      },
                    ),
                  ),
                  onPressed: () {
                    findBloc.add(ToggleOtherCitiesVisibilityEvent());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        state is GetDoctorsInTheNearestCitySuccessState
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                        size: 18,
                      ),
                      const Gap(8),
                      Text(
                        state is GetDoctorsInTheNearestCitySuccessState
                            ? 'Hide doctors from other cities'
                            : 'View doctors from other cities',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FindDoctorsSearchBar(
              findBloc: findBloc,
            ),
          ),
        ],
      ),
    );
  }

  void _applyRadius(BuildContext context, String value) {
    double? radius = double.tryParse(value);
    if (radius != null && radius > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Updating search radius to ${radius.toStringAsFixed(0)}km...'),
          duration: const Duration(seconds: 1),
        ),
      );

      context.read<FindBloc>().add(SetSearchRadiusEvent(radius: radius));
    }
  }
}
