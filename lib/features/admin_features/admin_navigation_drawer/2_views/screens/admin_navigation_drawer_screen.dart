import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_login/1_controllers/admin_login_controllers.dart';
import 'package:gina_app_4/features/admin_features/admin_login/2_views/widgets/admin_container_text_widget.dart';
import 'package:gina_app_4/features/admin_features/admin_navigation_drawer/2_views/bloc/admin_navigation_drawer_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';

class AdminNavigationDrawerProvider extends StatelessWidget {
  const AdminNavigationDrawerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminNavigationDrawerBloc>(
      create: (context) => AdminNavigationDrawerBloc(),
      child: const AdminNavigationDrawer(),
    );
  }
}

class AdminNavigationDrawer extends StatelessWidget {
  const AdminNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminLoginControllers adminLoginControllers = AdminLoginControllers();
    final adminNavigationDrawerBloc = context.read<AdminNavigationDrawerBloc>();
    final ginaTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocBuilder<AdminNavigationDrawerBloc, AdminNavigationDrawerState>(
        builder: (context, state) {
          return Scaffold(
            body: BlocBuilder<AdminNavigationDrawerBloc,
                AdminNavigationDrawerState>(
              builder: (context, state) {
                return Container(
                  color: GinaAppTheme.appbarColorLight,
                  child: Row(
                    children: [
                      NavigationDrawer(
                        backgroundColor: GinaAppTheme.appbarColorLight,
                        elevation: 0,
                        selectedIndex: state.currentIndex,
                        indicatorShape: const BeveledRectangleBorder(),
                        tilePadding: const EdgeInsets.only(bottom: 5),
                        onDestinationSelected: (index) {
                          adminNavigationDrawerBloc
                              .add(TabChangedEvent(tab: index));
                        },
                        children: [
                          const Gap(40),
                          SvgPicture.asset(
                            Images.appLogo,
                            height: 120,
                          ),
                          GinaHeader(size: 50),
                          Align(
                            alignment: Alignment.center,
                            child: adminContainerTextWidget(),
                          ),
                          const Gap(40),
                          NavigationDrawerDestination(
                            icon: const Icon(
                              Icons.dashboard_outlined,
                            ),
                            selectedIcon: const Icon(
                              Icons.dashboard_rounded,
                            ),
                            label: Text(
                              'Dashboard',
                              style: ginaTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          NavigationDrawerDestination(
                            icon: const Icon(
                              Icons.verified_outlined,
                            ),
                            selectedIcon: const Icon(
                              Icons.verified_rounded,
                            ),
                            label: Text(
                              'Verify',
                              style: ginaTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          NavigationDrawerDestination(
                            icon: const Icon(
                              Icons.badge_outlined,
                            ),
                            selectedIcon: const Icon(
                              Icons.badge_rounded,
                            ),
                            label: Text(
                              'Doctors',
                              style: ginaTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          NavigationDrawerDestination(
                            icon: const Icon(
                              Icons.face_3_outlined,
                            ),
                            selectedIcon: const Icon(
                              Icons.face_3_rounded,
                            ),
                            label: Text(
                              'Patients',
                              style: ginaTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Gap(330),
                          Center(
                            child: Text(
                              'Version 2.0.0\n© 2024 Desiree Armojallas',
                              style: ginaTheme.bodySmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Gap(20),
                          InkWell(
                            onTap: () async {
                              adminLoginControllers.adminLogout();
                              Navigator.pushReplacementNamed(
                                  context, '/adminLogin');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    color: GinaAppTheme.lightOnPrimaryColor,
                                    size: 25,
                                  ),
                                  const Gap(18),
                                  Text(
                                    'Logout',
                                    style: ginaTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: BlocBuilder<AdminNavigationDrawerBloc,
                          AdminNavigationDrawerState>(
                        builder: (context, state) {
                          return state.selectedScreen;
                        },
                      )),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
