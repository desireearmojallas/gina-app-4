import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/floating_doctor_menu_bar/bloc/floating_doctor_menu_bar_bloc.dart';
import 'package:gina_app_4/core/storage/shared_preferences/shared_preferences_manager.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/1_controllers/doctor_auth_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:icons_plus/icons_plus.dart';

class FloatingDoctorMenuWidget extends StatelessWidget {
  final bool?
      hasNotification; //TODO: TO CHANGE THIS, ADD LOGIC TO NOTIFICATION INDICATOR FOR AVATAR MENU BUTTON
  const FloatingDoctorMenuWidget({super.key, this.hasNotification});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final floatingDoctorMenuBarBloc = context.read<FloatingDoctorMenuBarBloc>();
    final textStyle = ginaTheme.textTheme.titleMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
    return SubmenuButton(
      onOpen: () {
        floatingDoctorMenuBarBloc.add(GetDoctorNameEvent());
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
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                foregroundImage: AssetImage(Images.doctorProfileIcon1),
                backgroundColor: Colors.transparent,
              ),
              const Gap(10),
              BlocBuilder<FloatingDoctorMenuBarBloc,
                  FloatingDoctorMenuBarState>(
                builder: (context, state) {
                  if (state is GetDoctorName) {
                    return Text(
                      'Dr. ${state.doctorName}',
                      style: ginaTheme.textTheme.headlineSmall?.copyWith(
                        fontSize: 15,
                      ),
                    );
                  }
                  return const Text('Loading...');
                },
              ),
              const Gap(8),
              const Icon(
                Icons.verified,
                color: Colors.blue,
                size: 18,
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
                    MingCute.clipboard_line,
                    size: 22,
                    color: GinaAppTheme.lightOnPrimaryColor,
                  ),
                  // if (hasNotification == true) notificationCircle(),
                ],
              ),
              const Gap(10),
              Text(
                'Patients List',
                style: textStyle,
              ),
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/doctorPatientsList');
          },
        ),
        const Divider(
          thickness: 0.2,
          height: 3,
        ),
        MenuItemButton(
          child: Row(
            children: [
              const Stack(
                children: [
                  Icon(
                    CupertinoIcons.star_circle,
                    size: 22,
                    color: GinaAppTheme.lightOnPrimaryColor,
                  ),
                ],
              ),
              const Gap(10),
              Text(
                'Forum Doctor Badge',
                style: textStyle,
              ),
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/doctorForumBadge');
          },
        ),
        const Divider(
          thickness: 0.2,
          height: 3,
        ),
        MenuItemButton(
          child: Row(
            children: [
              const Stack(
                children: [
                  Icon(
                    MingCute.tag_2_line,
                    size: 22,
                    color: GinaAppTheme.lightOnPrimaryColor,
                  ),
                ],
              ),
              const Gap(10),
              Text(
                'Consultation Fee',
                style: textStyle,
              ),
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/doctorConsultationFee');
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
            debugPrint('logout clicked floating doctor menu bar');
            DoctorAuthenticationController().logout().then((value) => {
                  SharedPreferencesManager().logout(),
                  Navigator.pushReplacementNamed(context, '/login'),
                });
          },
        ),
      ],

      child: CircleAvatar(
        foregroundImage: AssetImage(Images.doctorProfileIcon1),
        backgroundColor: Colors.transparent,
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
      //     foregroundImage: AssetImage(Images.doctorProfileIcon1),
      //     backgroundColor: Colors.transparent,
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
