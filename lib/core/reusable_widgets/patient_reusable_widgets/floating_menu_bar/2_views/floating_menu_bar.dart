import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/bloc/floating_menu_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/1_controllers/patient_auth_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gina_app_4/features/patient_features/profile/2_views/screens/profile_screen.dart';
import 'package:icons_plus/icons_plus.dart';

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
      menuStyle: MenuStyle(
        backgroundColor: const MaterialStatePropertyAll<Color>(
          GinaAppTheme.appbarColorLight,
        ),
        elevation: const MaterialStatePropertyAll<double>(0.5),
        shadowColor: MaterialStatePropertyAll<Color>(
          Colors.black.withOpacity(0.2),
        ),
        shape: const MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
            ),
          ),
        ),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreenProvider(),
              ),
            );
          },
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
        // MenuItemButton(
        //   child: Row(
        //     children: [
        //       Stack(
        //         children: [
        //           const Icon(
        //             MingCute.notification_line,
        //             size: 20,
        //             color: GinaAppTheme.lightOnPrimaryColor,
        //           ),
        //           if (hasNotification == true) notificationCircle(),
        //         ],
        //       ),
        //       const Gap(10),
        //       Text(
        //         'Notifications',
        //         style: textStyle,
        //       ),
        //     ],
        //   ),
        //   onPressed: () {
        //     // TODO: EMERGENCY ANNOUNCEMENTS ROUTE
        //     // Navigator.pushNamed(context, '/emergencyAnnouncements');
        //   },
        // ),
        // const Divider(
        //   thickness: 0.2,
        //   height: 3,
        // ),
        MenuItemButton(
          child: Row(
            children: [
              const Stack(
                children: [
                  Icon(
                    Icons.emergency_outlined,
                    size: 22,
                    color: GinaAppTheme.lightOnPrimaryColor,
                  ),
                  // if (hasNotification == true) notificationCircle(),
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
            Navigator.pushNamed(context, '/emergencyAnnouncements');
          },
        ),
        const Divider(
          thickness: 0.2,
          height: 3,
        ),
        MenuItemButton(
          child: Row(
            children: [
              const Gap(2),
              const Icon(
                Bootstrap.info_circle,
                size: 18,
                color: GinaAppTheme.lightOnPrimaryColor,
              ),
              const Gap(8),
              Text(
                'About Us',
                style: textStyle,
              ),
            ],
          ),
          onPressed: () {
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
              const Gap(2),
              const Icon(
                MingCute.exit_line,
                size: 20,
                color: GinaAppTheme.lightOnPrimaryColor,
              ),
              const Gap(8),
              Text(
                'Logout',
                style: textStyle,
              ),
            ],
          ),
          onPressed: () {
            debugPrint('logout clicked floating menu bar');
            AuthenticationController().logout().then((value) => {
                  SharedPreferencesManager().logout(),
                  Navigator.pushReplacementNamed(context, '/login'),
                });
          },
        ),
      ],

      child: CircleAvatar(
        foregroundImage: AssetImage(Images.patientProfileIcon),
        backgroundColor: GinaAppTheme.lightPrimaryColor,
      ),

      // TODO: BADGE LOGIC FOR FLOATING MENU BAR
      // child: badges.Badge(
      //   badgeContent: const Text(
      //     '3',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   badgeStyle: const badges.BadgeStyle(
      //     badgeColor: GinaAppTheme.lightTertiaryContainer,
      //   ),
      //   position: badges.BadgePosition.topEnd(top: -8, end: -7),
      //   child: CircleAvatar(
      //     foregroundImage: AssetImage(Images.patientProfileIcon),
      //     backgroundColor: GinaAppTheme.lightPrimaryColor,
      //   ),
      // ),
    );
  }

  Widget notificationCircle() {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: GinaAppTheme.lightTertiaryContainer,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
