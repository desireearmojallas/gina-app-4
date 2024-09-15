import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/bloc/floating_menu_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/1_controllers/patient_auth_controller.dart';
import 'package:badges/badges.dart' as badges;

class FloatingMenuWidget extends StatelessWidget {
  bool?
      hasNotification; //TODO: TO CHANGE THIS, ADD LOGIC TO NOTIFICATION INDICATOR FOR AVATAR MENU BUTTON
  FloatingMenuWidget({super.key, this.hasNotification});

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
              color: Colors.transparent,
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
              CircleAvatar(
                radius: 20,
                foregroundImage: AssetImage(Images.patientProfileIcon),
                backgroundColor: GinaAppTheme.lightPrimaryColor,
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
              Stack(
                children: [
                  const Icon(
                    Icons.emergency,
                    size: 30,
                    color: GinaAppTheme.lightOnPrimaryColor,
                  ),
                  if (hasNotification == true) notificationCircle(),
                ],
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
      // child: Stack(
      //   children: [
      //     CircleAvatar(
      //       radius: 20,
      //       foregroundImage: AssetImage(Images.patientProfileIcon),
      //       backgroundColor: GinaAppTheme.lightPrimaryColor,
      //     ),
      //     if (hasNotification == true) notificationCircle(),
      //   ],
      // ),

      // TODO: BADGE LOGIC FOR FLOATING MENU BAR
      child: badges.Badge(
        badgeContent: const Text(
          '3',
          style: TextStyle(color: Colors.white),
        ),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: GinaAppTheme.lightTertiaryContainer,
        ),
        position: badges.BadgePosition.topEnd(top: -8, end: -7),
        child: CircleAvatar(
          foregroundImage: AssetImage(Images.patientProfileIcon),
          backgroundColor: GinaAppTheme.lightPrimaryColor,
        ),
      ),
    );
  }

  Widget notificationCircle() {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: GinaAppTheme.lightTertiaryContainer,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
