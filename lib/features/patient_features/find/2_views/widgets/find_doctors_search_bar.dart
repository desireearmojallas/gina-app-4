import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class FindDoctorsSearchBar extends StatelessWidget {
  final FindBloc findBloc;
  const FindDoctorsSearchBar({super.key, required this.findBloc});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);
    return Center(
      child: SizedBox(
        height: 50,
        width: width / 1.05,
        child: BlocBuilder<FindBloc, FindState>(
          bloc: findBloc,
          builder: (context, state) {
            return SearchAnchor(
              headerTextStyle:
                  Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: GinaAppTheme.lightOnPrimaryColor,
                        fontSize: 15,
                      ),
              isFullScreen: false,
              viewBackgroundColor: Colors.white,
              viewElevation: 0.0,
              viewShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              viewConstraints: const BoxConstraints(
                minHeight: 100,
                maxHeight: 350,
              ),
              dividerColor: GinaAppTheme.lightSurfaceVariant,
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    ginaTheme.textTheme.titleMedium!.copyWith(
                      color: GinaAppTheme.lightOnPrimaryColor,
                      fontSize: 15,
                    ),
                  ),
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      MingCute.search_2_line,
                      color: Colors.grey,
                    ),
                  ),
                  hintText: 'Search for doctor\'s name',
                  hintStyle: MaterialStateProperty.all<TextStyle>(
                    ginaTheme.textTheme.titleMedium!.copyWith(
                      color: GinaAppTheme.lightOutline,
                      fontSize: 15,
                    ),
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    GinaAppTheme.lightOnTertiary,
                  ),
                  onTap: () {
                    findBloc.add(GetAllDoctorsEvent());
                  },
                  onChanged: (value) {
                    controller.openView();
                    controller.text = value;
                  },
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                final filteredDoctors = getAllDoctors!
                    .where((doctor) => doctor.name
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                    .toList();

                if (filteredDoctors.isEmpty) {
                  return [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 120.0),
                      child: Center(
                        child: Text(
                          'No doctors found',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: GinaAppTheme.lightOnPrimaryColor,
                                    fontSize: 15,
                                  ),
                        ),
                      ),
                    ),
                  ];
                }
                return filteredDoctors.map((doctor) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(Images.doctorProfileIcon1),
                    ),
                    title: Text(
                      'Dr. ${doctor.name}',
                      style: const TextStyle(
                        color: GinaAppTheme.lightOnPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      doctor.medicalSpecialty,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: GinaAppTheme.lightOutline,
                            fontSize: 10,
                          ),
                    ),
                    onTap: () {
                      controller.closeView(doctor.name);
                      findBloc.add(
                        FindNavigateToDoctorDetailsEvent(doctor: doctor),
                      );
                    },
                  );
                });
                // return [];
              },
            );
          },
        ),
      ),
    );
  }
}
