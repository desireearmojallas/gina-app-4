import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_bottom_navigation/bloc/doctor_bottom_navigation_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorBottomNavigationProvider extends StatelessWidget {
  const DoctorBottomNavigationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DoctorBottomNavigationBloc>(),
      child: const DoctorBottomNavigation(),
    );
  }
}

class DoctorBottomNavigation extends StatelessWidget {
  const DoctorBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final currentIndex =
            context.read<DoctorBottomNavigationBloc>().state.currentIndex;
        if (currentIndex == 0) {
          return true;
        } else {
          context.read<DoctorBottomNavigationBloc>().add(BackPressedEvent());
          return false;
        }
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: BlocBuilder<DoctorBottomNavigationBloc,
            DoctorBottomNavigationState>(
          builder: (context, state) {
            return CrystalNavigationBar(
              currentIndex: state.currentIndex,
              unselectedItemColor: state.currentIndex == 4
                  ? Colors.white
                  : GinaAppTheme.lightOutline.withOpacity(0.5),
              onTap: (index) {
                context
                    .read<DoctorBottomNavigationBloc>()
                    .add(TabChangedEvent(tab: index));
              },
              backgroundColor: Colors.white.withOpacity(0.1),
              outlineBorderColor: Colors.white.withOpacity(0.1),
              items: [
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 0
                      ? MingCute.home_4_fill
                      : MingCute.home_4_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 1
                      ? MingCute.calendar_fill
                      : MingCute.calendar_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 2
                      ? MingCute.message_3_fill
                      : MingCute.message_3_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 3
                      ? MingCute.comment_2_fill
                      : MingCute.comment_2_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: state.currentIndex == 4
                      ? MingCute.user_3_fill
                      : MingCute.user_3_line,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
              ],
            );
          },
        ),
        body: BlocBuilder<DoctorBottomNavigationBloc,
            DoctorBottomNavigationState>(
          builder: (context, state) {
            return state.selectedScreen;
          },
        ),
      ),
    );
  }
}