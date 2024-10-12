import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/floating_menu_bar/2_views/floating_menu_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/bloc/find_bloc.dart';
import 'package:gina_app_4/features/patient_features/find/2_views/screens/view_states/find_screen_loaded.dart';

class FindScreenProvider extends StatelessWidget {
  const FindScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final findBloc = sl<FindBloc>();
        // add get doctors near me event
        // add get doctors in the nearest city event
        // add get all doctor event

        return findBloc;
      },
      child: const FindScreen(),
    );
  }
}

class FindScreen extends StatelessWidget {
  const FindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final findBloc = context.read<FindBloc>();
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
          actions: [
            FloatingMenuWidget(),
            const Gap(10),
          ],
          surfaceTintColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.1),
        ),
        body: BlocConsumer<FindBloc, FindState>(
          listenWhen: (previous, current) => current is FindActionState,
          buildWhen: (previous, current) => current is! FindActionState,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return const FindScreenLoaded();
          },
        ));
  }
}
