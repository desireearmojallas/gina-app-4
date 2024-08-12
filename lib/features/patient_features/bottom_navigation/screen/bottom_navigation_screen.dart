import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/bottom_navigation/bloc/bottom_navigation_bloc.dart';

class BottomNavigationProvider extends StatelessWidget {
  const BottomNavigationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomNavigationBloc>(
      create: (context) => BottomNavigationBloc(),
      child: const BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar:
        BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: state.currentIndex,
            onDestinationSelected: (index) {
              context
                  .read<BottomNavigationBloc>()
                  .add(TabChangedEvent(tab: index));
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.home_rounded,
                  color: GinaAppTheme.lightOutline,
                  size: 26.0,
                ),
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: GinaAppTheme.lightOnSelectedColorNavBar,
                  size: 32.0,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.search,
                  color: GinaAppTheme.lightOutline,
                  size: 28.0,
                ),
                selectedIcon: Icon(
                  Icons.search,
                  color: GinaAppTheme.lightOnSelectedColorNavBar,
                  size: 34.0,
                ),
                label: 'Find',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.chat,
                  color: GinaAppTheme.lightOutline,
                  size: 26.0,
                ),
                selectedIcon: Icon(
                  Icons.chat,
                  color: GinaAppTheme.lightOnSelectedColorNavBar,
                  size: 32.0,
                ),
                label: 'Appointments',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.forum_outlined,
                  color: GinaAppTheme.lightOutline,
                  size: 26.0,
                ),
                selectedIcon: Icon(
                  Icons.forum_outlined,
                  color: GinaAppTheme.lightOnSelectedColorNavBar,
                  size: 32.0,
                ),
                label: 'Forums',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person,
                  color: GinaAppTheme.lightOutline,
                  size: 26.0,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  color: GinaAppTheme.lightOnSelectedColorNavBar,
                  size: 32.0,
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    ), body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return state.selectedScreen;
      },
    ));
  }
}
