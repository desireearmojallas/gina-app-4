import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNavigationProvider extends StatelessWidget {
  const BottomNavigationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomNavigationBloc>(
      create: (context) => sl<BottomNavigationBloc>(),
      child: const BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final currentIndex =
            context.read<BottomNavigationBloc>().state.currentIndex;
        if (currentIndex == 0) {
          return true;
        } else {
          context.read<BottomNavigationBloc>().add(BackPressedEvent());
          return false;
        }
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar:
            BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return CrystalNavigationBar(
              currentIndex: state.currentIndex,
              unselectedItemColor: state.currentIndex == 4
                  ? Colors.white
                  : GinaAppTheme.lightOutline.withOpacity(0.5),
              onTap: (index) {
                context
                    .read<BottomNavigationBloc>()
                    .add(TabChangedEvent(tab: index));
              },
              backgroundColor: Colors.white.withOpacity(0.1),
              outlineBorderColor: Colors.white.withOpacity(0.1),
              items: [
                CrystalNavigationBarItem(
                  icon: MingCute.home_4_fill,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: MingCute.search_2_fill,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: MingCute.message_3_fill,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: MingCute.comment_2_fill,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
                CrystalNavigationBarItem(
                  icon: MingCute.user_3_fill,
                  selectedColor: GinaAppTheme.lightTertiaryContainer,
                ),
              ],
            );
          },
        ),
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return state.selectedScreen;
          },
        ),
      ),
    );
  }
}
