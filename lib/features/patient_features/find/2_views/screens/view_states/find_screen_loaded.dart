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
                findBloc.add(GetDoctorsInTheNearestCityEvent());
                findBloc.add(GetAllDoctorsEvent());
              },
              child: ScrollbarCustom(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
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
                                  const TextSpan(text: ' doctor(s) near you!'),
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
                      const Gap(20),
                      BlocBuilder<FindBloc, FindState>(
                        builder: (context, state) {
                          if (state is OtherCitiesVisibleState) {
                            return Column(
                              children: [
                                // const Gap(20),

                                //--- Cebu City ---
                                const Gap(10),
                                const Divider(
                                  color: GinaAppTheme.lightSurfaceVariant,
                                ),
                                const Gap(10),
                                Row(
                                  children: [
                                    const Gap(10),
                                    Image.asset(
                                      Images.officeAddressLogo,
                                      width: 20,
                                    ),
                                    const Gap(10),
                                    Text(
                                      'Other Cities',
                                      style: ginaTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color: GinaAppTheme.lightOnPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const Gap(20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Cebu City',
                                      style: ginaTheme.textTheme.titleLarge
                                          ?.copyWith(
                                        color: GinaAppTheme.lightOnPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(20),
                                Column(
                                  children: List.generate(3, (index) {
                                    return const Column(
                                      children: [
                                        DoctorsInTheNearestCity(),
                                        Gap(20),
                                      ],
                                    );
                                  }),
                                ),

                                //--- Lapu-Lapu City ---
                                const Gap(10),
                                const Divider(
                                  color: GinaAppTheme.lightSurfaceVariant,
                                ),
                                const Gap(20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Lapu-Lapu City',
                                      style: ginaTheme.textTheme.titleLarge
                                          ?.copyWith(
                                        color: GinaAppTheme.lightOnPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(20),
                                Column(
                                  children: List.generate(5, (index) {
                                    return const Column(
                                      children: [
                                        DoctorsInTheNearestCity(),
                                        Gap(20),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: bottomPadding),
                      // ),
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
                        if (state is OtherCitiesVisibleState) {
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
                        state is OtherCitiesVisibleState
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                        size: 18,
                      ),
                      const Gap(8),
                      Text(
                        state is OtherCitiesVisibleState
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
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FindDoctorsSearchBar(),
          ),
        ],
      ),
    );
  }
}
