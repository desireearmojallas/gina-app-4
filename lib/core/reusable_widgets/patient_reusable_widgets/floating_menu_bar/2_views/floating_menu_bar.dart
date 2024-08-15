import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/bloc/floating_menu_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/1_controllers/patient_auth_controller.dart';

class FloatingMenuWidget extends StatelessWidget {
  const FloatingMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final floatingMenuBloc = context.read<FloatingMenuBloc>();
    final textStyle = ginaTheme.textTheme.titleMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
    return SubmenuButton(
      onOpen: () {
        floatingMenuBloc.add(GetPatientNameEvent());
      },
      style: const ButtonStyle(
        shape: MaterialStatePropertyAll<CircleBorder>(
          CircleBorder(
            side: BorderSide(
              color: GinaAppTheme.appbarColorLight,
            ),
          ),
        ),
      ),
      menuStyle: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(
          GinaAppTheme.appbarColorLight,
        ),
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
            ),
          ),
        ),
      ),
      menuChildren: [
        MenuItemButton(
          child: Row(
            children: [
              Image.asset(
                Images.profileIcon,
                width: 35,
              ),
              const Gap(10),
              BlocBuilder<FloatingMenuBloc, FloatingMenuState>(
                builder: (context, state) {
                  if (state is GetPatientName) {
                    return Text(
                      state.patientName,
                      style: ginaTheme.textTheme.headlineSmall?.copyWith(
                        fontSize: 15,
                      ),
                    );
                  }
                  return const Text('Loading...');
                },
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.2,
          height: 3,
        ),
        MenuItemButton(
          child: Row(
            children: [
              const Icon(
                Icons.emergency,
                size: 30,
                color: GinaAppTheme.lightOnPrimaryColor,
              ),
              const Gap(10),
              Text(
                'Emergency \nAnnouncements',
                style: textStyle,
              ),
            ],
          ),
          onPressed: () {
            // TODO: EMERGENCY ANNOUNCEMENTS ROUTE
            // Navigator.pushNamed(context, '/emergencyAnnouncements');
          },
        ),
        const Divider(
          thickness: 0.2,
          height: 3,
        ),
        MenuItemButton(
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 32,
                color: GinaAppTheme.lightOnPrimaryColor,
              ),
              const Gap(10),
              Text(
                'About Us',
                style: textStyle,
              ),
            ],
          ),
          onPressed: () {
            // TODO: ABOUT US ROUTE
            Navigator.pushNamed(context, '/aboutUs');
          },
        ),
        const Divider(
          thickness: 0.2,
          height: 3,
        ),
        MenuItemButton(
          child: Row(
            children: [
              const Icon(
                Icons.logout_outlined,
                size: 32,
                color: GinaAppTheme.lightOnPrimaryColor,
              ),
              const Gap(10),
              Text(
                'Logout',
                style: textStyle,
              ),
            ],
          ),
          onPressed: () {
            AuthenticationController().logout().then(
                  (value) => {
                    SharedPreferencesManager().logout,
                    Navigator.pushReplacementNamed(context, '/login'),
                  },
                );
          },
        ),
      ],
      child: Image.asset(Images.profileIcon, width: 40),
    );
  }
}
