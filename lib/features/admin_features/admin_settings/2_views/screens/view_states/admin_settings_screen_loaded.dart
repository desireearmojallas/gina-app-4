import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/2_views/widgets/payment_validity_widget.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/2_views/widgets/platform_fee_settings_widget.dart';
import 'package:gina_app_4/features/admin_features/admin_settings/2_views/widgets/user_management_widget.dart';

class AdminSettingsScreenLoaded extends StatelessWidget {
  const AdminSettingsScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 22.0),
        child: Container(
          height: size.height * 1.02,
          width: size.width / 1.15,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  'Platform Settings',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: const [
                          Tab(text: 'Platform Fee'),
                          Tab(text: 'Payment Validity'),
                          Tab(text: 'User Management'),
                        ],
                        labelStyle: ginaTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GinaAppTheme.lightTertiaryContainer,
                          fontSize: 17,
                        ),
                        unselectedLabelStyle: ginaTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: GinaAppTheme.lightOutline,
                        ),
                        indicatorColor: GinaAppTheme.lightTertiaryContainer,
                        dividerColor: Colors.transparent,
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            PlatformFeeSettingsWidget(),
                            PaymentValidityWidget(),
                            UserManagementWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
