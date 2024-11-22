import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/screens/view_states/doctor_emergency_announcement_patient_list.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorEmergencyAnnouncementCreateAnnouncementScreen
    extends StatelessWidget {
  DoctorEmergencyAnnouncementCreateAnnouncementScreen({super.key});

  final TextEditingController emergencyMessageController =
      TextEditingController();
  final int characterLimit = 280;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    final TextEditingController patientChosenController = TextEditingController(
        //todo: bloc event here to get the chosen patient and display
        );

    //! temporary scaffold. will replace once bloc is implemented
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: size.height * 0.05,
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            'To',
                            style: ginaTheme.titleSmall?.copyWith(
                              color: GinaAppTheme.lightOutline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: size.width * 0.8,
                          height: size.height * 0.05,
                          child: TextFormField(
                            readOnly: true,
                            controller: patientChosenController,
                            maxLines: 1,
                            style: ginaTheme.bodyMedium,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  //! temporary route
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DoctorEmergencyAnnouncementPatientList(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  MingCute.user_add_2_line,
                                  color: GinaAppTheme.lightOnPrimaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: emergencyMessageController,
                    maxLines: 18,
                    maxLength: characterLimit,
                    style: ginaTheme.bodyMedium,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Write emergency announcement here...',
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                      counterStyle: TextStyle(
                        color: GinaAppTheme.lightOutline,
                      ),
                    ),
                  ),
                ),
                const Gap(250),
                SizedBox(
                  width: size.width * 0.9,
                  height: size.height * 0.05,
                  child: FilledButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
