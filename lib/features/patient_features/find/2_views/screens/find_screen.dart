import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/floating_menu_bar.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/screens/view_states/find_screen_loaded.dart';

class FindScreenProvider extends StatelessWidget {
  const FindScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const FindScreen();
  }
}

class FindScreen extends StatelessWidget {
  const FindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    // final findBloc = context.read<FindBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        notificationPredicate: (notification) => false,
        title: Text(
          'Find Doctors',
          style: ginaTheme.textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          FloatingMenuWidget(),
          Gap(10),
        ],
        surfaceTintColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.1),
      ),
      body: const FindScreenLoaded(),
    );
  }
}
